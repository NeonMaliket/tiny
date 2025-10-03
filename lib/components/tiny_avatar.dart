import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

class TinyAvatar extends StatelessWidget {
  const TinyAvatar({super.key, this.metadata});

  final DocumentMetadata? metadata;

  @override
  Widget build(BuildContext context) {
    final defaultAsset = AssetImage(
      'assets/images/default_images/chat_logo.webp',
    );
    return metadata == null
        ? _buildPlaceholder(context: context, image: defaultAsset)
        : FutureBuilder<String>(
            future: getIt<StorageRepository>().downloadDocument(
              metadata!,
            ),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                return _buildPlaceholder(
                  context: context,
                  image: FileImage(File(snapshot.data!)),
                );
              } else {
                return _buildPlaceholder(
                  context: context,
                  image: defaultAsset,
                );
              }
            },
          );
  }

  Widget _buildPlaceholder({
    required final BuildContext context,
    required final ImageProvider image,
  }) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(right: 5.0),
      width: 30,
      height: 30,
      decoration: ShapeDecoration(
        shape: cyberpunkShape(
          cyberpunkBorderSide(context, width: 0.5),
          radius: 4,
        ),
        image: DecorationImage(image: image, fit: BoxFit.cover),
      ),
    );
  }
}
