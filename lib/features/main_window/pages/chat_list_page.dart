import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/domain.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key, required this.chats});

  final List<SimpleChat> chats;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is ChatListError) {
          return Center(child: Text('Error loading chats'));
        } else if (chats.isEmpty) {
          return Center(child: Text('No chats available'));
        }
        return CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                childCount: chats.length,
                (context, index) => ChatListItem(chat: chats[index]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.chat});

  final SimpleChat chat;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(chat.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              context.read<AlertBloc>().add(
                ShowAlertEvent(
                  title: 'Delete Chat',
                  message:
                      'Are you sure you want to delete the chat "${chat.title}"?',
                  onConfirm: (context) {
                    context.read<ChatBloc>().add(
                      DeleteChatEvent(chatId: chat.id),
                    );
                  },
                ),
              );
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        leading: TinyAvatar(
          imageUrl:
              "https://img.freepik.com/premium-photo/ai-image-generator_707898-82.jpg",
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
          context.push('/chat/${chat.id}');
        },
      ),
    );
  }
}
