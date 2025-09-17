import 'package:flutter/material.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkButton extends StatelessWidget {
  const CyberpunkButton({super.key, required this.onClick, this.color});

  final Function(BuildContext context)? onClick;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(
      color: color ?? context.theme().colorScheme.secondaryContainer,
      width: 1,
    );
    return TextButton(
      onPressed: () => onClick?.call(context),
      style: TextButton.styleFrom(
        foregroundColor: color,
        side: borderSide,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(0)),
      ),
      child: const Text('OK'),
    );
  }
}
