import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:tiny/components/cyberpunk/chat/chat.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/storage_repository.dart';
import 'package:tiny/theme/theme.dart';
import 'package:waved_audio_player/waved_audio_player.dart';

class CyberpunkAudioMessage extends StatefulWidget {
  const CyberpunkAudioMessage({super.key, required this.message});

  final ChatMessage message;

  @override
  State<CyberpunkAudioMessage> createState() => _CyberpunkAudioMessageState();
}

class _CyberpunkAudioMessageState extends State<CyberpunkAudioMessage> {
  late final Future<File> _fileFuture;

  @override
  void initState() {
    super.initState();
    _fileFuture = _loadFromCache();
  }

  Future<File> _loadFromCache() async {
    final storage = getIt<StorageRepository>();

    final bucket = storage.storageBucket;
    final src = widget.message.content.src ?? '';

    final pathInBucket = src.startsWith('$bucket/')
        ? src.replaceFirst('$bucket/', '')
        : src;
    return storage.downloadBucketFile(pathInBucket);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: _fileFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return SizedBox.shrink();
        }

        if (snapshot.hasError) {
          logger.error(
            'Error loading audio from cache',
            snapshot.error,
          );
          return const SizedBox.shrink();
        }

        final file = snapshot.data;
        if (file == null) {
          logger.error('Error: cached audio file is null');
          return const SizedBox.shrink();
        }

        return CyberpunkMessageBubble(
          message: widget.message,
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
              logger.error('Error occurred: $error.message');
            },
          ),
        );
      },
    );
  }
}
