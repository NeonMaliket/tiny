part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent extends Equatable {}

class LoadChatListEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class LoadLastChatEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class LoadChatEvent extends ChatEvent {
  final String chatId;

  LoadChatEvent({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class NewChatEvent extends ChatEvent {
  final String title;

  NewChatEvent({required this.title});

  @override
  List<Object?> get props => [title];
}

class DeleteChatEvent extends ChatEvent {
  final String chatId;

  DeleteChatEvent({required this.chatId});

  @override
  List<Object?> get props => [chatId];
}

class SendPromptEvent extends ChatEvent {
  final String chatId;
  final String prompt;

  SendPromptEvent({required this.chatId, required this.prompt});

  @override
  List<Object?> get props => [chatId, prompt];
}
