import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/message/message_cubit.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/chat.dart';
import 'package:tiny/domain/chat_message.dart';

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
    final messageCubit = context.read<MessageCubit>();
    messageCubit.fetchMessages(chatId: widget.chat.id).then((
      loadedMessages,
    ) {
      setState(() {
        messages.addAll(loadedMessages);
      });
    });
    messageCubit.subscribeOnChat(widget.chat.id).listen((newMessage) {
      setState(() {
        messages.add(newMessage);
      });
    });
    super.initState();
  }

  Widget buildEmptyMessageSliver() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Center(
        child: CyberpunkBlur(
          padding: const EdgeInsets.all(10),
          borderRadius: 10,
          child: Text(
            'No messages yet',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
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
    return Stack(
      children: [
        CyberpunkBackground(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: messages.isEmpty
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(bottom: 100),
                sliver: messages.isEmpty
                    ? buildEmptyMessageSliver()
                    : buildMessageList(),
              ),
            ],
          ),
        ),
        CyberpunkComposer(chat: widget.chat),
      ],
    );
  }
}
