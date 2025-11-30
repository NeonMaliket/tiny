import 'dart:async';

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

  final _scrollController = ScrollController();
  final _listKey = GlobalKey<SliverAnimatedListState>();

  StreamSubscription<ChatMessage>? _sub;

  bool get _isAtBottom {
    if (!_scrollController.hasClients) return true;
    return _scrollController.offset <= 24.0;
  }

  void _scrollToBottomAnimated() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  @override
  void initState() {
    super.initState();

    final messageCubit = context.read<MessageCubit>();

    messageCubit.fetchMessages(chatId: widget.chat.id).then((loaded) {
      if (!mounted) return;
      setState(() {
        messages
          ..clear()
          ..addAll(loaded.reversed);
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottomAnimated();
      });
    });

    _sub = messageCubit.subscribeOnChat(widget.chat.id).listen((
      newMessage,
    ) {
      if (!mounted) return;

      final shouldAutoScroll = _isAtBottom;

      messages.insert(0, newMessage);

      _listKey.currentState?.insertItem(
        0,
        duration: const Duration(milliseconds: 220),
      );

      if (shouldAutoScroll) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottomAnimated();
        });
      }
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
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

  Widget _buildAnimatedItem(
    BuildContext context,
    int index,
    Animation<double> animation,
  ) {
    final msg = messages[index];

    return FadeTransition(
      opacity: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      ),
      child: SizeTransition(
        sizeFactor: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        ),
        axisAlignment: -1,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: CyberpunkMessage(message: msg),
        ),
      ),
    );
  }

  SliverAnimatedList buildAnimatedMessageList() {
    return SliverAnimatedList(
      key: _listKey,
      initialItemCount: messages.length,
      itemBuilder: (context, index, animation) =>
          _buildAnimatedItem(context, index, animation),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CyberpunkBackground(
          child: CustomScrollView(
            controller: _scrollController,
            reverse: true,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: messages.isEmpty
                    ? EdgeInsets.zero
                    : const EdgeInsets.only(bottom: 100),
                sliver: messages.isEmpty
                    ? buildEmptyMessageSliver()
                    : buildAnimatedMessageList(),
              ),
            ],
          ),
        ),
        CyberpunkComposer(chat: widget.chat),
      ],
    );
  }
}
