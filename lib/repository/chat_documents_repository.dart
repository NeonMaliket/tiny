import 'package:supabase_flutter/supabase_flutter.dart';

class ChatDocumentsRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<void> addDocumentToChat(
    final int chatId,
    final int documentId,
  ) async {
    await _client.from('chat_documents').insert({
      'chat_id': chatId,
      'metadata_id': documentId,
    });
  }

  Future<void> removeDocumentFromChat(
    final int chatId,
    final int documentId,
  ) async {
    await _client
        .from('chat_documents')
        .delete()
        .eq('chat_id', chatId)
        .eq('metadata_id', documentId);
  }
}
