import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/repository/repository.dart';
import 'package:tiny/theme/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cyberpunkAlertBloc = context.read<CyberpunkAlertBloc>();
    return SettingsList(
      darkTheme: SettingsThemeData(
        settingsListBackground: Colors.transparent,
        titleTextColor: Theme.of(context).colorScheme.onSurface,
        leadingIconsColor: Theme.of(context).colorScheme.secondary,
        settingsSectionBackground: Theme.of(context).cardColor,
      ),
      applicationType: ApplicationType.cupertino,
      sections: [
        SettingsSection(
          title: Text('Cache', style: context.theme().textTheme.titleMedium),
          tiles: [
            CustomSettingsTile(
              child: ListTile(
                title: Text(
                  'Clear Cache',
                  style: context.theme().textTheme.titleSmall,
                ),
                shape: cyberpunkShape(
                  cyberpunkBorderSide(
                    context,
                    context.theme().colorScheme.secondary,
                  ).copyWith(width: 0.5),
                ),
                leading: Icon(CupertinoIcons.trash),
                onTap: () async {
                  await getIt<CacheRepository>().clearDocumentCache();
                  cyberpunkAlertBloc.add(
                    ShowCyberpunkAlertEvent(
                      type: CyberpunkAlertType.success,
                      title: 'Cache Cleared',
                      message:
                          'The document cache has been cleared successfully.',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
