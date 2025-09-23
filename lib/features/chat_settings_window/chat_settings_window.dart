import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/settings_theme.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart';

class ChatSettingsWindow extends StatelessWidget {
  const ChatSettingsWindow({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: CyberpunkBackground(
        child: SettingsList(
          darkTheme: settingsThemeData(context),
          sections: [
            SettingsSection(
              title: Text(
                'RAG Settings',
                style: context.theme().textTheme.titleMedium,
              ),
              tiles: [
                CyberpunkSettingsToggle(
                  title: 'Enable RAG',
                  leadingIcon: const Icon(Icons.toggle_on),
                  onTap: (val) async {},
                ),
                CyberpunkSettingsTile(
                  title: 'Context Documents',
                  leadingIcon: const Icon(Icons.dock),
                  onToggle: () async {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
