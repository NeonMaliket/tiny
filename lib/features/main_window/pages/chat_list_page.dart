import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/theme/theme.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key, required this.chats});

  final List<Chat> chats;

  @override
  Widget build(BuildContext context) {
    chats.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top * 0.05),
      child: CyberpunkRefresh(
        onRefresh: () async {
          context.read<ChatBloc>().add(LoadChatListEvent());
        },
        child: CustomScrollView(
          slivers: [
            BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (chats.isEmpty) {
                  return BoxMessageSliver(message: 'No chats available');
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: chats.length,
                    (context, index) => ChatListItem(chat: chats[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({super.key, required this.chat});

  final Chat chat;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(chat.id.toString()),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) {
              context.read<CyberpunkAlertBloc>().add(
                ShowCyberpunkAlertEvent(
                  type: CyberpunkAlertType.info,
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
            backgroundColor: context.theme().colorScheme.errorContainer,
            foregroundColor: context.theme().colorScheme.onErrorContainer,
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
