part of 'ai_bloc.dart';

sealed class AiEvent extends Equatable {
  const AiEvent();

  @override
  List<Object> get props => [];
}

class AiSendMessageEvent extends AiEvent {
  final SupabaseFuncVersion apiVersion;
  final ChatMessage message;
  final ChatSettings chatSettings;
  final String model;

  const AiSendMessageEvent({
    this.apiVersion = SupabaseFuncVersion.v1,
    required this.message,
    required this.chatSettings,
    required this.model,
  });

  @override
  List<Object> get props => [message, chatSettings];
}
