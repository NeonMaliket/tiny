import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit() : super(MessageInitial());

  Future<List<ChatMessage>> fetchMessages({
    required int chatId,
  }) async {
    logger.info("Fetching messages for chatId: $chatId");
    emit(MessagesFetching());
    try {
      final messages = await getIt<ChatMessageRepository>()
          .fetchChatHistory(chatId);
      logger.info("Fetched ${messages.length} messages");
      emit(MessagesLoaded(messages));
      return messages;
    } catch (e, st) {
      addError(e, st);
      logger.error("Error: ", e);
      emit(MessagesFetchError('Failed to fetch messages'));
      return [];
    }
  }

  Stream<ChatMessage> subscribeOnChat(final int chatId) async* {
    try {
      await for (final message
          in getIt<ChatMessageRepository>().subscribeToChat(chatId)) {
        emit(MessageReceived(message));
        yield message;
      }
    } catch (e, st) {
      addError(e, st);
      logger.error("Error: ", e);
      emit(MessageStreamigError('Failed to stream messages'));
    }
  }
}
