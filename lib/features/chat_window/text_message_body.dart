import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:tiny/theme/theme.dart';

class TextMessageBody extends StatelessWidget {
  const TextMessageBody({
    super.key,
    required this.message,
    required this.isSentByMe,
  });

  final TextMessage message;
  final bool isSentByMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: isSentByMe
            ? context.theme().colorScheme.secondary.withAlpha(50)
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
                    color: context.theme().colorScheme.onSurface.withAlpha(90),
                  ),
                ),
              ],
            ),
    );
  }
}
