import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/ai/ai_bloc.dart';
import 'package:tiny/bloc/message/message_cubit.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_background.dart';
import 'package:tiny/domain/chat.dart';
import 'package:tiny/domain/chat_message.dart';
import 'package:tiny/features/chat_window/cyberpunk_composer.dart';
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

  SliverList buildMessageList() {
    return SliverList.separated(
      itemCount: messages.length,
      itemBuilder: (_, int index) {
        final message = messages[index];
        return CyberpunkMessage(message: message);
      },
      separatorBuilder: (_, __) => const SizedBox(height: 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AiBloc, AiState>(
      listener: (_, AiState state) {
        if (state is AiMessageSuccess) {
          setState(() {
            messages.add(state.message);
          });
        }
      },
      child: Stack(
        children: [
          CyberpunkBackground(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 100),
                  sliver: messages.isEmpty
                      ? buildEmptyMessageSliver()
                      : buildMessageList(),
                ),
              ],
            ),
          ),
          CyberpunkComposer(chat: widget.chat),
        ],
      ),
    );
  }
}
