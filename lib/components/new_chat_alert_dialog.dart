import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/theme/theme.dart';

import 'package:tiny/bloc/chat/chat_bloc.dart';

class NewChatAlertDialog extends StatefulWidget {
  const NewChatAlertDialog({super.key});

  @override
  State<NewChatAlertDialog> createState() => _NewChatAlertDialogState();
}

class _NewChatAlertDialogState extends State<NewChatAlertDialog> {
  final _titleController = TextEditingController();
  bool _isActive = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _titleController,
        decoration: const InputDecoration(labelText: 'Chat Title'),
        onChanged: (val) => setState(() => _isActive = val.isNotEmpty),
        onSubmitted: (title) {
          context.read<ChatBloc>().add(NewChatEvent(title: title));
          Navigator.of(context).pop();
        },
      ),
      actions: [
        TextButton(
          onPressed: _isActive
              ? () {
                  context.read<ChatBloc>().add(
                    NewChatEvent(title: _titleController.text),
                  );
                  Navigator.of(context).pop();
                }
              : null,
          child: const Text('Create'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: context.theme().colorScheme.error),
          ),
        ),
      ],
    );
  }
}
