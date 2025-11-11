import 'package:flutter/material.dart';
import 'package:tiny/global_decorators.dart';

import 'config/config.dart';
import 'theme/theme.dart';

class TinyApplication extends StatelessWidget {
  const TinyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: goRouter,
      builder: (context, child) {
        if (child != null) {
          return GlobalDecorators(child: child);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
