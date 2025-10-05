import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
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
  late ChatSettings _settings;
  late int _chatId;
  DocumentMetadata? _avatarMetadata;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final chat = context.read<ChatCubit>().state;
    _chatId = chat.id;
    _settings = chat.settings;
    _avatarMetadata = chat.avatarMetadata;
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
                  leading: TinyAvatar(
                    chatId: _chatId,
                    metadata: _avatarMetadata,
                  ),
                  onToggle: () async {
                    final chatCubit = context.read<ChatCubit>();
                    final selected = await context
                        .read<DocumentCubit>()
                        .selectPicture();
                    if (selected != null) {
                      final metadata = await chatCubit.updateAvatar(
                        selected,
                      );
                      if (metadata != null) {
                        _avatarMetadata = metadata;
                      }
                    }
                    setState(() {});
                  },
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
                  initialValue: _settings.isRagEnabled,
                  leadingIcon: const Icon(Icons.toggle_on),
                  onTap: (bool value) async {
                    _settings = _settings.copyWith(
                      isRagEnabled: value,
                    );
                    await context
                        .read<ChatCubit>()
                        .updateChatSettings(_settings);
                  },
                ),
                CyberpunkSettingsTile(
                  title: 'Context Documents',
                  leading: const Icon(Icons.dock),
                  onToggle: () async {
                    showMaterialModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => CyberpunkMenu(
                        onSelect: (List<DocumentMetadata> documents) {
                          logger.i('Selected documents: $documents');
                        },
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
