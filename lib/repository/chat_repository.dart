import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/config/get_it.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

class ChatRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Stream<SimpleChat> streamChats() async* {
    final response = _supabaseClient
        .from('chats')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false);
    await for (final rows in response) {
      for (final row in rows) {
        yield SimpleChat.fromMap(row);
      }
    }
  }

  Future<Chat> loadChat(int chatId) async {
    final messages = await getIt<ChatMessageRepository>().getChatMessages(
      chatId,
    );
    final simpleChat = await _supabaseClient
        .from('chats')
        .select()
        .eq('id', chatId)
        .single()
        .then((value) => SimpleChat.fromMap(value));
    return Chat(
      id: simpleChat.id,
      title: simpleChat.title,
      createdAt: simpleChat.createdAt,
      history: messages,
    );
  }

  Future<SimpleChat> createChat(String title) async {
    final response = await _supabaseClient
        .from('chats')
        .insert({
          'title': title,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select('id, title, created_at')
        .single();
    return SimpleChat(
      id: response['id'] as int,
      title: response['title'] as String,
      createdAt: DateTime.parse(response['created_at'] as String),
    );
  }

  Future<void> deleteChat(int id) async {
    await _supabaseClient.from('chats').delete().eq('id', id);
  }
}
