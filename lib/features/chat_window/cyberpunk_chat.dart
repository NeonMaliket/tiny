import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/message/message_cubit.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_background.dart';
import 'package:tiny/domain/chat.dart';
import 'package:tiny/domain/chat_message.dart';
import 'package:tiny/features/chat_window/cyberpunk_message.dart';
import 'package:tiny/theme/theme.dart';

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

  Widget buildEmptyMessageSliver() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: Text(
          'No messages yet',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget buildComposer() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Padding(
        padding: .only(bottom: 32, left: 16.0, right: 16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Type a message...',
            filled: true,
            fillColor: context
                .theme()
                .colorScheme
                .secondary
                .withAlpha(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 16.0,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.send,
                color: context.theme().colorScheme.primary,
              ),
              onPressed: () {
                // send
              },
            ),
          ),
          style: context.theme().textTheme.bodyMedium,

          onSubmitted: (text) {},
        ),
      ),
    );
  }

  SliverList buildMessageList() {
    return SliverList.separated(
      itemCount: messages.length,
      itemBuilder: (BuildContext context, int index) {
        final message = messages[index];
        return CyberpunkMessage(message: message);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CyberpunkBackground(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              messages.isEmpty
                  ? buildEmptyMessageSliver()
                  : buildMessageList(),
            ],
          ),
        ),
        buildComposer(),
      ],
    );
  }
}
