import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/material.dart';
import 'package:tiny/theme/theme_icons.dart';

class CyberpunkBackground extends StatefulWidget {
  const CyberpunkBackground({super.key, required this.child});

  final Widget child;

  @override
  State<CyberpunkBackground> createState() => _CyberpunkBackgroundState();
}

class _CyberpunkBackgroundState extends State<CyberpunkBackground> {
  final AnimatedGlitchController _controller = AnimatedGlitchController(
    chance: 30,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedGlitch(
      showColorChannels: true,
      showDistortions: true,
      controller: _controller,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            opacity: 0.1,
            image: AssetImage(cyberpunkBackgroundIcon),
            fit: BoxFit.cover,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
