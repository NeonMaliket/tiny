import 'package:flutter/material.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/theme/theme.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Tiny'),
        leading: InkWell(
          child: Icon(Icons.menu),
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(flex: 8, child: Center(child: Text('Empty chat'))),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 40),
            child: UserMessageInput(
              onSend: (String userMessage) {
                print(userMessage);
              },
            ),
          ),
        ],
      ),
      drawer: ChatDrawer(),
    );
  }
}

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: SettingsList(
              darkTheme: SettingsThemeData(
                settingsListBackground: Colors.transparent,
              ),
              shrinkWrap: true,
              sections: [
                SettingsSection(
                  title: Text('Chat List'),
                  tiles: [
                    SettingsTile(
                      leading: Icon(
                        Icons.chat,
                        color: context.theme().colorScheme.secondary,
                      ),
                      title: Text('Title'),
                      trailing: Icon(
                        Icons.delete_rounded,
                        color: context.theme().colorScheme.error,
                      ),
                    ),
                    SettingsTile(
                      leading: Icon(
                        Icons.chat,
                        color: context.theme().colorScheme.secondary,
                      ),
                      trailing: Icon(
                        Icons.delete_rounded,
                        color: context.theme().colorScheme.error,
                      ),
                      title: Text('Title1'),
                    ),
                    SettingsTile(
                      leading: Icon(
                        Icons.chat,
                        color: context.theme().colorScheme.secondary,
                      ),
                      trailing: Icon(
                        Icons.delete_rounded,
                        color: context.theme().colorScheme.error,
                      ),
                      title: Text('Title2'),
                    ),
                  ],
                ),
                SettingsSection(
                  title: Text('Actions'),
                  tiles: [
                    SettingsTile(
                      leading: Icon(
                        Icons.create,
                        color: context.theme().primaryColor,
                      ),
                      title: Text('New Chat'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserMessageInput extends StatefulWidget {
  const UserMessageInput({super.key, required this.onSend});

  final Function(String userMessage) onSend;

  @override
  State<UserMessageInput> createState() => _UserMessageInputState();
}

class _UserMessageInputState extends State<UserMessageInput> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      maxLines: 10,
      minLines: 1,
      decoration: InputDecoration(
        labelText: 'User Message',
        alignLabelWithHint: true,
        suffixIcon: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 10),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 21,
                  color: context.theme().colorScheme.secondary,
                ),
                onPressed: () {
                  widget.onSend(_textController.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
