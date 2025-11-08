import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class ChatDocumentsRepository {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<DocumentMetadata>> loadRagDocuments(
    final int chatId,
  ) async {
    final response = await _client
        .from('chat_documents')
        .select('document_metadata(*)')
        .eq('chat_id', chatId);
    return (response as List)
        .map((e) => DocumentMetadata.fromMap(e['document_metadata']))
        .toList();
  }

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
