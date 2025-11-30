import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/chat_cubit/chat_cubit.dart';
import 'package:tiny/features/chat_window/cyberpunk_chat.dart';
import 'package:tiny/utils/utils.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        context,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.table),
            onPressed: () {
              context.push(
                '/chat/settings',
                extra: context.read<ChatCubit>(),
              );
            },
          ),
        ],
      ),
      body: CyberpunkChat(chat: context.watch<ChatCubit>().state),
    );
  }
}
