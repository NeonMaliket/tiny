import 'package:flutter/widgets.dart';

import 'components/components.dart';

class GlobalDecorators extends StatelessWidget {
  const GlobalDecorators({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CyberpunkLoaderDecorator(child: child);
  }
}
