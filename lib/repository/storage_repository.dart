import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tiny/domain/storage_object.dart';

const cacheExpiraton = 3600;

class StorageRepository {
  final String storageBucket = 'storage';
  final SupabaseClient _supabaseClient = Supabase.instance.client;
  final CacheManager _cacheManager;

  StorageRepository({required cacheManager})
    : _cacheManager = cacheManager;

  Future<File> downloadBucketFile(final String path) async {
    final fromCache = await _cacheManager.getFileFromCache(path);
    if (fromCache != null) {
      return fromCache.file;
    }
    final tempUrl = await _supabaseClient.storage
        .from(storageBucket)
        .createSignedUrl(path, cacheExpiraton);
    final file = await _cacheManager.getSingleFile(
      tempUrl,
      key: path,
    );
    return file;
  }

  Future<File> downloadUserStorageFile(final String path) async {
    final fromCache = await _cacheManager.getFileFromCache(path);
    if (fromCache != null) {
      return fromCache.file;
    }
    final tempUrl = await _supabaseClient.storage
        .from(storageBucket)
        .createSignedUrl(path, cacheExpiraton);
    final file = await _cacheManager.getSingleFile(
      tempUrl,
      key: path,
    );
    return file;
  }

  Future<List<StorageObject>> loadUserStorage() async {
    final path = _userId;
    final result = await _supabaseClient.storage
        .from(storageBucket)
        .list(path: path);

    final ids = result
        .where((element) => element.metadata != null)
        .map((e) => e.id)
        .toList();

    if (ids.isEmpty) return [];

    final documents = await _supabaseClient
        .from('v_storage_objects')
        .select()
        .inFilter('id', ids);

    return (documents as List)
        .map((e) => StorageObject.fromMap(e))
        .toList();
  }

  Future<void> deleteStorageFile(final String path) async {
    await _supabaseClient.storage.from(storageBucket).remove([path]);
  }

  Future<String> uploadStorageFile(final File file) async {
    return await uploadFile(
      '$_userId/${_fileName(file)}',
      file,
      vectorize: true,
    );
  }

  Future<String> uploadChatAvatar(
    final int chatId,
    final File file, {
    String? oldFilePath,
  }) async {
    if (oldFilePath != null) {
      await deleteChatAvatar(chatId, oldFilePath);
    }
    return await uploadFile(
      '$_userId/chats/$chatId/${_fileName(file)}',
      file,
    );
  }

  Future<void> deleteChatAvatar(
    final int chatId,
    final String filePath,
  ) async {
    await _supabaseClient.storage.from(storageBucket).remove([
      filePath,
    ]);
  }

  Future<String> uploadFile(
    final String path,
    final File file, {
    bool vectorize = false,
  }) async {
    final response = await _supabaseClient.storage
        .from(storageBucket)
        .upload(
          path,
          file,
          fileOptions: FileOptions(
            cacheControl: '3600',
            upsert: true,
          ),
        )
        .then((value) => value);
    if (vectorize) {
      await _supabaseClient.functions.invoke(
        'vectorize',
        body: {'path': path, 'bucket': storageBucket},
      );
    }
    return response;
  }

  Future<String> objectIdFromPath(final String path) async {
    final withoutStorage = path.replaceFirst('$storageBucket/', '');
    final metadata = await _supabaseClient.storage
        .from(storageBucket)
        .info(withoutStorage);
    return metadata.id;
  }

  String _fileName(File file) {
    return file.path.split('/').last;
  }

  String get _userId => Supabase.instance.client.auth.currentUser!.id;
}
