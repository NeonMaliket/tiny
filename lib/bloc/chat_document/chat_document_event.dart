part of 'chat_document_bloc.dart';

sealed class ChatDocumentEvent extends Equatable {
  const ChatDocumentEvent();

  @override
  List<Object> get props => [];
}

class ConnectChatDocumentEvent extends ChatDocumentEvent {
  const ConnectChatDocumentEvent({
    required this.chatId,
    required this.document,
  });

  final int chatId;
  final DocumentMetadata document;

  @override
  List<Object> get props => [chatId, document];
}

class DisconnectChatDocumentEvent extends ChatDocumentEvent {
  const DisconnectChatDocumentEvent({
    required this.chatId,
    required this.documentId,
  });

  final int chatId;
  final int documentId;

  @override
  List<Object> get props => [chatId, documentId];
}
