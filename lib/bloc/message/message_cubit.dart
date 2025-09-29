// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  Stream<MessageChunk> sendMessage({
    required String chatId,
    required String message,
  }) async* {
    emit(MessageSending());
    try {
      yield* getIt<ChatMessageRepository>().sendMessage(chatId, message);
      emit(MessageSent());
    } catch (e, st) {
      logger.e("Message sending error", error: e, stackTrace: st);
      emit(MessageError(e.toString()));
    }
  }

  Stream<ChatMessage> subscribeOnChat(final String chatId) async* {
    emit(MessageStreamingSubscription());
    try {
      yield* getIt<ChatMessageRepository>().subscribeToChat(chatId);

      emit(MessageStreamingSubscribed());
    } catch (e) {
      logger.e("Error: ", error: e);
      emit(MessageStreamigError(e.toString()));
    }
  }
}
