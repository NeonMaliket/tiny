part of 'ai_bloc.dart';

sealed class AiState extends Equatable {
  const AiState();

  @override
  List<Object> get props => [];
}

final class AiInitial extends AiState {}

final class AiMessageProcessing extends AiState {
  final ChatMessage message;

  const AiMessageProcessing(this.message);

  @override
  List<Object> get props => [message];
}

final class AiMessageSuccess extends AiState {
  final ChatMessage message;

  const AiMessageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class AiMessageFailure extends AiState {
  final String error;

  const AiMessageFailure(this.error);

  @override
  List<Object> get props => [error];
}
