import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/utils/utils.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<SimpleChat> chats = [];

  @override
  void initState() {
    context.read<ChatBloc>().stream.listen((state) {
      if (state is ChatListItemReceived) {
        setState(() {
          final streamEvent = state.event;
          switch (streamEvent.event) {
            case StreamEventType.history:
            case StreamEventType.newInstance:
              if (streamEvent.data != null) {
                final chat = SimpleChat.fromJson(streamEvent.data!);
                chats.add(chat);
              }
              break;
            case StreamEventType.delete:
              if (streamEvent.data != null) {
                final chatId = EntityBase.fromJson(streamEvent.data!).id;
                chats.removeWhere((chat) => chat.id == chatId);
              }
              break;
            default:
              break;
          }
          setState(() {});
        });
      }
    });
    super.initState();
  }

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
              context.read<ChatBloc>().add(DeleteChatEvent(chatId: chat.id));
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
