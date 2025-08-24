import 'dart:convert';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:eventsource/eventsource.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';

part 'message_state.dart';

const _dataPreffix = 'data:';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  Stream<MessageChunk> sendMessage({
    required String chatId,
    required String message,
  }) async* {
    emit(MessageSending());
    try {
      final response = await dio.post(
        '$baseUrl/message/stream',
        data: {'chatId': chatId, 'prompt': message},
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Content-Type': 'application/json',
          },
          validateStatus: (s) => s != null && s < 500,
          sendTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(minutes: 30),
        ),
      );

      final lines = const LineSplitter().bind(
        utf8.decoder.bind(response.data.stream),
      );

      final resultSet = StringBuffer();

      await for (final line in lines) {
        emit(MessageHandling());
        if (line.isEmpty || line.startsWith(':')) continue;
        if (line.startsWith(_dataPreffix)) {
          final payload = line.substring(_dataPreffix.length);
          resultSet.write(payload);
          final chunk = MessageChunk.fromJson(payload);
          if (chunk.isLast) {
            emit(MessageSent());
          }
          yield chunk;
        }
      }
    } catch (e) {
      logger.e("Message sending error", error: e);
      emit(MessageError(e.toString()));
    }
  }

  Stream<ChatMessage> subscribeOnChat(final String chatId) async* {
    emit(MessageStreamigSubscribtion());
    try {
      final eventSource = await EventSource.connect(
        '$baseUrl/message/$chatId/stream',
      );

      eventSource.listen(
        null,
        onError: (dynamic error) {
          logger.e('Stream Events Error', error: error);
        },
        onDone: () {
          logger.i('Connection closed.');
        },
      );

      emit(MessageStreamigSubscribed());

      await for (final event in eventSource.asBroadcastStream()) {
        final String? data = event.data;
        logger.i('Event: ${event.event}');
        logger.i('Data: ${event.data}');
        if (data != null) {
          logger.i('type: ${ChatMessage.fromJson(data).author}');

          yield ChatMessage.fromJson(data);
        }
      }
    } catch (e) {
      logger.e("Error: ", error: e);
      emit(MessageStreamigError(e.toString()));
    }
  }
}
