import 'package:flutter/material.dart';

import 'features/features.dart';
import 'theme/theme.dart';

class TinyApplication extends StatefulWidget {
  const TinyApplication({super.key});

  @override
  State<TinyApplication> createState() => _TinyApplicationState();
}

class _TinyApplicationState extends State<TinyApplication> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
      darkTheme: appDarkTheme,
      themeMode: ThemeMode.dark,
      home: ChatWindow(),
    );
  }
}
