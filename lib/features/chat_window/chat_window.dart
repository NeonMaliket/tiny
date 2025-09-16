import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/features/chat_window/chat_ui.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tiny'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: ChatUI(chatId: chatId),
    );
  }
}
