import 'package:flutter/material.dart';

import 'cyberpunk.dart';

class CyberpunkIcon extends StatelessWidget {
  const CyberpunkIcon({super.key, required this.icon, this.glitching = true});

  final IconData icon;
  final bool glitching;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      width: 24,
      child: glitching ? CyberpunkGlitch(child: Icon(icon)) : Icon(icon),
    );
  }
}
