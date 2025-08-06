// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tiny/domain/domain.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<LoadChatListEvent>(loadChatList);
    on<DeleteChatEvent>(deleteChat);
    on<NewChatEvent>(newChat);
    on<LoadChatEvent>(loadChat);
  }

  FutureOr<void> loadChatList(LoadChatListEvent event, emit) async {
    // Logic to load chat list
    emit(ChatListLoading());
    // Simulate loading with a delay
    final List<Chat> chats = [
      Chat(id: '1', title: 'Chat 1', createdAt: DateTime.now(), history: []),
      Chat(id: '2', title: 'Chat 2', createdAt: DateTime.now(), history: []),
    ];
    emit(ChatListLoaded(chats: chats));
  }

  FutureOr<void> deleteChat(DeleteChatEvent event, emit) async {
    emit(ChatDeleting(chatId: event.chatId));
    await Future.delayed(Duration(seconds: 1), () {
      emit(ChatDeleted(chatId: event.chatId));
      print('Chat with id ${event.chatId} deleted');
      add(LoadChatListEvent());
    });
  }

  FutureOr<void> loadChat(LoadChatEvent event, emit) async {}

  FutureOr<void> newChat(NewChatEvent event, emit) {
    // Logic to create a new chat
    final newChat = Chat(
      id: DateTime.now().toIso8601String(),
      title: event.title,
      createdAt: DateTime.now(),
      history: [],
    );
    // Here you would typically add the new chat to a repository or state
    print('New chat created: $newChat');
    add(LoadChatListEvent()); // Refresh the chat list after creating a new chat
  }
}
