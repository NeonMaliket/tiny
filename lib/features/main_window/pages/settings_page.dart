import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/cyberpunk/cyberpunk.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/repository/repository.dart';
import 'package:tiny/theme/settings_theme.dart';
import 'package:tiny/theme/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cyberpunkAlertBloc = context.read<CyberpunkAlertBloc>();
    return SettingsList(
      darkTheme: settingsThemeData(context),
      applicationType: ApplicationType.cupertino,
      sections: [
        SettingsSection(
          title: Text(
            'Cache',
            style: context.theme().textTheme.titleMedium,
          ),
          tiles: [
            SettingsItem(
              title: 'Clear Cache',
              leading: Icon(CupertinoIcons.trash),
              onTap: () async {
                await getIt<CacheRepository>().clearDocumentCache();
                if (context.mounted) {
                  cyberpunkAlertBloc.add(
                    ShowCyberpunkAlertEvent(
                      type: CyberpunkAlertType.success,
                      title: 'Cache Cleared',
                      message:
                          'The document cache has been cleared successfully.',
                    ),
                  );
                }
              },
            ),
          ],
        ),
        SettingsSection(
          title: Text(
            'Account',
            style: context.theme().textTheme.titleMedium,
          ),
          tiles: [
            SettingsItem(
              title: 'Logout',
              leading: Icon(
                CupertinoIcons.person_crop_circle_badge_xmark,
              ),
              onTap: () async {
                await getIt<CacheRepository>().clearDocumentCache();
                await Supabase.instance.client.auth.signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

class SettingsItem extends AbstractSettingsTile {
  const SettingsItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.leading,
  });

  final Widget? leading;
  final String title;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return CustomSettingsTile(
      child: ListTile(
        title: Text(
          title,
          style: context.theme().textTheme.titleSmall,
        ),
        shape: cyberpunkShape(
          cyberpunkBorderSide(
            context,
            color: context.theme().colorScheme.secondary,
          ).copyWith(width: 0.5),
        ),
        leading: leading,
        onTap: onTap,
      ),
    );
  }
}
