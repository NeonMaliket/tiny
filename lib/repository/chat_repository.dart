import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class ChatRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final String selectFields = '''
       id,
       title,
       created_at,
       settings,
       avatar_object:v_storage_objects(*)!avatar_id,
  ''';

  Future<List<Chat>> chatList() async {
    final response = await _supabaseClient
        .from('chats')
        .select(selectFields)
        .order('created_at', ascending: false);
    return (response as List).map((e) => Chat.fromMap(e)).toList();
  }

  Future<Chat> createChat(String title) async {
    final response = await _supabaseClient
        .from('chats')
        .insert({
          'title': title,
          'settings': ChatSettings.defaultSettings().toMap(),
        })
        .select(selectFields)
        .single();
    return Chat.fromMap(response);
  }

  Future<void> deleteChat(int id) async {
    await _supabaseClient.from('chats').delete().eq('id', id);
  }

  Future<Chat> updateChatAvatar({
    required int chatId,
    required String avatarId,
  }) async {
    final response = await _supabaseClient
        .from('chats')
        .update({'avatar_id': avatarId})
        .eq('id', chatId)
        .select(selectFields)
        .single();
    return Chat.fromMap(response);
  }
}
