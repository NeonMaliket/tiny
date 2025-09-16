import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';

class CyberpunkAlertDecorator extends StatelessWidget {
  const CyberpunkAlertDecorator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CyberpunkAlertBloc, CyberpunkAlertState>(
      listener: (context, state) {
        if (state is CyberpunkAlertShown) {
          showGeneralDialog(
            context: context,
            barrierDismissible: true,
            barrierLabel: 'Dismiss',
            barrierColor: Colors.black54,
            transitionDuration: const Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) {
              return Center(
                child: GestureDetector(
                  onTap: () => context.read<CyberpunkAlertBloc>().add(
                    HideCyberpunkAlertEvent(),
                  ),
                  child: CyberpunkAlert(
                    type: state.type,
                    title: state.title,
                    content: state.message,
                    onConfirm: state.onConfirm == null
                        ? null
                        : () {
                            state.onConfirm?.call();
                            context.read<CyberpunkAlertBloc>().add(
                              HideCyberpunkAlertEvent(),
                            );
                          },
                  ),
                ),
              );
            },
            transitionBuilder: (context, animation, secondaryAnimation, child) {
              final offsetAnimation =
                  Tween<Offset>(
                    begin: Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(parent: animation, curve: Curves.easeInOut),
                  );

              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(opacity: animation, child: child),
              );
            },
          );
        } else if (state is CyberpunkAlertHided) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      },
      child: child,
    );
  }
}
