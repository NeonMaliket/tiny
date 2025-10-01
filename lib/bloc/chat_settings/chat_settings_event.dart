part of 'chat_settings_bloc.dart';

sealed class ChatSettingsEvent extends Equatable {
  const ChatSettingsEvent();

  @override
  List<Object> get props => [];
}

final class LoadChatSettings extends ChatSettingsEvent {
  final int chatId;

  const LoadChatSettings({required this.chatId});

  @override
  List<Object> get props => [chatId];
}

final class UpdateChatSettings extends ChatSettingsEvent {
  final int chatId;
  final ChatSettings settings;

  const UpdateChatSettings({required this.chatId, required this.settings});

  @override
  List<Object> get props => [chatId, settings];
}
