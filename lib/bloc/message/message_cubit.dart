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
    logger.info("Sending message... $message");
    emit(MessageSending());
    try {
      yield* getIt<ChatMessageRepository>().sendMessage(
        chatId,
        message,
        messageType: 'TEXT',
      );
      emit(MessageSent());
    } catch (e, st) {
      logger.error("Message sending error", e, st);
      emit(MessageError('Failed to send message'));
    }
  }

  Stream<MessageChunk> sendVoiceMessage({
    required int chatId,
    required String voicePath,
  }) async* {
    emit(MessageSending());
    logger.info("Sending voice message... $voicePath");
    try {
      yield* getIt<ChatMessageRepository>().sendVoiceMessage(
        chatId: chatId,
        voicePath: voicePath,
      );
      emit(MessageSent());
    } catch (e, st) {
      logger.error("Voice message sending error", e, st);
      emit(MessageError('Failed to send voice message'));
    }
  }

  Stream<ChatMessage> subscribeOnChat(final int chatId) async* {
    emit(MessageStreamingSubscription());
    try {
      yield* getIt<ChatMessageRepository>().subscribeToChat(chatId);
      emit(MessageStreamingSubscribed());
    } catch (e) {
      logger.error("Error: ", e);
      emit(MessageStreamigError('Failed to stream messages'));
    }
  }
}
