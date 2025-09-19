import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_style.dart';
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
    final borderSide = cyberpunkBorderSide(
      context,
      isSentByMe
          ? context.theme().colorScheme.primary
          : context.theme().colorScheme.secondary,
    ).copyWith(width: 0.5);
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: ShapeDecoration(
        color: isSentByMe
            ? context.theme().colorScheme.primary.withAlpha(
                cyberpunkColorSecondaryAlpha,
              )
            : context.theme().colorScheme.secondary.withAlpha(
                cyberpunkColorSecondaryAlpha,
              ),
        shape: !isSentByMe
            ? cyberpunkShape(borderSide)
            : cyberpunkShape(borderSide).copyWith(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                ),
              ),
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
                    color: isSentByMe
                        ? context.theme().colorScheme.primary
                        : context.theme().colorScheme.secondary,
                  ),
                ),
              ],
            ),
    );
  }
}
