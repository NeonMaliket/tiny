import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/document_metadata.dart';

class CacheRepository {
  Future<String> cacheDocument(
    DocumentMetadata metadata,
    Uint8List bytes, {
    String? subfolder,
  }) async {
    try {
      final baseFolder = await _basePath(subfolder: subfolder);
      final dir = Directory(baseFolder);
      dir.createSync(recursive: true);
      final file = File(
        '$baseFolder/${metadata.id}.${metadata.type}',
      );
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (e) {
      logger.e('Error caching document: $e');
      rethrow;
    }
  }

  Future<String?> getCachedDocument(
    DocumentMetadata metadata, {
    String? subfolder,
  }) async {
    logger.i('Checking cache for document with id: ${metadata.id}');
    final cachedFiles = await listCachedDocuments();
    for (final filePath in cachedFiles) {
      logger.e('Cached file: $filePath');
    }
    final baseFolder = await _basePath(subfolder: subfolder);
    final file = File('$baseFolder/${metadata.id}.${metadata.type}');
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  Future<List<String>> listCachedDocuments() async {
    final dir = await getTemporaryDirectory();
    if (await dir.exists()) {
      final files = dir.listSync();
      return files.map((file) => file.path).toList();
    }
    return [];
  }

  Future<void> deleteChachedFolder(String folder) async {
    final dir = await getTemporaryDirectory();
    final targetDir = Directory('${dir.path}/$folder');
    if (await targetDir.exists()) {
      await targetDir.delete(recursive: true);
      logger.i('Deleted cached folder: ${targetDir.path}');
    } else {
      logger.i('No cached folder found to delete for: $folder');
    }
    return Future.value();
  }

  Future<void> deleteCachedDocument(DocumentMetadata metadata) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${metadata.id}.${metadata.type}');
    if (await file.exists()) {
      await file.delete();
      logger.i('Deleted cached document: ${file.path}');
    } else {
      logger.i(
        'No cached document found to delete for id: ${metadata.id}',
      );
    }
    return Future.value();
  }

  Future<void> clearDocumentCache() async {
    final dir = await getTemporaryDirectory();
    if (await dir.exists()) {
      final files = dir.listSync();
      for (final file in files) {
        await file.delete(recursive: true);
      }
    }
    logger.i('Document cache cleared');
    return Future.value();
  }

  Future<String> _basePath({String? subfolder}) async {
    final dir = await getTemporaryDirectory();
    return subfolder != null ? '${dir.path}/$subfolder' : dir.path;
  }
}
