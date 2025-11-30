import 'package:flutter/material.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/chat_message.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkMessageBubble extends StatelessWidget {
  const CyberpunkMessageBubble({
    super.key,
    required this.child,
    required this.message,
  });

  final ChatMessage message;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final maxBubbleWidth = MediaQuery.of(context).size.width * 0.85;

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
            child: child,
          ),
        ),
      ),
    );
  }
}
