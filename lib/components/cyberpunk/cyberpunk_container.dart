import 'package:flutter/widgets.dart';
import 'package:tiny/components/components.dart';

class CyberpunkContainer extends StatelessWidget {
  const CyberpunkContainer({
    super.key,
    required this.child,
    required this.color,
    required this.backgroundColor,
    this.invertShape = false,
  });

  final Widget child;
  final Color color;
  final Color backgroundColor;
  final bool invertShape;
  @override
  Widget build(BuildContext context) {
    final borderSide = cyberpunkBorderSide(
      context,
      color: color,
    ).copyWith(width: 0.5);
    return IntrinsicWidth(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: ShapeDecoration(
          color: backgroundColor,
          shape: !invertShape
              ? cyberpunkShape(borderSide)
              : cyberpunkShape(borderSide).copyWith(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
        ),
        child: child,
      ),
    );
  }
}
