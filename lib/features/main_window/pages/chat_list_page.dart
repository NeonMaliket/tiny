import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
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
                  return Slidable(
                    key: Key(chat.id),
                    endActionPane: ActionPane(
                      motion: const ScrollMotion(),
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            context.read<ChatBloc>().add(
                              DeleteChatEvent(chatId: chat.id),
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
                }, childCount: chats.length),
              ),
            ],
          );
        }
        return Center(child: Text('No chats available'));
      },
    );
  }
}
