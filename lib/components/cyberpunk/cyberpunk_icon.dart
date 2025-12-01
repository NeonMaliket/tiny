import 'package:flutter/material.dart';

import 'cyberpunk.dart';

class CyberpunkIcon extends StatelessWidget {
  const CyberpunkIcon({
    super.key,
    required this.icon,
    this.glitching = true,
    this.color,
  });

  final IconData icon;
  final bool glitching;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: glitching
          ? CyberpunkGlitch(child: Icon(icon, color: color))
          : Icon(icon, color: color),
    );
  }
}
