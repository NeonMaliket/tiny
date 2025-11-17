import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  Stream<MessageChunk> sendMessage({
    required int chatId,
    required String message,
  }) async* {
    emit(MessageSending());
    try {
      yield* getIt<ChatMessageRepository>().sendMessage(
        chatId,
        message,
      );
      emit(MessageSent());
    } catch (e, st) {
      logger.e("Message sending error", error: e, stackTrace: st);
      emit(MessageError('Failed to send message'));
    }
  }

  Stream<MessageChunk> sendVoiceMessage({
    required int chatId,
    required String voicePath,
  }) async* {
    emit(MessageSending());
    logger.i("Sending voice message... $voicePath");
    try {
      yield* getIt<ChatMessageRepository>().sendVoiceMessage(
        chatId: chatId,
        voicePath: voicePath,
      );
      emit(MessageSent());
    } catch (e, st) {
      logger.e(
        "Voice message sending error",
        error: e,
        stackTrace: st,
      );
      emit(MessageError('Failed to send voice message'));
    }
  }

  Stream<ChatMessage> subscribeOnChat(final int chatId) async* {
    emit(MessageStreamingSubscription());
    try {
      yield* getIt<ChatMessageRepository>().subscribeToChat(chatId);
      emit(MessageStreamingSubscribed());
    } catch (e) {
      logger.e("Error: ", error: e);
      emit(MessageStreamigError('Failed to stream messages'));
    }
  }
}
