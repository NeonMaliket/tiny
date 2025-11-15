import 'dart:async';
import 'dart:io';
import 'dart:math';

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
  final _pcmController = StreamController<Uint8List>();
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _pcmController.stream.listen((frames) {
      print('Received ${pcmVolume(frames)} samples');
    });
  }

  @override
  void dispose() {
    _pcmController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) async {
        await HapticFeedback.mediumImpact();
        await recorder.openRecorder();
        await recorder.startRecorder(
          toStream: _pcmController.sink,
          sampleRate: 16000,
          numChannels: 1,
          codec: Codec.pcm16,
        );
        setState(() => _isRecording = true);
      },
      onLongPressEnd: (_) async {
        await HapticFeedback.mediumImpact();
        await recorder.stopRecorder();
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

  num pcmVolume(Uint8List bytes) {
    final int sampleCount = bytes.length ~/ 2;

    double sum = 0;

    for (int i = 0; i < bytes.length; i += 2) {
      final int sample = (bytes[i] | (bytes[i + 1] << 8));
      final double s = sample.toDouble();
      sum += s * s;
    }

    final rms = sqrt(sum / sampleCount);
    final norm = (rms / 32768).clamp(0, 1);

    return norm;
  }
}
