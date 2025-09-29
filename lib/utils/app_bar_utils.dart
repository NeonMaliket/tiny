import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/theme/theme.dart';

AppBar appBar(BuildContext context, {List<Widget>? actions}) {
  return AppBar(
    centerTitle: true,
    backgroundColor: Colors.transparent,
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
        child: Container(
          color: context.theme().colorScheme.secondary.withAlpha(10),
        ),
      ),
    ),
    actions: actions,
    title: SizedBox(
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [SizedBox(width: 100, child: CyberpunkText(text: 'Tiny'))],
      ),
    ),
  );
}
