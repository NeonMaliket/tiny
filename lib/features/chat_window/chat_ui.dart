import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ui;
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/tiny_avatar.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

const _answer = 'ANWSER';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key, required this.chatId});

  final String chatId;

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  late final InMemoryChatController _chatController;
  StreamSubscription<MessageChunk>? _messageStreamController;
  late final StreamSubscription<ChatMessage> _chatStreamController;
  final _answerMessageBuffer = StringBuffer();
  bool _awaitingForAssistantMessage = false;

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController();
    _chatStreamController = context
        .read<MessageCubit>()
        .subscribeOnChat(widget.chatId)
        .listen(_handleStreamingMessage);
  }

  @override
  void dispose() {
    _chatController.dispose();
    _messageStreamController?.cancel();
    _chatStreamController.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ui.Chat(
      chatController: _chatController,
      theme: ChatTheme(
        colors: ChatColors(
          primary: context.theme().colorScheme.primary,
          onPrimary: context.theme().colorScheme.onPrimary,
          surface: context.theme().colorScheme.surface,
          onSurface: context.theme().colorScheme.onSurface,
          surfaceContainer: context.theme().colorScheme.surfaceContainer,
          surfaceContainerLow: context.theme().colorScheme.surfaceContainerLow,
          surfaceContainerHigh: context
              .theme()
              .colorScheme
              .surfaceContainerHigh,
        ),
        typography: ChatTypography(
          bodyLarge: context.theme().textTheme.bodyLarge ?? TextStyle(),
          bodyMedium: context.theme().textTheme.bodyMedium ?? TextStyle(),
          bodySmall: context.theme().textTheme.bodySmall ?? TextStyle(),
          labelLarge: context.theme().textTheme.labelLarge ?? TextStyle(),
          labelMedium: context.theme().textTheme.labelMedium ?? TextStyle(),
          labelSmall: context.theme().textTheme.labelSmall ?? TextStyle(),
        ),
        shape: BorderRadiusGeometry.all(Radius.circular(7.0)),
      ),
      currentUserId: 'user',
      onMessageSend: (text) {
        logger.i('Sending prompt: $text');
        _messageStreamController?.cancel();
        _messageStreamController = context
            .read<MessageCubit>()
            .sendMessage(chatId: widget.chatId, message: text)
            .listen(_handleChunk);
      },
      builders: Builders(
        chatMessageBuilder: _buildMessage,
        chatAnimatedListBuilder: (context, builder) =>
            ui.ChatAnimatedListReversed(itemBuilder: builder),
      ),
      resolveUser: (UserID id) async {
        return User(id: widget.chatId, name: ChatMessageAuthor.user.name);
      },
    );
  }

  void _handleStreamingMessage(ChatMessage message) {
    if (_awaitingForAssistantMessage) {
      final lastMessage = _chatController.messages.last;
      _chatController
          .updateMessage(
            lastMessage,
            Message.text(
              id: message.id,
              authorId: message.author.name,
              text: message.content,
              createdAt: message.createdAt,
            ),
          )
          .then((_) {
            _awaitingForAssistantMessage = false;
            _answerMessageBuffer.clear();
          });
    } else {
      final messages = _chatController.messages;
      if (messages.isEmpty || messages.last.id != _answer) {
        _chatController.insertMessage(message.toTextMessage());
      }
    }
  }

  void _handleChunk(final MessageChunk chunk) {
    if (_answerMessageBuffer.isEmpty) {
      _answerMessageBuffer.write(chunk.chunk);
      _chatController.insertMessage(
        Message.text(
          id: _answer,
          authorId: ChatMessageAuthor.assistant.name,
          text: _answerMessageBuffer.toString(),
        ),
      );
    } else {
      final oldMessage = Message.text(
        id: _answer,
        authorId: ChatMessageAuthor.assistant.name,
        text: _answerMessageBuffer.toString(),
      );
      _answerMessageBuffer.write(chunk.chunk);
      final newMessage = Message.text(
        id: _answer,
        authorId: ChatMessageAuthor.assistant.name,
        text: _answerMessageBuffer.toString(),
      );
      _chatController.updateMessage(oldMessage, newMessage);
    }
    _awaitingForAssistantMessage = chunk.isLast;
  }

  Widget _buildMessage(
    BuildContext context,
    Message message,
    int index,
    Animation<double> animation,
    Widget child, {
    bool? isRemoved,
    required bool isSentByMe,
    MessageGroupStatus? groupStatus,
  }) {
    if (message is! TextMessage) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSentByMe
              ? context.theme().colorScheme.secondary.withAlpha(40)
              : context.theme().colorScheme.onSurface.withAlpha(10),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text('Unsupported message'),
      );
    }
    return ui.ChatMessage(
      leadingWidget: TinyAvatar(
        imageUrl:
            "https://img.freepik.com/premium-photo/ai-image-generator_707898-82.jpg",
      ),
      message: message,
      index: index,
      animation: animation,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isSentByMe
              ? context.theme().colorScheme.primary
              : context.theme().colorScheme.onSurface.withAlpha(10),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: message.text.isEmpty
            ? SizedBox.shrink()
            : Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GptMarkdown(
                    message.text,
                    style: TextStyle(
                      color: context.theme().colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    message.createdAt == null
                        ? ''
                        : DateFormat('HH:mm').format(message.createdAt!),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: context.theme().colorScheme.onSurface.withAlpha(
                        90,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
