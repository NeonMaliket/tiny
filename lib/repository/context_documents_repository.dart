import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/storage_object.dart';

class ContextDocumentsRepository {
  final SupabaseClient supabaseClient = Supabase.instance.client;

  Future<List<StorageObject>> loadContextDocuments(
    final int chatId,
  ) async {
    final result = await supabaseClient
        .from('context_documents')
        .select("chat_id, document:v_storage_objects(*)")
        .eq('chat_id', chatId);
    return (result as List)
        .map((e) => StorageObject.fromMap(e["document"]))
        .toList();
  }

  Future<void> removeContextDocument(
    final int chatId,
    final String documentId,
  ) async {
    await supabaseClient
        .from('context_documents')
        .delete()
        .eq('chat_id', chatId)
        .eq('object_id', documentId);
  }

  Future<void> addContextDocument(
    final int chatId,
    final String documentId,
  ) async {
    await supabaseClient.from('context_documents').insert({
      'chat_id': chatId,
      'object_id': documentId,
    });
  }
}
