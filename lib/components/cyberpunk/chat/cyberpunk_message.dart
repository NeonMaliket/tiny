import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:intl/intl.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkMessage extends StatelessWidget {
  const CyberpunkMessage({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.75;

    return Align(
      alignment: message.isUser
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxBubbleWidth),
        child: IntrinsicWidth(
          child: CyberpunkContainer(
            color: message.isUser
                ? context.theme().colorScheme.primaryContainer
                : context.theme().colorScheme.secondary,
            backgroundColor: message.isUser
                ? context
                      .theme()
                      .colorScheme
                      .primaryContainer
                      .withAlpha(30)
                : context.theme().colorScheme.secondary.withAlpha(30),
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
          ),
        ),
      ),
    );
  }
}
