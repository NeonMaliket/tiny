import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ui;
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/features/chat_window/audio_message_body.dart';
import 'package:tiny/features/chat_window/chat_composer.dart';
import 'package:tiny/features/chat_window/text_message_body.dart';
import 'package:tiny/theme/theme.dart';
import 'package:uuid/uuid.dart';

const _answer = 'ANWSER';

class ChatUI extends StatefulWidget {
  const ChatUI({super.key, required this.chat});

  final Chat chat;

  @override
  State<ChatUI> createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  late final InMemoryChatController _chatController;
  StreamSubscription<MessageChunk>? _messageStreamController;
  late final StreamSubscription<ChatMessage> _chatStreamController;
  final _answerMessageBuffer = StringBuffer();
  String? _currentAssistantMessageId;
  bool _awaitingForAssistantMessage = false;
  bool _awaitingForUserMessage = false;

  @override
  void initState() {
    super.initState();
    _chatController = InMemoryChatController();
  }

  @override
  void didChangeDependencies() {
    _chatStreamController = context
        .read<MessageCubit>()
        .subscribeOnChat(widget.chat.id)
        .listen(_handleStreamingMessage);
    super.didChangeDependencies();
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
    return CyberpunkBackground(
      child: ui.Chat(
        userCache: UserCache(maxSize: 100),
        backgroundColor: Colors.transparent,
        chatController: _chatController,
        theme: ChatTheme(
          colors: ChatColors(
            primary: context.theme().colorScheme.primary,
            onPrimary: context.theme().colorScheme.onPrimary,
            surface: context.theme().colorScheme.surface,
            onSurface: context.theme().colorScheme.onSurface,
            surfaceContainer: context
                .theme()
                .colorScheme
                .surfaceContainer,
            surfaceContainerLow: context
                .theme()
                .colorScheme
                .surfaceContainerLow,
            surfaceContainerHigh: context
                .theme()
                .colorScheme
                .surfaceContainerHigh,
          ),
          typography: ChatTypography(
            bodyLarge:
                context.theme().textTheme.bodyLarge ?? TextStyle(),
            bodyMedium:
                context.theme().textTheme.bodyMedium ?? TextStyle(),
            bodySmall:
                context.theme().textTheme.bodySmall ?? TextStyle(),
            labelLarge:
                context.theme().textTheme.labelLarge ?? TextStyle(),
            labelMedium:
                context.theme().textTheme.labelMedium ?? TextStyle(),
            labelSmall:
                context.theme().textTheme.labelSmall ?? TextStyle(),
          ),
          shape: BorderRadiusGeometry.all(Radius.circular(7.0)),
        ),
        currentUserId: 'user',
        builders: Builders(
          chatMessageBuilder: _buildMessage,
          chatAnimatedListBuilder: _buildChatAnimatedList,
          composerBuilder: _buildComposer,
        ),
        resolveUser: (UserID id) async {
          // Try to resolve user by id
          if (id == ChatMessageAuthor.user.name) {
            return User(
              id: ChatMessageAuthor.user.name,
              name: ChatMessageAuthor.user.name,
            );
          } else if (id == ChatMessageAuthor.assistant.name) {
            return User(
              id: ChatMessageAuthor.assistant.name,
              name: ChatMessageAuthor.assistant.name,
            );
          }
          // fallback
          return User(id: id, name: id);
        },
      ),
    );
  }

  Widget _buildComposer(context) {
    return ChatComposer(
      chatId: widget.chat.id,
      onSendText: _onMessageSand,
      onSendVoice: _onVoiceMessageSend,
    );
  }

  void _resetAnswerMetadata() {
    _awaitingForAssistantMessage = false;
    _answerMessageBuffer.clear();
  }

  Widget _buildChatAnimatedList(context, builder) =>
      ui.ChatAnimatedListReversed(itemBuilder: builder);

  Future<void> _onMessageSand(text) async {
    logger.info('Sending prompt: $text');
    _messageStreamController?.cancel();
    final userMessageId = const Uuid().v4();
    await _chatController.insertMessage(
      Message.text(
        id: userMessageId,
        authorId: ChatMessageAuthor.user.name,
        text: text,
        createdAt: DateTime.now(),
      ),
    );
    _awaitingForUserMessage = true;
    if (mounted) {
      _messageStreamController = context
          .read<MessageCubit>()
          .sendMessage(chatId: widget.chat.id, message: text)
          .listen(_handleChunk);
    }
  }

  Future<void> _onVoiceMessageSend(
    File voice,
    String cloudPath,
  ) async {
    await _messageStreamController?.cancel();
    final userAudioMessageId = const Uuid().v4();
    await _chatController.insertMessage(
      Message.audio(
        id: userAudioMessageId,
        authorId: ChatMessageAuthor.user.name,
        source: voice.path,
        duration: Duration.zero,
        metadata: {'is_local': true},
      ),
    );

    _awaitingForUserMessage = true;
    if (mounted) {
      _messageStreamController = context
          .read<MessageCubit>()
          .sendVoiceMessage(
            chatId: widget.chat.id,
            voicePath: cloudPath,
          )
          .listen(_handleChunk);
    }
  }

  void _handleStreamingMessage(ChatMessage message) async {
    if (_awaitingForUserMessage &&
        message.author == ChatMessageAuthor.user) {
      // Find the last message sent by the user that is not yet updated
      final lastUserMessage = _chatController.messages.reversed
          .firstWhere(
            (m) => m.authorId == ChatMessageAuthor.user.name,
          );
      await _chatController.updateMessage(
        lastUserMessage,
        message.toMessage(),
      );
      _awaitingForUserMessage = false;
      return;
    }
    if (_awaitingForAssistantMessage) {
      final lastMessage = _chatController.messages.last;
      await _chatController.updateMessage(
        lastMessage,
        message.toMessage(),
      );
      _resetAnswerMetadata();
    } else {
      final messages = _chatController.messages;
      if (messages.isEmpty || messages.last.id != _answer) {
        await _chatController.insertMessage(message.toMessage());
      }
    }
  }

  void _handleChunk(final MessageChunk messageChank) async {
    if (_answerMessageBuffer.isEmpty) {
      _answerMessageBuffer.write(messageChank.chunk);
      _currentAssistantMessageId = const Uuid().v4();
      await _chatController.insertMessage(
        Message.text(
          id: _currentAssistantMessageId!,
          authorId: ChatMessageAuthor.assistant.name,
          text: _answerMessageBuffer.toString(),
          createdAt: DateTime.now(),
        ),
      );
    } else {
      final oldMessage = Message.text(
        id: _currentAssistantMessageId!,
        authorId: ChatMessageAuthor.assistant.name,
        text: _answerMessageBuffer.toString(),
        createdAt: DateTime.now(),
      );
      _answerMessageBuffer.write(messageChank.chunk);
      final newMessage = Message.text(
        id: _currentAssistantMessageId!,
        authorId: ChatMessageAuthor.assistant.name,
        text: _answerMessageBuffer.toString(),
        createdAt: DateTime.now(),
      );
      await _chatController.updateMessage(oldMessage, newMessage);
    }
    _awaitingForAssistantMessage = messageChank.isLast;
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
    final bool sentByMe =
        message.authorId == ChatMessageAuthor.user.name;
    if (message is TextMessage) {
      return ui.ChatMessage(
        leadingWidget: sentByMe
            ? null
            : TinyAvatar(chat: widget.chat),
        message: message,
        index: index,
        animation: animation,
        child: TextMessageBody(
          message: message,
          isSentByMe: sentByMe,
        ),
      );
    }
    if (message is AudioMessage) {
      return ui.ChatMessage(
        leadingWidget: sentByMe
            ? null
            : TinyAvatar(chat: widget.chat),
        message: message,
        index: index,
        animation: animation,
        child: AudioMessageBody(message: message),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: sentByMe
            ? context.theme().colorScheme.secondary
            : context.theme().colorScheme.onSurface,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Text('Unsupported message'),
    );
  }
}
