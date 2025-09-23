import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';

SettingsThemeData settingsThemeData(BuildContext context) {
  return SettingsThemeData(
    settingsListBackground: Colors.transparent,
    titleTextColor: Theme.of(context).colorScheme.onSurface,
    leadingIconsColor: Theme.of(context).colorScheme.secondary,
    settingsSectionBackground: Theme.of(context).cardColor,
  );
}
