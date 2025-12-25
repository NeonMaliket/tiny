import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/utils/utils.dart';

class ChatMessageRepository {
  final client = Supabase.instance.client;

  Future<List<ChatMessage>> fetchChatHistory(int chatId) async {
    final history = await client
        .from('chat_messages')
        .select()
        .eq('chat_id', chatId)
        .order('created_at', ascending: true);

    return history
        .map<ChatMessage>((row) => ChatMessage.fromMap(row))
        .toList();
  }

  Stream<ChatMessage> subscribeToChat(int chatId) {
    final controller = StreamController<ChatMessage>();
    final channel = client
        .channel('public:chat_messages')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'chat_messages',
          callback: (payload) {
            var msg = ChatMessage.fromMap(payload.newRecord);
            msg = msg.copyWith(
              createdAt: DateTimeHelper.toLocalDateTime(
                msg.createdAt,
              ),
            );
            controller.add(msg);
          },
        )
        .subscribe();

    controller.onCancel = () {
      channel.unsubscribe();
      controller.close();
    };

    return controller.stream;
  }
}
