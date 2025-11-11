import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/settings_theme.dart';
import 'package:tiny/theme/theme.dart';
import 'package:tiny/utils/utils.dart';

class ChatSettingsWindow extends StatefulWidget {
  const ChatSettingsWindow({super.key});

  @override
  State<ChatSettingsWindow> createState() =>
      _ChatSettingsWindowState();
}

class _ChatSettingsWindowState extends State<ChatSettingsWindow> {
  late Chat _chat;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _chat = context.read<ChatCubit>().state;
    setState(() {});
  }

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
                'General',
                style: context.theme().textTheme.titleMedium,
              ),
              tiles: [
                CyberpunkSettingsTile(
                  title: 'Chat Avatar',
                  leading: TinyAvatar(chat: _chat),
                  onToggle: () async {},
                ),
              ],
            ),
            SettingsSection(
              title: Text(
                'RAG Settings',
                style: context.theme().textTheme.titleMedium,
              ),
              tiles: [
                CyberpunkSettingsToggle(
                  title: 'Enable RAG',
                  initialValue: _chat.settings.isRagEnabled,
                  leadingIcon: const Icon(Icons.toggle_on),
                  onTap: (bool value) async {
                    _chat = _chat.copyWith(
                      settings: _chat.settings.copyWith(
                        isRagEnabled: value,
                      ),
                    );
                    await context
                        .read<ChatCubit>()
                        .updateChatSettings(_chat.settings);
                  },
                ),
                CyberpunkSettingsTile(
                  title: 'Context Documents',
                  leading: const Icon(Icons.dock),
                  onToggle: () async {
                    showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: context
                          .theme()
                          .scaffoldBackgroundColor,
                      builder: (context) => CyberpunkDocSelector(
                        chatId: _chat.id,
                        rag: _chat.rag,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
