import 'package:flutter/widgets.dart';
import 'package:tiny/theme/theme.dart';

BorderSide cyberpunkColoredBorderSide(
  final Color color, {
  double width = 0.5,
}) {
  return BorderSide(color: color, width: width);
}

BorderSide cyberpunkBorderSide(
  final BuildContext context, {
  final Color? color,
  final double width = 1,
}) {
  return BorderSide(
    color: color ?? context.theme().colorScheme.secondaryContainer,
    width: width,
  );
}

BeveledRectangleBorder cyberpunkShape(
  final BorderSide borderSide, {
  double radius = 10,
}) {
  return BeveledRectangleBorder(
    borderRadius: BorderRadius.only(
      bottomRight: Radius.circular(radius),
      topLeft: Radius.circular(radius),
    ),
    side: borderSide,
  );
}
