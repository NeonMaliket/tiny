import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/features/chat_window/chat_window.dart';
import 'package:tiny/theme/theme.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [BlocProvider(create: (_) => ChatBloc())],
      child: const TinyApplication(),
    ),
  );
}

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
