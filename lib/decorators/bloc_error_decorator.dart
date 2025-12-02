import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/bloc/record/record_bloc.dart';
import 'package:tiny/components/components.dart';

class BlocErrorDecorator extends StatelessWidget {
  const BlocErrorDecorator({super.key, required this.child});
  final Widget child;

  void _handleError(BuildContext context, Object? state) {
    if (state is StorageFailure ||
        state is ChatListError ||
        state is ChatCreationError ||
        state is MessageError ||
        state is ContextDocumentsError ||
        state is MessageStreamigError ||
        state is MessageError ||
        state is AiMessageFailure ||
        state is MessagesFetchError ||
        state is RecordError) {
      final message =
          'An unexpected error occurred. Please try again.';
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
        BlocListener<ContextDocumentsCubit, ContextDocumentsState>(
          listener: _handleError,
        ),
        BlocListener<MessageCubit, MessageState>(
          listener: _handleError,
        ),
        BlocListener<RecordBloc, RecordState>(listener: _handleError),
        BlocListener<AiBloc, AiState>(listener: _handleError),
      ],
      child: child,
    );
  }
}
