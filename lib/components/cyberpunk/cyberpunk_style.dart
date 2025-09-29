import 'package:flutter/widgets.dart';
import 'package:tiny/theme/theme.dart';

BorderSide cyberpunkColoredBorderSide(final Color color, {double width = 0.5}) {
  return BorderSide(color: color, width: width);
}

BorderSide cyberpunkBorderSide(final BuildContext context, final Color? color) {
  return BorderSide(
    color: color ?? context.theme().colorScheme.secondaryContainer,
    width: 1,
  );
}

BeveledRectangleBorder cyberpunkShape(final BorderSide borderSide) {
  return BeveledRectangleBorder(
    borderRadius: const BorderRadius.only(
      bottomRight: Radius.circular(10),
      topLeft: Radius.circular(10),
    ),
    side: borderSide,
  );
}
