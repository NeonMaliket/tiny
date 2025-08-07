// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChatListEvent>(loadChatList);
    on<DeleteChatEvent>(deleteChat);
    on<NewChatEvent>(newChat);
    on<SendPromptEvent>(sendPrompt);
    on<LoadChatEvent>(loadChat);
    on<LoadLastChatEvent>(loadLastChat);
  }

  Future<void> loadChatList(LoadChatListEvent event, emit) async {
    emit(ChatListLoading());
    await dio
        .get('/chat/all')
        .then((response) {
          print('Chat list loaded: ${response.data}');
          final chats = (response.data as List)
              .map((chatData) => SimpleChat.fromMap(chatData))
              .toList();
          emit(SimpleChatListLoaded(chats: chats));
        })
        .catchError((error) {
          emit(ChatListError(error: error.toString()));
        });
  }

  Future<void> deleteChat(DeleteChatEvent event, emit) async {
    emit(ChatDeleting(chatId: event.chatId));
    await Future.delayed(Duration(seconds: 1), () {
      emit(ChatDeleted(chatId: event.chatId));
      add(LoadChatListEvent());
    });
  }

  Future<void> loadChat(LoadChatEvent event, emit) async {
    emit(ChatLoading());
    await Future.delayed(Duration(seconds: 1), () {
      final chat = Chat(
        id: event.chatId,
        title: 'Chat ${event.chatId}',
        createdAt: DateTime.now(),
        history: [],
      );
      emit(ChatLoaded(chat: chat));
    });
  }

  Future<void> newChat(NewChatEvent event, emit) async {
    emit(NewChatCreation());
    await dio
        .post('/chat', data: {'title': event.title})
        .then((response) {
          print('New chat created: ${response.data}');
          final chat = SimpleChat.fromMap(response.data);
          emit(NewChatCreated(chat: chat));
          add(LoadLastChatEvent());
          add(LoadChatListEvent());
        })
        .catchError((error) {
          emit(ChatCreationError(error: error.toString()));
        });
  }

  FutureOr<void> sendPrompt(SendPromptEvent event, emit) {
    emit(PromptSending(prompt: event.prompt));
    Future.delayed(Duration(seconds: 1), () {
      emit(PromptSent(response: 'Response to: ${event.prompt}'));
    });
  }

  Future<void> loadLastChat(LoadLastChatEvent event, emit) async {
    emit(LastChatLoading());
    await dio
        .get(
          '/chat/last',
          options: Options(
            validateStatus: (status) => status != null && status < 500,
          ),
        )
        .then((response) {
          if (response.statusCode == 404) {
            emit(LastChatNotFound());
          } else if (response.data != null) {
            final chat = Chat.fromMap(response.data);
            emit(LastChatLoaded(chat: chat));
          }
        })
        .catchError((error) {
          emit(LastChatLoadingError(error: error.toString()));
        });
  }
}
