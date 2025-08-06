import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/domain/chat.dart';
import 'package:tiny/theme/theme.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<ChatBloc>().add(LoadChatListEvent());

    //TODO: for testing
    Future.delayed(Duration(seconds: 1), () {
      scaffoldKey.currentState?.openDrawer();
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Tiny'),
        leading: InkWell(
          child: Icon(Icons.menu, color: context.theme().colorScheme.secondary),
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
              contentPadding: EdgeInsets.symmetric(vertical: 50),
              sections: [ChatList(), NewChatSection()],
            ),
          ),
        ],
      ),
    );
  }
}

class NewChatSection extends AbstractSettingsSection {
  const NewChatSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsSection(
      title: Text('Actions'),
      tiles: [
        SettingsTile(
          leading: Icon(Icons.create, color: context.theme().primaryColor),
          title: Text('New Chat'),
        ),
      ],
    );
  }
}

class ChatList extends AbstractSettingsSection {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          current is ChatListLoading ||
          current is ChatListLoaded ||
          current is ChatListError,
      builder: (context, state) {
        if (state is ChatListLoading) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: LinearProgressIndicator(),
          );
        } else if (state is ChatListLoaded) {
          final chats = state.chats
              .map((chat) => ChatListItem(chat: chat))
              .toList();
          return SettingsSection(
            title: Text('Chat List'),
            tiles: chats.isNotEmpty
                ? chats
                : [
                    SettingsTile(
                      title: Text('No chats available'),
                      leading: Icon(
                        Icons.chat_bubble_outline,
                        color: context.theme().colorScheme.onSurface,
                      ),
                    ),
                  ],
          );
        } else if (state is ChatListError) {
          return SettingsSection(
            title: Text('Error'),
            tiles: [
              SettingsTile(
                title: Text(state.error),
                leading: Icon(
                  Icons.error,
                  color: context.theme().colorScheme.error,
                ),
              ),
            ],
          );
        }
        return Container(); // Fallback for other states
      },
    );
  }
}

class ChatListItem extends AbstractSettingsTile {
  const ChatListItem({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatDeleted && state.chatId == chat.id) {
          return SizedBox.shrink();
        }
        return SettingsTile(
          leading: Icon(
            Icons.chat,
            color: context.theme().colorScheme.secondary,
          ),
          title: Text(chat.title),
          trailing: IconButton(
            onPressed: () {
              context.read<ChatBloc>().add(DeleteChatEvent(chatId: chat.id));
            },
            icon: state is ChatDeleting && state.chatId == chat.id
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(Icons.delete, color: context.theme().colorScheme.error),
          ),
        );
      },
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
