import 'package:flutter/material.dart';

final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFF1A1C1F), // мягкий графит
  primaryColor: const Color(0xFFC9B458), // золотистый акцент
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFFC9B458), // мягкий жёлтый
    secondary: Color(0xFF6ABFC3), // мягкий бирюзовый
    surface: Color(0xFF23262B),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.white,
    error: Colors.redAccent,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF23262B),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: const CardThemeData(
    color: Color(0xFF23262B),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    elevation: 2,
    margin: EdgeInsets.all(8),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF2A2D32),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    hintStyle: TextStyle(color: Colors.white38),
    floatingLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Color(0xFF6ABFC3), // бирюзовый акцент
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Color(0xFFC9B458), // золотистая кнопка
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  dividerColor: Colors.white24,
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white70,
    textColor: Colors.white,
    tileColor: Color(0xFF23262B),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  sliderTheme: const SliderThemeData(
    activeTrackColor: Color(0xFFC9B458),
    inactiveTrackColor: Colors.white24,
    thumbColor: Color(0xFF6ABFC3),
    overlayColor: Color(0x406ABFC3),
  ),
  dialogTheme: const DialogThemeData(backgroundColor: Color(0xFF23262B)),
);

final ThemeData appLightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: const Color(0xFFF4F5F7),
  primaryColor: const Color(0xFFC9B458),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFC9B458),
    secondary: Color(0xFF6ABFC3),
    surface: Color(0xFFFFFFFF),
    onPrimary: Colors.black,
    onSecondary: Colors.black,
    onSurface: Colors.black,
    error: Colors.red,
    onError: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black87),
    titleTextStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  cardTheme: const CardThemeData(
    color: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    elevation: 2,
    margin: EdgeInsets.all(8),
  ),
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.black87,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.black87,
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF0F0F0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide.none,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    hintStyle: TextStyle(color: Colors.black38),
    floatingLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: Color(0xFF6ABFC3),
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Color(0xFFC9B458),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black54),
  dividerColor: Colors.black12,
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black54,
    textColor: Colors.black87,
    tileColor: Color(0xFFF9F9F9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  sliderTheme: const SliderThemeData(
    activeTrackColor: Color(0xFFC9B458),
    inactiveTrackColor: Colors.black26,
    thumbColor: Color(0xFF6ABFC3),
    overlayColor: Color(0x406ABFC3),
  ),
  dialogTheme: const DialogThemeData(backgroundColor: Color(0xFFFFFFFF)),
);

extension RagTheme on BuildContext {
  ThemeData theme() {
    return Theme.of(this);
  }
}
