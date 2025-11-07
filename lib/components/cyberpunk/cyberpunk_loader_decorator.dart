import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/theme/theme.dart';

class CyberpunkLoaderDecorator extends StatelessWidget {
  const CyberpunkLoaderDecorator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoaderCubit, LoaderState>(
      listener: (context, state) {
        if (state is LoaderLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(
              child: LoadingAnimationWidget.dotsTriangle(
                color: context.theme().colorScheme.primary,
                size: 25,
              ),
            ),
          );
        } else if (state is LoaderSuccess || state is LoaderFailure) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: child,
    );
  }
}
