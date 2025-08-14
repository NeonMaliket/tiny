import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/features/chat_window/chat_ui.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ChatBloc>().add(LoadChatEvent(chatId: widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiny'),
        leading: IconButton(
          onPressed: () => context.go('/chat/list'),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
            current is ChatLoadingError ||
            current is ChatLoaded ||
            current is ChatLoading,
        builder: (context, state) {
          if (state is ChatLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatLoadingError) {
            return Center(child: Text('Error loading chat: ${state.error}'));
          } else if (state is ChatLoaded) {
            final chat = state.chat;
            return ChatUI(chat: chat);
          }
          return Center(child: Text('You have no active chats'));
        },
      ),
    );
  }
}
