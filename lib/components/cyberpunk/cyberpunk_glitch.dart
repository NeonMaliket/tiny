import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/material.dart';

class CyberpunkGlitch extends StatefulWidget {
  const CyberpunkGlitch({super.key, required this.child, this.chance = 30});

  final Widget child;
  final int chance;

  @override
  State<CyberpunkGlitch> createState() => _CyberpunkGlitchState();
}

class _CyberpunkGlitchState extends State<CyberpunkGlitch> {
  late final AnimatedGlitchController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimatedGlitchController(chance: widget.chance);
  }

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
      child: widget.child,
    );
  }
}
