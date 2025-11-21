import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shake_gesture/shake_gesture.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:tiny/config/config.dart';

class LoggerPreviewDecorator extends StatefulWidget {
  const LoggerPreviewDecorator({super.key, required this.child});

  final Widget child;

  @override
  State<LoggerPreviewDecorator> createState() =>
      _LoggerPreviewDecoratorState();
}

class _LoggerPreviewDecoratorState
    extends State<LoggerPreviewDecorator> {
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    ShakeGesture.registerCallback(onShake: _onShake);
    logger.info('Logger Preview Decorator initialized');
  }

  @override
  void dispose() {
    ShakeGesture.unregisterCallback(onShake: _onShake);
    super.dispose();
  }

  void _onShake() {
    if (_isVisible) {
      Navigator.of(
        navigatorKey.currentContext!,
        rootNavigator: true,
      ).maybePop();
      _isVisible = false;
    } else {
      _isVisible = true;
      showBarModalBottomSheet(
        context: navigatorKey.currentContext!,
        builder: (_) => TalkerScreen(talker: logger),
      ).whenComplete(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
