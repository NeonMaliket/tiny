part of 'chat_settings_bloc.dart';

sealed class ChatSettingsState extends Equatable {
  const ChatSettingsState();

  @override
  List<Object> get props => [];
}

final class ChatSettingsInitial extends ChatSettingsState {}

final class ChatSettingsLoading extends ChatSettingsState {}

final class ChatSettingsLoaded extends ChatSettingsState {
  final ChatSettings settings;

  const ChatSettingsLoaded({required this.settings});

  @override
  List<Object> get props => [settings];
}

final class ChatSettingsError extends ChatSettingsState {
  final String message;

  const ChatSettingsError({required this.message});

  @override
  List<Object> get props => [message];
}
