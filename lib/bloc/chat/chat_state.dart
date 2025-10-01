part of 'chat_bloc.dart';

@immutable
sealed class ChatState extends Equatable {}

final class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

final class NewChatCreation extends ChatState {
  @override
  List<Object?> get props => [];
}

final class NewChatCreated extends ChatState {
  final Chat chat;

  NewChatCreated({required this.chat});

  @override
  List<Object?> get props => [chat];
}

final class ChatCreationError extends ChatState {
  final String error;

  ChatCreationError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class ChatListItemReceived extends ChatState {
  final Chat chat;

  ChatListItemReceived({required this.chat});

  @override
  List<Object?> get props => [chat];
}

final class ChatListLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatListError extends ChatState {
  final String error;

  ChatListError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class ChatDeleting extends ChatState {
  final int chatId;
  ChatDeleting({required this.chatId});
  @override
  List<Object?> get props => [chatId];
}

final class ChatDeleted extends ChatState {
  final int chatId;
  ChatDeleted({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

final class ChatDeleteError extends ChatState {
  final String error;

  ChatDeleteError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class PromptSending extends ChatState {
  PromptSending({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

final class PromptSent extends ChatState {
  PromptSent();

  @override
  List<Object?> get props => [];
}

final class PromptReceived extends ChatState {
  final String response;

  PromptReceived({required this.response});

  @override
  List<Object?> get props => [response];
}

final class PromptError extends ChatState {
  final String error;

  PromptError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class ChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatLoadingError extends ChatState {
  final String error;

  ChatLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}
