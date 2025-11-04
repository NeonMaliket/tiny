part of 'message_cubit.dart';

sealed class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object> get props => [];
}

final class MessageInitial extends MessageState {}

final class MessageSending extends MessageState {}

final class MessageHandling extends MessageState {}

final class MessageSent extends MessageState {
  const MessageSent();

  @override
  List<Object> get props => [];
}

final class MessageError extends MessageState {
  final String message;

  const MessageError(this.message);
  @override
  List<Object> get props => [message];
}

final class MessageStreamingSubscription extends MessageState {}

final class MessageStreamingSubscribed extends MessageState {}

final class MessageStreamigError extends MessageState {
  final String message;

  const MessageStreamigError(this.message);
  @override
  List<Object> get props => [message];
}
