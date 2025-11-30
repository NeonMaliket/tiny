import 'package:flutter/cupertino.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkMessageButton extends StatelessWidget {
  const CyberpunkMessageButton({
    super.key,
    required this.chatId,
    required this.onSend,
  });

  final int chatId;
  final Function() onSend;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSend,
      child: SizedBox(
        width: 32,
        height: 32,
        child: CyberpunkGlitch(
          chance: 100,
          isEnabled: true,
          child: Icon(
            CupertinoIcons.paperplane,
            color: context.theme().colorScheme.primary,
            size: 32,
          ),
        ),
      ),
    );
  }
}
