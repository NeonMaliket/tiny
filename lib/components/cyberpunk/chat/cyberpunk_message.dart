import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:intl/intl.dart';
import 'package:tiny/components/cyberpunk/chat/cyberpunk_message_bubble.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkMessage extends StatelessWidget {
  const CyberpunkMessage({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    return CyberpunkMessageBubble(
      message: message,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GptMarkdown(
            message.content.text ?? "",
            style: TextStyle(
              color: context.theme().colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            DateFormat('HH:mm').format(message.createdAt),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: message.isUser
                  ? context.theme().colorScheme.primary
                  : context.theme().colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
