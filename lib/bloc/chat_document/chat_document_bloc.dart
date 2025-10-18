import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/repository/repository.dart';

part 'chat_document_event.dart';
part 'chat_document_state.dart';

class ChatDocumentBloc
    extends Bloc<ChatDocumentEvent, ChatDocumentState> {
  ChatDocumentBloc({required cyberpunkAlertBloc})
    : _cyberpunkAlertBloc = cyberpunkAlertBloc,
      super(ChatDocumentInitial()) {
    on<ConnectChatDocumentEvent>(_onConnectDocumentToChat);
    on<DisconnectChatDocumentEvent>(_onDisconnectDocumentFromChat);
  }

  final CyberpunkAlertBloc _cyberpunkAlertBloc;

  Future<void> _onConnectDocumentToChat(
    ConnectChatDocumentEvent event,
    Emitter<ChatDocumentState> emit,
  ) async {
    emit(ConnectingDocumentState(event.documentId));
    try {
      await getIt<ChatDocumentsRepository>().addDocumentToChat(
        event.chatId,
        event.documentId,
      );
      emit(DocumentConnectedState());
    } catch (e) {
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message:
              'Failed to connect document to chat: ${e.toString()}',
        ),
      );
      emit(ChatDocumentErrorState(message: e.toString()));
    }
  }

  Future<void> _onDisconnectDocumentFromChat(
    DisconnectChatDocumentEvent event,
    Emitter<ChatDocumentState> emit,
  ) async {
    emit(DisconnectingDocumentState(event.documentId));
    try {
      await getIt<ChatDocumentsRepository>().removeDocumentFromChat(
        event.chatId,
        event.documentId,
      );
      emit(DocumentDisconnectedState());
    } catch (e) {
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message:
              'Failed to disconnect document from chat: ${e.toString()}',
        ),
      );
      emit(ChatDocumentErrorState(message: e.toString()));
    }
  }
}
