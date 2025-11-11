import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

class ChatCubit extends Cubit<Chat> {
  ChatCubit(this._chat, this._chatBloc) : super(_chat);

  final Chat _chat;
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
    }
    return state.settings;
  }
}
