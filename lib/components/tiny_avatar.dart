import 'package:flutter/material.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/domain.dart';

class TinyAvatar extends StatelessWidget {
  const TinyAvatar({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    final defaultAsset = AssetImage(
      'assets/images/default_images/chat_logo.webp',
    );

    return _buildPlaceholder(context: context, image: defaultAsset);
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
