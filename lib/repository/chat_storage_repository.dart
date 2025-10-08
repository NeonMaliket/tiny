import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/config/app_config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

class ChatStorageRepository {
  ChatStorageRepository({
    required CacheRepository cacheRepository,
    required DocumentMetadataRepository documentMetadataRepository,
  }) : _cacheRepository = cacheRepository,
       _documentMetadataRepository = documentMetadataRepository;
  final String chatStorageBucket = 'chat_storage';
  final CacheRepository _cacheRepository;
  final DocumentMetadataRepository _documentMetadataRepository;
  final SupabaseClient _supabaseClient = Supabase.instance.client;

  Future<void> deleteAllChatFiles(int chatId) async {
    final storage = _supabaseClient.storage;
    try {
      await storage
          .from(chatStorageBucket)
          .remove(
            await storage
                .from(chatStorageBucket)
                .list(path: chatId.toString())
                .then(
                  (files) => files
                      .map(
                        (file) => '${chatId.toString()}/${file.name}',
                      )
                      .toList(),
                ),
          );
      await _cacheRepository.deleteChachedFolder(chatId.toString());
    } catch (e) {
      logger.e('Error deleting chat files for chatId $chatId: $e');
    }
  }

  Future<String> download(
    int chatId,
    DocumentMetadata metadata,
  ) async {
    final cachedPath = await _cacheRepository.getCachedDocument(
      metadata,
      subfolder: chatId.toString(),
    );
    if (cachedPath != null) {
      return cachedPath;
    }
    final objectPath = _getObjectPath(chatId, metadata.filename);
    final path = await _cacheRepository.cacheDocument(
      subfolder: chatId.toString(),
      metadata,
      await _supabaseClient.storage
          .from(chatStorageBucket)
          .download(objectPath),
    );
    return path;
  }

  Future<DocumentMetadata> uploadChatFile({
    required int chatId,
    required String filename,
    required File file,
  }) async {
    final storage = _supabaseClient.storage;
    final metadata = await _documentMetadataRepository.save(
      filename,
      chatStorageBucket,
    );
    final objectPath = _getObjectPath(chatId, filename);

    await storage
        .from(chatStorageBucket)
        .upload(
          objectPath,
          file,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        );
    await _cacheRepository.cacheDocument(
      subfolder: chatId.toString(),
      metadata,
      file.readAsBytesSync(),
    );
    return metadata;
  }

  String _getObjectPath(final int chatId, final String filename) {
    return '$chatId/$filename';
  }
}
