import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:tiny/bloc/chat/chat_bloc.dart';
import 'package:tiny/bloc/cybperpunk_alert/cyberpunk_alert_bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

typedef _AlertBloc = Bloc<CyberpunkAlertEvent, CyberpunkAlertState>;

class ChatCubit extends Cubit<Chat> {
  ChatCubit(this._chat, this._cyberpunkAlertBloc, this._chatBloc)
    : super(_chat);
  final Chat _chat;
  final _AlertBloc _cyberpunkAlertBloc;
  final ChatBloc _chatBloc;

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
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to update chat settings',
        ),
      );
    }
    return state.settings;
  }

  Future<DocumentMetadata?> updateAvatar(File picture) async {
    try {
      final chatStorageRepository = getIt<ChatStorageRepository>();
      final metadata = await chatStorageRepository.uploadChatFile(
        chatId: _chat.id,
        filename: 'avatar_${_chat.title}',
        file: picture,
      );
      await getIt<ChatRepository>().updateChatAvatar(
        chatId: _chat.id,
        avatarMetadata: metadata,
      );
      emit(state.copyWith(avatarMetadata: metadata));
      _chatBloc.add(UpdateChatEvent(chat: state));
    } catch (e) {
      logger.e("Error: ", error: e);
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to update chat avatar',
        ),
      );
    }
    return state.avatarMetadata;
  }
}
