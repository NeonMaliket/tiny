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
    on<LoadChatEvent>(loadChat);
  }

  FutureOr<void> loadChatList(LoadChatListEvent event, emit) async {
    // Logic to load chat list
    emit(ChatListLoading());
    // Simulate loading with a delay
    await Future.delayed(Duration(seconds: 1), () {
      // Example data
      final List<Chat> chats = [
        Chat(id: '1', title: 'Chat 1', createdAt: DateTime.now(), history: []),
        Chat(id: '2', title: 'Chat 2', createdAt: DateTime.now(), history: []),
      ];
      emit(ChatListLoaded(chats: chats));
    });
  }

  FutureOr<void> loadChat(LoadChatEvent event, emit) async {}
}
