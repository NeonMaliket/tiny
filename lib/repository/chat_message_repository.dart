import 'dart:async';
import 'dart:convert';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/utils/utils.dart';

class ChatMessageRepository {
  final client = Supabase.instance.client;

  Stream<MessageChunk> sendMessage(
    int chatId,
    String prompt, {
    required String messageType,
  }) async* {
    final response = await client.functions.invoke(
      'groq',
      body: {
        'chatId': chatId,
        'content': prompt,
        'messageType': messageType,
      },
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
    client
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
    return controller.stream;
  }

  Stream<MessageChunk> sendVoiceMessage({
    required int chatId,
    required String voicePath,
  }) async* {
    yield* sendMessage(chatId, voicePath, messageType: 'VOICE');
  }
}
