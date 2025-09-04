// ignore_for_file: depend_on_referenced_packages

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eventsource/eventsource.dart';
import 'package:meta/meta.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/utils/utils.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChatListEvent>(loadChatList);
    on<DeleteChatEvent>(deleteChat);
    on<NewChatEvent>(newChat);
    on<LoadChatEvent>(loadChat);
  }

  Future<void> loadChatList(LoadChatListEvent event, emit) async {
    emit(ChatListLoading());
    try {
      final eventSource = await EventSource.connect('$baseUrl/chat/stream');
      eventSource.listen(
        null,
        onError: (dynamic error) {
          emit(ChatListError(error: error.toString()));
          logger.e('Stream Events Error', error: error);
        },
        onDone: () {
          logger.i('Connection closed.');
        },
      );

      await for (final event in eventSource.asBroadcastStream()) {
        final String? data = event.data;
        if (data != null) {
          final streamEvent = StreamEvent.fromStreamEvent(event);
          emit(ChatListItemReceived(event: streamEvent));
        }
      }
    } catch (e) {
      logger.e("Error: ", error: e);
      emit(ChatListError(error: e.toString()));
    }
  }

  Future<void> deleteChat(DeleteChatEvent event, emit) async {
    emit(ChatDeleting(chatId: event.chatId));
    await dio
        .delete('/chat/${event.chatId}')
        .then((response) {
          emit(ChatDeleted(chatId: event.chatId));
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
          logger.i('Chat loaded: $chat');
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
        })
        .catchError((error) {
          emit(ChatCreationError(error: error.toString()));
        });
  }
}
