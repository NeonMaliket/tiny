import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/ai/ai_bloc.dart';
import 'package:tiny/bloc/message/message_cubit.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/chat.dart';
import 'package:tiny/domain/chat_message.dart';
import 'package:tiny/domain/message_content.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkComposer extends StatefulWidget {
  const CyberpunkComposer({super.key, required this.chat});

  final Chat chat;

  @override
  State<CyberpunkComposer> createState() => _CyberpunkComposerState();
}

class _CyberpunkComposerState extends State<CyberpunkComposer> {
  final _conposerController = TextEditingController();
  final model = 'llama-3.1-8b-instant';

  @override
  void initState() {
    _conposerController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _conposerController.dispose();
    super.dispose();
  }

  ChatMessage buildMessage(
    MessageContent content,
    ChatMessageType type,
  ) {
    return ChatMessage(
      content: content,
      createdAt: DateTime.now(),
      chatId: widget.chat.id,
      author: ChatMessageAuthor.user,
      messageType: type,
    );
  }

  void onMessageSend() {
    final message = buildMessage(
      MessageContent.text(_conposerController.text),
      ChatMessageType.text,
    );
    context.read<AiBloc>().add(
      AiSendMessageEvent(
        message: message,
        chatSettings: widget.chat.settings,
        model: model,
      ),
    );
  }

  void onVoiceSend(String cloudSrc) {
    final message = buildMessage(
      MessageContent.voice(cloudSrc),
      ChatMessageType.voice,
    );
    context.read<AiBloc>().add(
      AiSendMessageEvent(
        message: message,
        chatSettings: widget.chat.settings,
        model: model,
      ),
    );
  }

  Widget buildSendButton() {
    return BlocBuilder<AiBloc, AiState>(
      builder: (BuildContext context, AiState state) {
        final isSending = state is AiMessageProcessing;

        if (isSending) {
          return CyberpunkBlur(child: LoaderWidget());
        }

        if (_conposerController.text.isEmpty) {
          return CyberpunkRecordButton(
            chatId: widget.chat.id,
            onSend: onVoiceSend,
          );
        } else {
          return CyberpunkMessageButton(
            chatId: widget.chat.id,
            onSend: onMessageSend,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MessageCubit, MessageState>(
      listener: (BuildContext context, MessageState state) {
        if (state is MessageReceived &&
            state.message.chatId == widget.chat.id) {
          _conposerController.clear();
        }
      },
      child: Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: Padding(
          padding: .only(bottom: 32, left: 16.0, right: 16.0),
          child: CyberpunkBlur(
            borderColor: context.theme().colorScheme.primary,
            child: TextField(
              minLines: 1,
              maxLines: 3,
              controller: _conposerController,
              decoration: InputDecoration(
                hintText: 'Type a message...',
                filled: true,
                fillColor: context
                    .theme()
                    .colorScheme
                    .secondary
                    .withAlpha(10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                suffixIcon: buildSendButton(),
              ),
              style: context.theme().textTheme.bodyMedium,
            ),
          ),
        ),
      ),
    );
  }
}
