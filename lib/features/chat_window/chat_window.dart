import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_settings_ui/flutter_settings_ui.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

class ChatWindow extends StatelessWidget {
  const ChatWindow({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    context.read<ChatBloc>().add(LoadLastChatEvent());
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
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
            current is LastChatLoading ||
            current is LastChatLoaded ||
            current is LastChatNotFound ||
            current is LastChatLoadingError,
        builder: (context, state) {
          if (state is LastChatLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is LastChatLoaded) {
            final chat = state.chat;
            return ActiveChat(chat: chat);
          } else if (state is LastChatNotFound) {
            return Center(child: Text('You have no active chats'));
          } else if (state is LastChatLoadingError) {
            return Center(child: Text('Error loading chats: ${state.error}'));
          }
          return Center(child: Text('You have no active chats'));
        },
      ),
      drawer: ChatDrawer(),
    );
  }
}

class ActiveChat extends StatelessWidget {
  const ActiveChat({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 8, child: Center(child: Text('Empty chat'))),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 40),
          child: UserPromptInput(
            onSend: (String userMessage) {
              context.read<ChatBloc>().add(
                SendPromptEvent(chatId: chat.id, prompt: userMessage),
              );
            },
          ),
        ),
      ],
    );
  }
}

class ChatDrawer extends StatefulWidget {
  const ChatDrawer({super.key});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  late final List<SimpleChat> _chats;

  @override
  void initState() {
    super.initState();
    _chats = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ChatBloc>().add(LoadChatListEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatBloc, ChatState>(
      listener: (context, state) {
        print('ChatBloc state changed: $state');
        if (state is SimpleChatListLoaded) {
          setState(() {
            _chats.addAll(state.chats);
          });
        }
      },
      child: Drawer(
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
                sections: [
                  ChatList(chats: _chats),
                  NewChatSection(),
                ],
              ),
            ),
          ],
        ),
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
          onPressed: (context) {
            showDialog(
              context: context,
              builder: (context) {
                return NewChatAlertDialog();
              },
            );
          },
        ),
      ],
    );
  }
}

class NewChatAlertDialog extends StatefulWidget {
  const NewChatAlertDialog({super.key});

  @override
  State<NewChatAlertDialog> createState() => _NewChatAlertDialogState();
}

class _NewChatAlertDialogState extends State<NewChatAlertDialog> {
  late final TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: TextField(
        controller: _titleController,
        decoration: InputDecoration(labelText: 'Chat Title'),
        onSubmitted: (title) {
          context.read<ChatBloc>().add(NewChatEvent(title: title));
          Navigator.of(context).pop();
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            context.read<ChatBloc>().add(
              NewChatEvent(title: _titleController.text),
            );
            Navigator.of(context).pop();
          },
          child: Text('Create'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Cancel',
            style: TextStyle(color: context.theme().colorScheme.error),
          ),
        ),
      ],
    );
  }
}

class ChatList extends AbstractSettingsSection {
  const ChatList({super.key, required this.chats});
  final List<SimpleChat> chats;
  @override
  Widget build(BuildContext context) {
    final mapped = chats.map((chat) => ChatListItem(chat: chat)).toList();
    return SettingsSection(
      title: Text('Chat List'),
      tiles: mapped.isNotEmpty
          ? mapped
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
  }
}

class ChatListItem extends AbstractSettingsTile {
  const ChatListItem({super.key, required this.chat});

  final SimpleChat chat;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      buildWhen: (previous, current) =>
          current is ChatDeleting ||
          current is ChatDeleted ||
          current is ChatDeleteError,
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
          onPressed: (context) {
            context.read<ChatBloc>().add(LoadChatEvent(chatId: chat.id));
          },
        );
      },
    );
  }
}

class UserPromptInput extends StatefulWidget {
  const UserPromptInput({super.key, required this.onSend});

  final Function(String userMessage) onSend;

  @override
  State<UserPromptInput> createState() => _UserPromptInputState();
}

class _UserPromptInputState extends State<UserPromptInput> {
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
