import 'package:flutter/material.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';

const int cyberpunkColorLargeAlpha = 100;
const int cyberpunkColorPrimaryAlpha = 50;
const int cyberpunkColorSecondaryAlpha = 30;
const int cyberpunkColorLowAlpha = 10;

enum CyberpunkColorPalette {
  background(color: Color.fromRGBO(26, 28, 31, 1)),
  primary(color: Color(0xFFC9B458)),
  secondary(color: Color(0xFF6ABFC3)),
  accent(color: Colors.green),
  surface(color: Color(0xFF23262B)),
  onPrimary(color: Colors.black),
  onSecondary(color: Colors.black),
  onSurface(color: Colors.white),
  error(color: Colors.redAccent),
  onError(color: Colors.white);

  final Color color;

  const CyberpunkColorPalette({required this.color});
}

enum CyberpunkFontStyle {
  cyberpunkContent(fontFamily: 'CyberpunkContent'),
  cyberpunk(fontFamily: 'Cyberpunk');

  final String fontFamily;

  const CyberpunkFontStyle({required this.fontFamily});
}

final ThemeData appDarkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: CyberpunkColorPalette.background.color,
  primaryColor: CyberpunkColorPalette.primary.color,
  secondaryHeaderColor: CyberpunkColorPalette.secondary.color,
  colorScheme: ColorScheme.dark(
    primary: CyberpunkColorPalette.primary.color,
    secondary: CyberpunkColorPalette.secondary.color,
    surface: CyberpunkColorPalette.surface.color,
    onPrimary: CyberpunkColorPalette.onPrimary.color,
    onSecondary: CyberpunkColorPalette.onSecondary.color,
    onSurface: CyberpunkColorPalette.onSurface.color,
    error: CyberpunkColorPalette.error.color,
    onError: CyberpunkColorPalette.onError.color,
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: CyberpunkColorPalette.surface.color,
    elevation: 0,
    iconTheme: IconThemeData(color: CyberpunkColorPalette.onSurface.color),
    titleTextStyle: TextStyle(
      color: CyberpunkColorPalette.onSurface.color,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      fontFamily: CyberpunkFontStyle.cyberpunk.fontFamily,
    ),
  ),
  cardTheme: CardThemeData(
    color: CyberpunkColorPalette.surface.color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
    elevation: 2,
    margin: EdgeInsets.all(8),
  ),
  textTheme: TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: CyberpunkColorPalette.secondary.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    titleMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: CyberpunkColorPalette.primary.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    titleSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunk.fontFamily,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.transparent,
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: CyberpunkColorPalette.primary.color,
        width: 0.5,
      ),
    ),
    errorStyle: TextStyle(
      color: CyberpunkColorPalette.error.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
    hintStyle: TextStyle(
      color: CyberpunkColorPalette.onSurface.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    floatingLabelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 20,
      color: CyberpunkColorPalette.secondary.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: CyberpunkColorPalette.primary.color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      textStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
      ),
    ),
  ),
  iconTheme: IconThemeData(color: CyberpunkColorPalette.primary.color),
  dividerColor: CyberpunkColorPalette.accent.color.withAlpha(24),
  splashColor: CyberpunkColorPalette.secondary.color.withAlpha(
    cyberpunkColorPrimaryAlpha,
  ),
  listTileTheme: ListTileThemeData(
    style: ListTileStyle.list,
    leadingAndTrailingTextStyle: TextStyle(
      color: CyberpunkColorPalette.primary.color,
      fontFamily: CyberpunkFontStyle.cyberpunkContent.fontFamily,
    ),
    iconColor: CyberpunkColorPalette.primary.color,
    textColor: CyberpunkColorPalette.onSurface.color,
    tileColor: CyberpunkColorPalette.secondary.color.withAlpha(
      cyberpunkColorLowAlpha,
    ),
    shape: cyberpunkShape(
      cyberpunkColoredBorderSide(const Color.fromARGB(255, 150, 186, 187)),
    ),
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: CyberpunkColorPalette.primary.color,
    inactiveTrackColor: CyberpunkColorPalette.onSurface.color.withAlpha(24),
    thumbColor: CyberpunkColorPalette.secondary.color,
    overlayColor: CyberpunkColorPalette.secondary.color.withAlpha(40),
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: CyberpunkColorPalette.surface.color,
  ),
);

extension CyberpunkTheme on BuildContext {
  ThemeData theme() {
    return Theme.of(this);
  }
}

extension ColorsExtension on ColorScheme {
  Color get accentColor => CyberpunkColorPalette.accent.color;
}
