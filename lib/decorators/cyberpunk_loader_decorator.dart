import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
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
            context: navigatorKey.currentContext ?? context,
            barrierDismissible: false,
            builder: (context) => CyberpunkGlitch(
              chance: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    LoaderWidget(),
                    const SizedBox(height: 20),
                    Text(
                      state.message,
                      style: context
                          .theme()
                          .textTheme
                          .bodyMedium
                          ?.copyWith(
                            color: context
                                .theme()
                                .colorScheme
                                .onSurface,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (state is LoaderSuccess || state is LoaderFailure) {
          navigatorKey.currentState?.pop();
        }
      },
      child: child,
    );
  }
}
