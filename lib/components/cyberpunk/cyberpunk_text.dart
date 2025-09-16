import 'package:flutter/material.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_glitch.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkText extends StatelessWidget {
  const CyberpunkText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: CyberpunkGlitch(
        child: Center(
          child: Text(
            text,
            style: context.theme().textTheme.headlineLarge?.copyWith(
              color: context.theme().colorScheme.primary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
