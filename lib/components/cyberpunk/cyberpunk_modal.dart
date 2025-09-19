import 'package:flutter/material.dart';
import 'package:tiny/components/components.dart';

typedef CyberpunkModalCallback =
    void Function(BuildContext context, TextEditingController controller);

class CyberpunkModal extends StatefulWidget {
  const CyberpunkModal({
    super.key,
    required this.title,
    this.onClose,
    this.onConfirm,
  });

  final String title;
  final CyberpunkModalCallback? onClose;
  final CyberpunkModalCallback? onConfirm;

  @override
  State<CyberpunkModal> createState() => _CyberpunkModalState();
}

class _CyberpunkModalState extends State<CyberpunkModal> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CyberpunkAlert(
      title: widget.title,
      content: TextField(
        decoration: InputDecoration(
          hintText: 'Chat title',
          border: OutlineInputBorder(),
        ),
        controller: _controller,
      ),
      type: CyberpunkAlertType.success,
      onCancel: widget.onClose == null
          ? null
          : (ctx) => widget.onClose?.call(ctx, _controller),
      onConfirm: widget.onConfirm == null
          ? null
          : (ctx) => widget.onConfirm?.call(ctx, _controller),
    );
  }
}
