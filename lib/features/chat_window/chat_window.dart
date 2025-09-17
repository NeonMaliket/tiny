import 'package:flutter/material.dart';
import 'package:tiny/features/chat_window/chat_ui.dart';
import 'package:tiny/utils/utils.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key, required this.chatId});

  final String chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: ChatUI(chatId: chatId),
    );
  }
}
