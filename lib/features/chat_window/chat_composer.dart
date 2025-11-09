import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:tiny/theme/theme.dart';

class ChatComposer extends StatefulWidget {
  const ChatComposer({
    super.key,
    required this.onSendText,
    required this.onSendVoice,
  });

  final void Function(String text) onSendText;
  final void Function(File voice) onSendVoice;

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
    return Composer(
      backgroundColor: Colors.transparent,
      autocorrect: false,
      textEditingController: _controller,
      sendIcon: _isEmptyText
          ? IconButton(
              onPressed: _onSendVoice,
              icon: Icon(
                CupertinoIcons.mic_fill,
                color: context.theme().colorScheme.primary,
              ),
            )
          : IconButton(
              onPressed: _onSendText,
              icon: Icon(
                CupertinoIcons.paperplane_fill,
                color: context.theme().colorScheme.primary,
              ),
            ),
      bottom: -20,
    );
  }

  bool get _isEmptyText => _controller.text.trim().isEmpty;

  void _onSendText() {
    widget.onSendText(_controller.text.trim());
    _controller.clear();
  }

  void _onSendVoice() {
    // widget.onSendVoice.call(File('path'));
  }
}
