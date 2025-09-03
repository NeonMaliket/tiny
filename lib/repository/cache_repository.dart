import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/document_metadata.dart';

class CacheRepository {
  Future<String> cacheDocument(
    DocumentMetadata metadata,
    Uint8List bytes,
  ) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${metadata.id}.${metadata.type}');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  Future<String?> getCachedDocument(DocumentMetadata metadata) async {
    logger.i('Checking cache for document with id: ${metadata.id}');
    final cachedFiles = await listCachedDocuments();
    for (final filePath in cachedFiles) {
      logger.e('Cached file: $filePath');
    }
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${metadata.id}.${metadata.type}');
    if (await file.exists()) {
      return file.path;
    }
    return null;
  }

  Future<List<String>> listCachedDocuments() async {
    final dir = await getTemporaryDirectory();
    if (await dir.exists()) {
      final files = dir.listSync();
      return files.whereType<File>().map((file) => file.path).toList();
    }
    return [];
  }

  Future<void> deleteCachedDocument(DocumentMetadata metadata) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${metadata.id}.${metadata.type}');
    if (await file.exists()) {
      await file.delete();
      logger.i('Deleted cached document: ${file.path}');
    } else {
      logger.i('No cached document found to delete for id: ${metadata.id}');
    }
    return Future.value();
  }

  Future<void> clearDocumentCache() async {
    final dir = await getTemporaryDirectory();
    if (await dir.exists()) {
      final files = dir.listSync();
      for (final file in files) {
        if (file is File) {
          await file.delete();
        }
      }
    }
    logger.i('Document cache cleared');
    return Future.value();
  }
}
