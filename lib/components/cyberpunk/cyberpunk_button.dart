import 'package:flutter/material.dart';
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
    final borderSide = BorderSide(
      color: color ?? context.theme().colorScheme.secondaryContainer,
      width: 1,
    );
    return SizedBox(
      width: width,
      child: TextButton(
        onPressed: () => onClick?.call(context),
        style: TextButton.styleFrom(
          foregroundColor: color,
          backgroundColor: color?.withAlpha(30),
          side: borderSide,
          shape: BeveledRectangleBorder(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
            ),
            side: borderSide,
          ),
        ),
        child: Text(title),
      ),
    );
  }
}
