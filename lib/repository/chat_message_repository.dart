import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class ChatMessageRepository {
  Stream<MessageChunk> sendMessage(String chatId, String prompt) async* {
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

  Stream<ChatMessage> subscribeToChat(String chatId) async* {
    final client = Supabase.instance.client;
    final stream = client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId);

    await for (final events in stream) {
      for (final row in events) {
        yield ChatMessage.fromMap(row);
      }
    }
  }
}
