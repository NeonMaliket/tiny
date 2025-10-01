import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/theme/settings_theme.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart';

class ChatSettingsWindow extends StatelessWidget {
  const ChatSettingsWindow({super.key, required this.chatId});

  final int chatId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: BlocBuilder<ChatSettingsBloc, ChatSettingsState>(
        builder: (context, state) {
          if (state is ChatSettingsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ChatSettingsLoaded) {
            print('STATE: ${state.settings.isRagEnabled}');

            return CyberpunkBackground(
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
                        initialValue: state.settings.isRagEnabled,
                        leadingIcon: const Icon(Icons.toggle_on),
                        onTap: (bool value) async {
                          final newSettings = state.settings.copyWith(
                            isRagEnabled: !state.settings.isRagEnabled,
                          );
                          print('NEW SETTINGS: $newSettings');
                          context.read<ChatSettingsBloc>().add(
                            UpdateChatSettings(
                              chatId: chatId,
                              settings: newSettings,
                            ),
                          );
                        },
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
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}
