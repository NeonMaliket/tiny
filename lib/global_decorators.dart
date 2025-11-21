import 'package:flutter/widgets.dart';
import 'package:tiny/decorators/decorators.dart';
import 'package:tiny/decorators/logger_preview_decorator.dart';

class GlobalDecorators extends StatelessWidget {
  const GlobalDecorators({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LoggerPreviewDecorator(
      child: BlocErrorDecorator(
        child: CyberpunkLoaderDecorator(child: child),
      ),
    );
  }
}
