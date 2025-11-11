import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';

class BlocErrorDecorator extends StatelessWidget {
  const BlocErrorDecorator({super.key, required this.child});
  final Widget child;

  void _handleError(BuildContext context, Object? state) {
    if (state is StorageFailure ||
        state is ChatListError ||
        state is ChatCreationError ||
        state is MessageError ||
        state is MessageStreamigError) {
      print('Error detected in BlocErrorDecorator: $state');
      final message = (state as dynamic).error ?? 'Unknown error';
      context.read<CyberpunkAlertBloc>().add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: message,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StorageCubit, StorageState>(
          listener: _handleError,
        ),
        BlocListener<ChatBloc, ChatState>(listener: _handleError),
        BlocListener<MessageCubit, MessageState>(
          listener: _handleError,
        ),
      ],
      child: child,
    );
  }
}
