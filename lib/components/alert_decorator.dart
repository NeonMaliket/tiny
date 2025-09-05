import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/alert/alert_bloc.dart';
import 'package:tiny/theme/theme.dart';

class AlertDecorator extends StatelessWidget {
  const AlertDecorator({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlertBloc, AlertState>(
      listener: (_, state) {
        if (state is AlertOpened) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(state.title),
              content: Text(state.message),
              actions: [
                TextButton(
                  onPressed: () {
                    context.read<AlertBloc>().add(
                      CloseAlertEvent(context: context),
                    );
                    state.onConfirm(context);
                  },
                  child: const Text('Ok'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<AlertBloc>().add(
                      CloseAlertEvent(context: context),
                    );
                  },
                  child: Text(
                    'Close',
                    style: TextStyle(color: context.theme().colorScheme.error),
                  ),
                ),
              ],
            ),
          );
        } else if (state is AlertClosed) {
          if (Navigator.canPop(state.context)) {
            Navigator.of(state.context, rootNavigator: true).pop();
          }
        }
      },
      child: child,
    );
  }
}
