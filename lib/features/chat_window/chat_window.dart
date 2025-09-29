import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/features/chat_window/chat_ui.dart';
import 'package:tiny/utils/utils.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.table),
            onPressed: () {
              context.push('/chat/settings/$chatId');
            },
          ),
        ],
      ),
      body: ChatUI(chatId: chatId),
    );
  }
}
