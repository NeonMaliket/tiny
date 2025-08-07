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
    on<SendPromptEvent>(sendPrompt);
    on<LoadChatEvent>(loadChat);
    on<LoadLastChatEvent>(loadLastChat);
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

  FutureOr<void> loadChat(LoadChatEvent event, emit) async {
    emit(ChatLoading());
    await Future.delayed(Duration(seconds: 1), () {
      final chat = Chat(
        id: event.chatId,
        title: 'Chat ${event.chatId}',
        createdAt: DateTime.now(),
        history: [],
      );
      print('Chat loaded: $chat');
      // Here you would typically fetch the chat from a repository
      // and emit a state with the chat data
      emit(ChatLoaded(chat: chat));
    });
  }

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
    add(LoadChatListEvent());
  }

  FutureOr<void> sendPrompt(SendPromptEvent event, emit) {
    // Logic to send a prompt
    emit(PromptSending(prompt: event.prompt));
    // Simulate sending with a delay
    Future.delayed(Duration(seconds: 1), () {
      final chatEntry = ChatEntry(
        id: DateTime.now().toIso8601String(),
        content: event.prompt,
        createdAt: DateTime.now(),
        author: ChatEntryAuthor.user,
      );
      print('Prompt sent: $chatEntry');
      emit(PromptSent(response: 'Response to: ${event.prompt}'));
    });
  }

  FutureOr<void> loadLastChat(LoadLastChatEvent event, emit) {
    emit(LastChatLoading());
    // Simulate loading with a delay
    Future.delayed(Duration(seconds: 1), () {
      final chat = Chat(
        id: 'last_chat',
        title: 'Last Chat',
        createdAt: DateTime.now(),
        history: [],
      );
      print('Last chat loaded: $chat');
      emit(LastChatLoaded(chat: chat));
    });
  }
}
