import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:logger/logger.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkRecordButton extends StatefulWidget {
  const CyberpunkRecordButton({
    super.key,
    required this.onRecordComplete,
  });

  final Function(File record) onRecordComplete;

  @override
  State<CyberpunkRecordButton> createState() =>
      _CyberpunkRecordButtonState();
}

class _CyberpunkRecordButtonState
    extends State<CyberpunkRecordButton> {
  final recorder = FlutterSoundRecorder(logLevel: Level.error);
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) async {
        final toFile =
            '${Directory.systemTemp.path}/record_${DateTime.now().millisecondsSinceEpoch}.aac';
        await HapticFeedback.mediumImpact();
        await recorder.openRecorder();
        await recorder.startRecorder(
          toFile: toFile,
          sampleRate: 16000,
          numChannels: 1,
          codec: Codec.aacADTS,
        );
        setState(() => _isRecording = true);
      },
      onLongPressEnd: (_) async {
        await HapticFeedback.mediumImpact();
      
        final filePath = await recorder.stopRecorder();
        while (!recorder.isStopped) {
          await Future.delayed(const Duration(milliseconds: 10));
        }
        if (filePath != null) {
          final recordedFile = File(filePath);
          widget.onRecordComplete(recordedFile);
        }
        setState(() => _isRecording = false);
      },
      child: SizedBox(
        width: 32,
        height: 32,
        child: CyberpunkGlitch(
          chance: 100,
          isEnabled: _isRecording,
          child: Icon(
            CupertinoIcons.mic_fill,
            color: _isRecording
                ? context.theme().colorScheme.secondary
                : context.theme().colorScheme.primary,
            size: 32,
          ),
        ),
      ),
    );
  }
}
