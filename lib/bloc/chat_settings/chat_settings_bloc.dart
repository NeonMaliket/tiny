import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/config/get_it.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

part 'chat_settings_event.dart';
part 'chat_settings_state.dart';

class ChatSettingsBloc extends Bloc<ChatSettingsEvent, ChatSettingsState> {
  ChatSettingsBloc() : super(ChatSettingsInitial()) {
    on<LoadChatSettings>(_onLoadChatSettings);
    on<UpdateChatSettings>(_onUpdateChatSettings);
  }

  Future<void> _onLoadChatSettings(
    LoadChatSettings event,
    Emitter<ChatSettingsState> emit,
  ) async {
    emit(ChatSettingsLoading());
    try {
      final settings = await getIt<ChatSettingsRepository>().getChatSettings(
        event.chatId,
      );
      emit(ChatSettingsLoaded(settings: settings));
    } catch (e) {
      emit(ChatSettingsError(message: e.toString()));
    }
  }

  Future<void> _onUpdateChatSettings(
    UpdateChatSettings event,
    Emitter<ChatSettingsState> emit,
  ) async {
    emit(ChatSettingsLoading());
    try {
      await getIt<ChatSettingsRepository>().updateChatSettings(event.settings);
      emit(ChatSettingsLoaded(settings: event.settings));
    } catch (e) {
      emit(ChatSettingsError(message: e.toString()));
    }
  }
}
