import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/repository/repository.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsList(
      darkTheme: SettingsThemeData(
        settingsListBackground: Theme.of(context).colorScheme.surface,
        titleTextColor: Theme.of(context).colorScheme.onSurface,
        leadingIconsColor: Theme.of(context).colorScheme.primary,
      ),
      applicationType: ApplicationType.cupertino,
      sections: [
        SettingsSection(
          title: Text('Cache'),
          tiles: [
            SettingsTile(
              title: Text('Clear Cache'),
              leading: Icon(CupertinoIcons.trash),
              onPressed: (BuildContext context) {
                getIt<CacheRepository>().clearDocumentCache();
              },
            ),
          ],
        ),
      ],
    );
  }
}
