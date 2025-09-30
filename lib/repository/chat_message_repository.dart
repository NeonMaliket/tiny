import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/utils/utils.dart';

class ChatMessageRepository {
  Stream<MessageChunk> sendMessage(int chatId, String prompt) async* {
    final client = Supabase.instance.client;

    final response = await client.functions.invoke(
      'groq',
      body: {'chatId': chatId, 'prompt': prompt},
    );

    final byteStream = response.data as Stream<List<int>>;
    final utf8Stream = byteStream
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in utf8Stream) {
      if (!line.startsWith("data:")) continue;

      final payload = line.substring(5).trim();
      if (payload == '[DONE]') {
        yield MessageChunk.last();
        break;
      }

      final chunk = MessageChunk.fromSupabase(payload);
      if (chunk.chunk.isNotEmpty) {
        yield chunk;
      }
    }
  }

  Stream<ChatMessage> subscribeToChat(int chatId) {
    final client = Supabase.instance.client;
    final controller = StreamController<ChatMessage>();

    () async {
      final history = await client
          .from('chat_messages')
          .select()
          .eq('chat_id', chatId)
          .order('created_at', ascending: true);

      for (final row in history) {
        controller.add(ChatMessage.fromMap(row));
      }

      client
          .channel('public:chat_messages')
          .onPostgresChanges(
            event: PostgresChangeEvent.insert,
            schema: 'public',
            table: 'chat_messages',
            callback: (payload) {
              var msg = ChatMessage.fromMap(payload.newRecord);
              msg = msg.copyWith(
                createdAt: DateTimeHelper.toLocalDateTime(msg.createdAt),
              );
              controller.add(msg);
            },
          )
          .subscribe();
    }();

    return controller.stream;
  }
}
