import 'package:flutter/cupertino.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkRecordButton extends StatelessWidget {
  const CyberpunkRecordButton({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) async {
        // context.read<RecordBloc>().add(TurnOnRecordEvent());
      },
      onLongPressEnd: (_) async {
        // context.read<RecordBloc>().add(
        // TurnOffRecordEvent(chatId: chatId),
        // );
      },
      child: CyberpunkBlur(
        backgroundColor: context.theme().colorScheme.secondary,
        backgroundAlpha: 15,
        child: SizedBox(
          width: 32,
          height: 32,
          child: CyberpunkGlitch(
            chance: 100,
            isEnabled: true,
            child: Icon(
              CupertinoIcons.mic_fill,
              color: context.theme().colorScheme.primary,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }
}
