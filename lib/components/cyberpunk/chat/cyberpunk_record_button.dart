import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/record/record_bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkRecordButton extends StatelessWidget {
  const CyberpunkRecordButton({
    super.key,
    required this.chatId,
    required this.onSend,
  });

  final int chatId;
  final Function(String cloudSrc) onSend;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (BuildContext context, RecordState state) {
        if (state is RecordSaved) {
          onSend(state.cloudPath);
        }
      },
      child: GestureDetector(
        onLongPressStart: (_) async {
          context.read<RecordBloc>().add(TurnOnRecordEvent());
        },
        onLongPressEnd: (_) async {
          context.read<RecordBloc>().add(
            TurnOffRecordEvent(chatId: chatId),
          );
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
      ),
    );
  }
}
