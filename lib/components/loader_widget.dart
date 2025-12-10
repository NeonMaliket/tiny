import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tiny/theme/theme.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.dotsTriangle(
      color: context.theme().colorScheme.primary,
      size: 25,
    );
  }
}
