import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tiny/global_decorators.dart';

import 'config/config.dart';
import 'theme/theme.dart';

class TinyApplication extends StatelessWidget {
  const TinyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: kDebugMode,
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
