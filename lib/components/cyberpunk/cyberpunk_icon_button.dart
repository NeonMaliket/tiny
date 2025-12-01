import 'package:flutter/material.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkIconButton extends StatelessWidget {
  const CyberpunkIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.color,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? context.theme().colorScheme.secondary;
    return CyberpunkBlur(
      backgroundColor: color,
      backgroundAlpha: 30,
      child: IconButton(
        onPressed: onPressed,
        icon: CyberpunkIcon(icon: icon, color: color),
      ),
    );
  }
}
