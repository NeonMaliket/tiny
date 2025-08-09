// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';

part 'chat_event.dart';
part 'chat_state.dart';

const dataPreffix = 'data:';

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
    await dio
        .delete('/chat/${event.chatId}')
        .then((response) {
          emit(ChatDeleted(chatId: event.chatId));
          add(LoadChatListEvent());
          add(LoadLastChatEvent());
        })
        .catchError((error) {
          emit(ChatDeleteError(error: error.toString()));
        });
  }

  Future<void> loadChat(LoadChatEvent event, emit) async {
    emit(ChatLoading());
    await dio
        .get('/chat/${event.chatId}')
        .then((response) {
          final chat = Chat.fromMap(response.data);
          print('Chat loaded: $chat');
          emit(ChatLoaded(chat: chat));
        })
        .catchError((error) {
          emit(ChatLoadingError(error: error.toString()));
        });
  }

  Future<void> newChat(NewChatEvent event, emit) async {
    emit(NewChatCreation());
    await dio
        .post('/chat', data: {'title': event.title})
        .then((response) {
          final chat = SimpleChat.fromMap(response.data);
          emit(NewChatCreated(chat: chat));
          add(LoadLastChatEvent());
          add(LoadChatListEvent());
        })
        .catchError((error) {
          emit(ChatCreationError(error: error.toString()));
        });
  }

  Future<void> sendPrompt(
    SendPromptEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(PromptSending(message: event.prompt));
    try {
      final res = await dio.post(
        '$baseUrl/chat/send/prompt',
        data: {'chatId': event.chatId, 'prompt': event.prompt},
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Accept': 'text/event-stream',
            'Content-Type': 'application/json',
          },
          validateStatus: (s) => s != null && s < 500,
        ),
      );

      final lines = const LineSplitter().bind(
        utf8.decoder.bind(res.data.stream),
      );

      final message = StringBuffer();

      await for (final line in lines) {
        if (emit.isDone) break;
        if (line.isEmpty || line.startsWith(':')) continue;
        if (line.startsWith(dataPreffix)) {
          final payload = line.substring(dataPreffix.length);
          message.write(payload);
          emit(PromptReceived(response: message.toString()));
        }
      }
    } catch (e) {
      emit(PromptError(error: e.toString()));
    } finally {
      add(LoadChatEvent(chatId: event.chatId));
    }
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
