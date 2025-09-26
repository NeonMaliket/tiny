import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';

class DocumentMetadataRepository {
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<List<DocumentMetadata>> fetchAllMetadata() async {
    final response =
        await _supabaseClient
                .from('document_metadata')
                .select()
                .order('created_at', ascending: false)
            as List<dynamic>;
    return response
        .map((e) => DocumentMetadata.fromMap(e as Map<String, dynamic>))
        .toList();
  }

  Future<DocumentMetadata> save(String filename, String bucket) async {
    final response = await _supabaseClient
        .from('document_metadata')
        .insert({
          'bucket': bucket,
          'file_name': filename,
          'type': filename.split('.').last,
          'created_at': DateTime.now().toIso8601String(),
        })
        .select('id, file_name, type, created_at')
        .single();
    return DocumentMetadata(
      id: response['id'] as int,
      filename: response['file_name'] as String,
      type: response['type'] as String,
      createdAt: DateTime.parse(response['created_at'] as String),
    );
  }

  Future<void> deleteMetadata(int id) async {
    await _supabaseClient.from('document_metadata').delete().eq('id', id);
  }
}
