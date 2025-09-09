import 'package:animated_glitch/animated_glitch.dart';
import 'package:flutter/cupertino.dart';
import 'package:tiny/theme/theme.dart';

class GlitchButton extends StatefulWidget {
  const GlitchButton({
    super.key,
    required this.chatImage,
    required this.onClick,
  });

  final String chatImage;
  final Function() onClick;

  @override
  State<GlitchButton> createState() => _GlitchButtonState();
}

class _GlitchButtonState extends State<GlitchButton> {
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
    return GestureDetector(
      onTap: widget.onClick,
      child: SizedBox(
        height: 50,
        width: 50,
        child: AnimatedGlitch(
          showColorChannels: true,
          showDistortions: true,
          controller: _controller,
          child: Image.asset(
            widget.chatImage,
            color: context.theme().colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
