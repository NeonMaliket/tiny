import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/chat_message.dart';

class ChatMessageRepository {
  final SupabaseClient _client = Supabase.instance.client;

  ChatMessageRepository();

  Stream<ChatMessage> streamChatMessages(int chatId) async* {
    final response = _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('created_at', ascending: true);
    await for (final rows in response) {
      for (final row in rows) {
        print("Row: $row");
        yield ChatMessage.fromMap(row);
      }
    }
  }

  Future<List<ChatMessage>> getChatMessages(int chatId) async {
    final response = await _client
        .from('chat_messages')
        .select()
        .eq('chat_id', chatId);

    return (response as List)
        .map((e) => ChatMessage.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> sendMessage(ChatMessage message) async {
    await _client.from('chat_messages').insert({
      'content': message.content,
      'created_at': message.createdAt.toIso8601String(),
      'author': message.author.name,
      'chat_id': message.chatId,
    });
  }
}
