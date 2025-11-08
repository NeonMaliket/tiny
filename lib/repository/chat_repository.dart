import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class ChatRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<Chat>> chatList() async {
    final response = await _supabaseClient
        .from('chats')
        .select('''
               id,
               title,
               created_at,
               settings,
               avatar_metadata:document_metadata!avatar_metadata_id(*)
          ''')
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
        .select(
          'id, title, created_at, settings, avatar_metadata:document_metadata!avatar_metadata_id(*)',
        )
        .single();
    return Chat.fromMap(response);
  }

  Future<void> deleteChat(int id) async {
    await _supabaseClient.from('chats').delete().eq('id', id);
  }

  Future<void> updateChatAvatar({
    required int chatId,
    required DocumentMetadata avatarMetadata,
  }) async {
    await _supabaseClient
        .from('chats')
        .update({'avatar_metadata_id': avatarMetadata.id})
        .eq('id', chatId);
  }
}
