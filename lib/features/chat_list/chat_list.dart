import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:tiny/bloc/bloc.dart';

class ChatListWindow extends StatefulWidget {
  const ChatListWindow({super.key});

  @override
  State<ChatListWindow> createState() => _ChatListWindowState();
}

class _ChatListWindowState extends State<ChatListWindow> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<ChatBloc>().add(LoadChatListEvent());
  }

  @override
  Widget build(BuildContext context) {
    final avatarImageUrl =
        'https://www.htx.gov.sg/images/default-source/news/2024/ai-article-1-banner-shot-min.jpg?sfvrsn=4b7c6915_3';
    return Scaffold(
      appBar: AppBar(title: Text('Tiny')),
      body: BlocBuilder<ChatBloc, ChatState>(
        buildWhen: (previous, current) =>
            current is SimpleChatListLoaded ||
            current is ChatListLoading ||
            current is ChatListError,
        builder: (context, state) {
          if (state is ChatListLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ChatListError) {
            return Center(child: Text('Error loading chats'));
          }
          if (state is SimpleChatListLoaded) {
            final chats = state.chats;
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final chat = chats[index];
                    return Dismissible(
                      key: Key(chat.id),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Chat "${chat.title}" deleted'),
                          ),
                        );
                        // context.read<ChatBloc>().add(DeleteChatEvent(chatId: chat.id));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(avatarImageUrl),
                        ),
                        trailing: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              DateFormat('dd-MM-yyyy').format(chat.createdAt),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              DateFormat('HH:mm').format(chat.createdAt),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        title: Text(chat.title),
                        onTap: () {
                          context.go('/chat/${chat.id}');
                        },
                      ),
                    );
                  }, childCount: chats.length),
                ),
              ],
            );
          }
          return Center(child: Text('No chats available'));
        },
      ),
    );
  }
}
