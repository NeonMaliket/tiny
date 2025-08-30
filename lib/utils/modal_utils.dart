import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

showBottomModal(BuildContext context, Widget child) {
  showMaterialModalBottomSheet(
    expand: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => AspectRatio(aspectRatio: 1 / 3, child: child),
  );
}
