import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/document_metadata.dart';
import 'package:tiny/repository/repository.dart';

class StorageRepository {
  final CacheRepository _cacheRepository;

  StorageRepository({required CacheRepository cacheRepository})
    : _cacheRepository = cacheRepository;

  Future<DocumentMetadata> uploadDocumentEvent({
    required String filename,
    required File file,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path, filename: filename),
    });
    return await dio.post('/storage/upload/$filename', data: formData).then((
      data,
    ) {
      return DocumentMetadata.fromMap(data.data);
    });
  }

  Future<String> downloadDocument(DocumentMetadata metadata) async {
    final cachedData = await _cacheRepository.getCachedDocument(metadata);
    if (cachedData != null) {
      return cachedData;
    }

    final response = await dio.get<Uint8List>(
      '$baseUrl/storage/download/${metadata.id}/${metadata.filename}',
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) => status != null && status < 500,
      ),
    );
    final data = response.data;
    if (data != null) {
      final bytes = Uint8List.fromList(data);
      return await _cacheRepository.cacheDocument(metadata, bytes);
    }
    throw Exception('Failed to download document');
  }

  Future<void> deleteDocument(DocumentMetadata metadata) async {
    await dio.delete('$baseUrl/storage/${metadata.id}');
    await _cacheRepository.deleteCachedDocument(metadata);
    return Future.value();
  }
}
