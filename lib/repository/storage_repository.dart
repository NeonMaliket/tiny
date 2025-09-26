import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/document_metadata.dart';
import 'package:tiny/repository/repository.dart';

class StorageRepository {
  final String storageBucket = 'storage';
  final CacheRepository _cacheRepository;
  final DocumentMetadataRepository _documentMetadataRepository;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  StorageRepository({
    required CacheRepository cacheRepository,
    required DocumentMetadataRepository documentMetadataRepository,
  }) : _cacheRepository = cacheRepository,
       _documentMetadataRepository = documentMetadataRepository;

  Future<DocumentMetadata> uploadDocumentEvent({
    required String filename,
    required File file,
  }) async {
    final metadata = await _documentMetadataRepository.save(
      filename,
      storageBucket,
    );
    await _supabaseClient.storage
        .from(storageBucket)
        .upload(
          metadata.id.toString(),
          file,
          fileOptions: FileOptions(cacheControl: '3600', upsert: false),
        );
    await _cacheRepository.cacheDocument(metadata, await file.readAsBytes());
    return metadata;
  }

  Future<String> downloadDocument(DocumentMetadata metadata) async {
    final cachedPath = await _cacheRepository.getCachedDocument(metadata);
    if (cachedPath != null) {
      return cachedPath;
    }
    final path = await _cacheRepository.cacheDocument(
      metadata,
      await _supabaseClient.storage
          .from(storageBucket)
          .download(metadata.id.toString()),
    );
    return path;
  }

  Future<void> deleteDocument(DocumentMetadata metadata) async {
    await Future.wait([
      _supabaseClient.storage.from(storageBucket).remove([
        metadata.id.toString(),
      ]),
      _cacheRepository.deleteCachedDocument(metadata),
      _documentMetadataRepository.deleteMetadata(metadata.id!),
    ]);
  }
}
