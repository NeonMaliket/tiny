import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/message/message_cubit.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_background.dart';
import 'package:tiny/domain/chat.dart';
import 'package:tiny/domain/chat_message.dart';
import 'package:tiny/features/chat_window/cyberpunk_message.dart';

class CyberpunkChat extends StatefulWidget {
  const CyberpunkChat({super.key, required this.chat});

  final Chat chat;

  @override
  State<CyberpunkChat> createState() => _CyberpunkChatState();
}

class _CyberpunkChatState extends State<CyberpunkChat> {
  final messages = <ChatMessage>[];

  @override
  void initState() {
    context
        .read<MessageCubit>()
        .fetchMessages(chatId: widget.chat.id)
        .then((loadedMessages) {
          setState(() {
            messages.addAll(loadedMessages);
          });
        });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CyberpunkBackground(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          messages.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      'No messages.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: messages.length,
                    (context, index) {
                      final message = messages[index];
                      return CyberpunkMessage(message: message);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
