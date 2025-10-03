import 'package:flutter/material.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkButton extends StatelessWidget {
  const CyberpunkButton({
    super.key,
    required this.onClick,
    this.color,
    this.width = 100,
    required this.title,
  });

  final Function(BuildContext context)? onClick;
  final Color? color;
  final double? width;
  final String title;

  @override
  Widget build(BuildContext context) {
    final borderSide = cyberpunkBorderSide(context, color: color);
    return SizedBox(
      width: width,
      child: TextButton(
        onPressed: () => onClick?.call(context),
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color?.withAlpha(
            cyberpunkColorSecondaryAlpha,
          ),
          side: borderSide,
          shape: cyberpunkShape(borderSide),
        ),
        child: Text(title),
      ),
    );
  }
}
