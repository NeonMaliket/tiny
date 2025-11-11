import 'package:flutter/widgets.dart';
import 'package:tiny/decorators/decorators.dart';

import 'components/components.dart';

class GlobalDecorators extends StatelessWidget {
  const GlobalDecorators({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocErrorDecorator(
      child: CyberpunkLoaderDecorator(child: child),
    );
  }
}
