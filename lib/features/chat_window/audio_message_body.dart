import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_container.dart'
    show CyberpunkContainer;
import 'package:tiny/config/config.dart';
import 'package:tiny/repository/storage_repository.dart';
import 'package:tiny/theme/theme.dart';
import 'package:waved_audio_player/waved_audio_player.dart';

class AudioMessageBody extends StatelessWidget {
  const AudioMessageBody({super.key, required this.message});

  final AudioMessage message;

  Future<File> _loadFromCache() async {
    final isLocal = message.metadata?['is_local'] as bool? ?? false;
    if (isLocal) {
      return File(message.source);
    }
    final storage = getIt<StorageRepository>();

    final bucket = storage.storageBucket;
    final src = message.source;

    final pathInBucket = src.startsWith('$bucket/')
        ? src.replaceFirst('$bucket/', '')
        : src;
    final file = await storage.downloadBucketFile(pathInBucket);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _loadFromCache(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox.shrink();
        }

        if (snapshot.hasError) {
          logger.e(
            'Error loading audio from cache',
            error: snapshot.error,
          );
          return const SizedBox.shrink();
        }

        final file = snapshot.data;
        if (file == null) {
          logger.e('Error: cached audio file is null');
          return const SizedBox.shrink();
        }

        return CyberpunkContainer(
          color: context.theme().colorScheme.primary,
          backgroundColor: context
              .theme()
              .colorScheme
              .primary
              .withAlpha(30),
          child: WavedAudioPlayer(
            spacing: 2,
            waveHeight: 25,
            source: DeviceFileSource(
              file.path,
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
      },
    );
  }
}
