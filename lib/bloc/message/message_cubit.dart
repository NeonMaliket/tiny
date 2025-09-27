// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/chat_message_repository.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  MessageCubit({required CyberpunkAlertBloc cyberpunkAlertBloc})
    : _cyberpunkAlertBloc = cyberpunkAlertBloc,
      super(MessageInitial());

  final CyberpunkAlertBloc _cyberpunkAlertBloc;

  Stream<MessageChunk> sendMessage({
    required int chatId,
    required String message,
  }) async* {
    emit(MessageSending());
    try {
      final messageRepo = getIt<ChatMessageRepository>();
      messageRepo.sendMessage(
        ChatMessage(
          content: message,
          createdAt: DateTime.now(),
          author: ChatMessageAuthor.user,
          chatId: chatId,
        ),
      );
      //TODO fix it
      yield MessageChunk(chunk: message, isLast: true);
    } catch (e) {
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to send message',
        ),
      );
      logger.e("Error: ", error: e);
      emit(MessageStreamigError(e.toString()));
    }
  }

  Stream<ChatMessage> subscribeOnChat(final int chatId) async* {
    emit(MessageStreamigSubscribtion());
    try {
      final stream = getIt<ChatMessageRepository>().streamChatMessages(chatId);
      await for (final message in stream) {
        yield message;
      }
    } catch (e) {
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to stream messages',
        ),
      );
      logger.e("Error: ", error: e);
      emit(MessageStreamigError(e.toString()));
    }
  }
}
