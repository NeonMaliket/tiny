import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ui;
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

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
    for (final m in widget.chat.history) {
      _chatController.insertMessage(
        TextMessage(
          id: m.id,
          authorId: m.author.name,
          createdAt: m.createdAt,
          text: m.content,
        ),
      );
    }

    // подписка
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
      // инкрементально обновляем
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
      chatController: _chatController,
      currentUserId: 'user',
      onMessageSend: (text) {
        _chatController.insertMessage(
          TextMessage(
            id: const UuidV4().toString(),
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
      resolveUser: (UserID id) async {
        return User(id: widget.chat.id, name: widget.chat.title);
      },
    );
  }
}
