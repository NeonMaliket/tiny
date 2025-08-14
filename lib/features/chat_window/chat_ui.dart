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
import 'package:uuid/uuid.dart';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key, required this.chat});

  final Chat chat;

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final _chatController = InMemoryChatController();
  StreamSubscription<ChatState>? _sub;
  String? _streamMsgId;

  @override
  void initState() {
    super.initState();

    _chatController.insertAllMessages(
      widget.chat.history
          .map(
            (message) => TextMessage(
              id: message.id,
              authorId: message.author.name,
              createdAt: message.createdAt,
              text: message.content,
            ),
          )
          .toList(),
    );

    final bloc = context.read<ChatBloc>();
    _sub = bloc.stream.listen(_onState, onError: (_) {});
    _onState(bloc.state);
  }

  void _onState(ChatState state) {
    if (state is PromptSending) {
      _streamMsgId = const Uuid().v4().toString();
      _chatController.insertMessage(
        TextMessage(
          id: _streamMsgId!,
          authorId: ChatEntryAuthor.assistant.name,
          createdAt: DateTime.now(),
          text: '',
        ),
      );
    } else if (state is PromptReceived && _streamMsgId != null) {
      _chatController.updateMessage(
        _chatController.messages.firstWhere((msg) => msg.id == _streamMsgId),
        TextMessage(
          id: _streamMsgId!,
          authorId: ChatEntryAuthor.assistant.name,
          createdAt: DateTime.now(),
          text: state.response,
        ),
      );
    } else if (state is PromptError) {
      _streamMsgId = null;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _chatController.dispose();
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
        _chatController.insertMessage(
          TextMessage(
            id: const Uuid().v4().toString(),
            authorId: 'user',
            createdAt: DateTime.now(),
            text: text,
          ),
        );
        logger.i('Sending prompt: $text');
        context.read<ChatBloc>().add(
          SendPromptEvent(chatId: widget.chat.id, prompt: text),
        );
      },
      builders: Builders(chatMessageBuilder: _buildMessage),
      resolveUser: (UserID id) async {
        return User(id: widget.chat.id, name: widget.chat.title);
      },
    );
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
              ? context.theme().colorScheme.secondary.withAlpha(40)
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
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: context.theme().colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
