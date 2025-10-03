import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

class ChatStorageRepository {
  ChatStorageRepository({
    required CacheRepository cacheRepository,
    required DocumentMetadataRepository documentMetadataRepository,
  }) : _cacheRepository = cacheRepository,
       _documentMetadataRepository = documentMetadataRepository;
  final String storagePath = 'chat_storage';
  final CacheRepository _cacheRepository;
  final DocumentMetadataRepository _documentMetadataRepository;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<DocumentMetadata> uploadChatFile({
    required int chatId,
    required String filename,
    required File file,
  }) async {
    final storage = _supabaseClient.storage;
    final metadata = await _documentMetadataRepository.save(
      filename,
      storagePath,
    );
    final objectPath = _getObjectPath(chatId, filename);

    await storage
        .from(storagePath)
        .upload(
          objectPath,
          file,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );
    await _cacheRepository.cacheDocument(
      metadata,
      file.readAsBytesSync(),
    );
    return metadata;
  }

  String _getObjectPath(final int chatId, final String filename) {
    return '$chatId/$filename';
  }
}
