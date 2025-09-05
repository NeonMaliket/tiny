import 'package:flutter/material.dart';

import 'config/config.dart';
import 'theme/theme.dart';

class TinyApplication extends StatelessWidget {
  const TinyApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: goRouter,
    );
  }
}
