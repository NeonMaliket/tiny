import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_container.dart'
    show CyberpunkContainer;
import 'package:tiny/config/app_config.dart';
import 'package:tiny/theme/theme.dart';
import 'package:waved_audio_player/waved_audio_player.dart';

class AudioMessageBody extends StatelessWidget {
  const AudioMessageBody({super.key, required this.message});

  final AudioMessage message;

  @override
  Widget build(BuildContext context) {
    return CyberpunkContainer(
      color: context.theme().colorScheme.primary,
      backgroundColor: context.theme().colorScheme.primary.withAlpha(
        30,
      ),
      child: WavedAudioPlayer(
        source: DeviceFileSource(
          message.source,
          mimeType: 'audio/mp4',
        ),
        iconColor: context.theme().colorScheme.secondary,
        iconBackgoundColor: context
            .theme()
            .colorScheme
            .secondary
            .withAlpha(30),
        playedColor: context.theme().colorScheme.primary,
        unplayedColor: context
            .theme()
            .colorScheme
            .onSurface
            .withAlpha(100),
        barWidth: 2,
        buttonSize: 40,
        showTiming: true,
        onError: (error) {
          logger.e('Error occurred: $error.message');
        },
      ),
    );
  }
}
