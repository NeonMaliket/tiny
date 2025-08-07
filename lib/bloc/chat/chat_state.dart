part of 'chat_bloc.dart';

@immutable
sealed class ChatState extends Equatable {}

final class ChatInitial extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatListLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

final class ChatListLoaded extends ChatState {
  final List<Chat> chats;

  ChatListLoaded({required this.chats});

  @override
  List<Object?> get props => [chats];
}

final class ChatListError extends ChatState {
  final String error;

  ChatListError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class ChatDeleting extends ChatState {
  final String chatId;
  ChatDeleting({required this.chatId});
  @override
  List<Object?> get props => [chatId];
}

final class ChatDeleted extends ChatState {
  final String chatId;
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
  final String prompt;

  PromptSending({required this.prompt});

  @override
  List<Object?> get props => [prompt];
}

final class PromptSent extends ChatState {
  final String response;

  PromptSent({required this.response});

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

final class ChatLoaded extends ChatState {
  final Chat chat;

  ChatLoaded({required this.chat});

  @override
  List<Object?> get props => [chat];
}

final class ChatLoadingError extends ChatState {
  final String error;

  ChatLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class LastChatLoading extends ChatState {
  @override
  List<Object?> get props => [];
}

final class LastChatLoaded extends ChatState {
  final Chat chat;

  LastChatLoaded({required this.chat});

  @override
  List<Object?> get props => [chat];
}

final class LastChatLoadingError extends ChatState {
  final String error;

  LastChatLoadingError({required this.error});

  @override
  List<Object?> get props => [error];
}
