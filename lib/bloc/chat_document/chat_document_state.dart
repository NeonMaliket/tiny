part of 'chat_document_bloc.dart';

sealed class ChatDocumentState extends Equatable {
  const ChatDocumentState();

  @override
  List<Object> get props => [];
}

final class ChatDocumentInitial extends ChatDocumentState {
  const ChatDocumentInitial();
}

final class ConnectingDocumentState extends ChatDocumentState {
  const ConnectingDocumentState(this.documentId);

  final int documentId;

  @override
  List<Object> get props => [documentId];
}

final class DocumentConnectedState extends ChatDocumentState {
  const DocumentConnectedState(this.chatId, this.document);

  final int chatId;
  final DocumentMetadata document;

  @override
  List<Object> get props => [chatId, document];
}

final class DisconnectingDocumentState extends ChatDocumentState {
  const DisconnectingDocumentState(this.documentId);

  final int documentId;

  @override
  List<Object> get props => [documentId];
}

final class DocumentDisconnectedState extends ChatDocumentState {
  const DocumentDisconnectedState(this.chatId, this.documentId);
  final int chatId;
  final int documentId;

  @override
  List<Object> get props => [chatId, documentId];
}

final class ChatDocumentErrorState extends ChatDocumentState {
  final String message;
  const ChatDocumentErrorState({required this.message});

  @override
  List<Object> get props => [message];
}
