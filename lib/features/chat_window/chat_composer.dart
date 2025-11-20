import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:tiny/bloc/record/record_bloc.dart';
import 'package:tiny/components/cyberpunk/cyberpunk_record_button.dart';
import 'package:tiny/theme/theme.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSendText,
    required this.onSendVoice,
    required this.chatId,
  });

  final int chatId;
  final void Function(String text) onSendText;
  final void Function(File voice, String cloudPath) onSendVoice;

  @override
  State<ChatComposer> createState() => _ChatComposerState();
}

class _ChatComposerState extends State<ChatComposer> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    _controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecordBloc, RecordState>(
      listener: (BuildContext context, RecordState state) {
        if (state is RecordSaved) {
          widget.onSendVoice(state.record, state.cloudPath);
        }
      },
      child: Composer(
        backgroundColor: Colors.transparent,
        autocorrect: false,
        textEditingController: _controller,
        sendIcon: _isEmptyText
            ? CyberpunkRecordButton(chatId: widget.chatId)
            : GestureDetector(
                onTap: _onSendText,
                child: Icon(
                  CupertinoIcons.paperplane_fill,
                  color: context.theme().colorScheme.primary,
                ),
              ),
      ),
    );
  }

  bool get _isEmptyText => _controller.text.trim().isEmpty;

  void _onSendText() {
    widget.onSendText(_controller.text.trim());
    _controller.clear();
  }
}
