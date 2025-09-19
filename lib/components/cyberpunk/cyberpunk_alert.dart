import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/theme.dart';

enum CyberpunkAlertType { success, info, error }

class CyberpunkAlert extends StatelessWidget {
  const CyberpunkAlert({
    super.key,
    required this.title,
    required this.content,
    this.onConfirm,
    this.type = CyberpunkAlertType.success,
    this.onCancel,
  });

  final CyberpunkAlertType type;
  final String title;
  final String content;
  final Function(BuildContext context)? onConfirm;
  final Function(BuildContext context)? onCancel;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      CyberpunkAlertType.success => context.theme().colorScheme.accentColor,
      CyberpunkAlertType.info => context.theme().colorScheme.secondaryContainer,
      CyberpunkAlertType.error => context.theme().colorScheme.errorContainer,
    };
    final borderSide = BorderSide(color: color, width: 1);
    final emptyBorderSide = BorderSide(color: color.withAlpha(0), width: 0);
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: CyberpunkGlitch(
                    chance: 100,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: color.withAlpha(50),
                        border: Border(
                          left: borderSide,
                          top: borderSide,
                          right: emptyBorderSide,
                          bottom: borderSide,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 11,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: ShapeDecoration(
                      color: color.withAlpha(50),
                      shape: BeveledRectangleBorder(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(10),
                        ),
                        side: borderSide,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: context.theme().textTheme.titleLarge?.copyWith(
                            color: color,
                          ),
                        ),
                        Divider(color: color.withAlpha(100)),
                        Text(
                          content,
                          style: context.theme().textTheme.labelLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (onConfirm != null && onCancel != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onConfirm != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                    child: CyberpunkButton(
                      color: color,
                      onClick: onConfirm,
                      title: 'OK',
                    ),
                  ),
                if (onCancel != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CyberpunkButton(
                      color: color,
                      onClick: onCancel,
                      title: 'Cancel',
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
