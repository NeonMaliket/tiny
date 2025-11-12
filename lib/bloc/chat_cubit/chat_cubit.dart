import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

class ChatCubit extends Cubit<Chat> {
  ChatCubit(
    this._chat,
    this._chatBloc,
    this._storageRepository,
    this._chatRepository,
  ) : super(_chat);

  final Chat _chat;
  final ChatBloc _chatBloc;
  final ChatRepository _chatRepository;
  final StorageRepository _storageRepository;

  Future<ChatSettings> updateChatSettings(
    final ChatSettings newSettings,
  ) async {
    try {
      final response = await getIt<ChatSettingsRepository>()
          .updateChatSettings(_chat.id, newSettings);
      emit(state.copyWith(settings: response));
      _chatBloc.add(UpdateChatEvent(chat: state));
    } catch (e) {
      logger.e("Error: ", error: e);
    }
    return state.settings;
  }

  Future<Chat> updateChatAvatar(final File file) async {
    try {
      final filename = await _storageRepository.uploadChatAvatar(
        _chat.id,
        file,
        oldFilePath: _chat.avatarObject?.name,
      );
      final fileMetadataId = await _storageRepository
          .objectIdFromPath(filename);
      final updatedChat = await _chatRepository.updateChatAvatar(
        chatId: _chat.id,
        avatarId: fileMetadataId,
      );
      emit(updatedChat);
      _chatBloc.add(UpdateChatEvent(chat: state));
      return updatedChat;
    } catch (e) {
      logger.e("Error: ", error: e);
      rethrow;
    }
  }
}
