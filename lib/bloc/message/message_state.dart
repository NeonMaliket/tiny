part of 'message_cubit.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessageSending extends MessageState {}

final class MessageReceived extends MessageState {
  const MessageReceived(this.message);

  final ChatMessage message;

  @override
  List<Object> get props => [message];
}

final class MessageSent extends MessageState {
  const MessageSent();

  @override
  List<Object> get props => [];
}

final class MessagesFetching extends MessageState {}

final class MessagesLoaded extends MessageState {
  const MessagesLoaded(this.messages);

  final List<ChatMessage> messages;

  @override
  List<Object> get props => [messages];
}

final class MessagesFetchError extends MessageState {
  final String error;

  const MessagesFetchError(this.error);
  @override
  List<Object> get props => [error];
}

final class MessageError extends MessageState {
  final String error;

  const MessageError(this.error);
  @override
  List<Object> get props => [error];
}

final class MessageStreamigError extends MessageState {
  final String message;

  const MessageStreamigError(this.message);
  @override
  List<Object> get props => [message];
}
