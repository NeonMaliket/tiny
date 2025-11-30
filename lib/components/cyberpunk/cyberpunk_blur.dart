import 'dart:ui';

import 'package:flutter/material.dart';

class CyberpunkBlur extends StatelessWidget {
  const CyberpunkBlur({
    super.key,
    required this.child,
    this.borderRadius = 25,
    this.sigmaX = 14,
    this.sigmaY = 14,
    this.padding = EdgeInsets.zero,
    this.backgroundAlpha = 140,
    this.borderAlpha = 25,
    this.borderWidth = 1,
    this.backgroundColor,
    this.borderColor,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget child;

  final double borderRadius;
  final double sigmaX;
  final double sigmaY;

  final EdgeInsets padding;

  final int backgroundAlpha;
  final int borderAlpha;
  final double borderWidth;

  final Color? backgroundColor;
  final Color? borderColor;

  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: clipBehavior,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: (backgroundColor ?? theme.colorScheme.surface)
                .withAlpha(backgroundAlpha),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              width: borderWidth,
              color: (borderColor ?? theme.colorScheme.onSurface)
                  .withAlpha(borderAlpha),
            ),
          ),
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}
