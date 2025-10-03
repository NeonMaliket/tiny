// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiny/bloc/cybperpunk_alert/cyberpunk_alert_bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc({required CyberpunkAlertBloc cyberpunkAlertBloc})
    : _cyberpunkAlertBloc = cyberpunkAlertBloc,
      super(ChatInitial()) {
    on<LoadChatListEvent>(loadChatList);
    on<DeleteChatEvent>(deleteChat);
    on<NewChatEvent>(newChat);
    on<UpdateChatEvent>(updateChat);
  }

  final CyberpunkAlertBloc _cyberpunkAlertBloc;

  Future<void> updateChat(UpdateChatEvent event, emit) async {
    emit(ChatUpdated(chat: event.chat));
  }

  Future<void> loadChatList(LoadChatListEvent event, emit) async {
    emit(ChatListLoading());
    try {
      final chatList = await getIt<ChatRepository>().chatList();
      for (final chat in chatList) {
        emit(ChatListItemReceived(chat: chat));
      }
    } catch (e) {
      logger.e("Error: ", error: e);
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to load chat list',
        ),
      );
      emit(ChatListError(error: e.toString()));
    }
  }

  Future<void> deleteChat(DeleteChatEvent event, emit) async {
    emit(ChatDeleting(chatId: event.chatId));
    try {
      await getIt<ChatRepository>().deleteChat(event.chatId);
      emit(ChatDeleted(chatId: event.chatId));
    } catch (e) {
      logger.e("Error: ", error: e);
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to delete chat',
        ),
      );
      emit(ChatListError(error: e.toString()));
    }
  }

  Future<void> newChat(NewChatEvent event, emit) async {
    emit(NewChatCreation());
    try {
      final created = await getIt<ChatRepository>().createChat(
        event.title,
      );
      emit(NewChatCreated(chat: created));
    } catch (e) {
      logger.e("Error: ", error: e);
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to create new chat',
        ),
      );
      emit(ChatCreationError(error: e.toString()));
      return;
    }
  }
}
