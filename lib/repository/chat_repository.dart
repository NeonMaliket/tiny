import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class ChatRepository {
  final SupabaseClient _supabaseClient =
      Supabase.instance.client;
      
   Future<List<SimpleChat>> chatList() async {
    final response = await _supabaseClient
        .from('chats')
        .select('id, title, created_at')
        .order('created_at', ascending: false);
    return (response as List)
        .map((e) => SimpleChat.fromMap(e))
        .toList();
  }

  Future<SimpleChat> createChat(String title) async {
    final response = await _supabaseClient
        .from('chats')
        .insert({'title': title})
        .select('id, title, created_at')
        .single();
    return SimpleChat.fromMap(response);
  }

  Future<void> deleteChat(int id) async {
    await _supabaseClient
        .from('chats')
        .delete()
        .eq('id', id);
  }
}
