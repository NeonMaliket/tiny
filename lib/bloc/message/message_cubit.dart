// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_alert.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

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
      yield* getIt<ChatMessageRepository>().sendMessage(chatId, message);
      emit(MessageSent());
    } catch (e, st) {
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to send message',
        ),
      );
      logger.e("Message sending error", error: e, stackTrace: st);
      emit(MessageError(e.toString()));
    }
  }

  Stream<ChatMessage> subscribeOnChat(final int chatId) async* {
    emit(MessageStreamingSubscription());
    try {
      yield* getIt<ChatMessageRepository>().subscribeToChat(chatId);

      emit(MessageStreamingSubscribed());
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
