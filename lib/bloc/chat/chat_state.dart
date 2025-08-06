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
