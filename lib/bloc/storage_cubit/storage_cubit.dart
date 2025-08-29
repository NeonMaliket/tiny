import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:eventsource/eventsource.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';

part 'storage_state.dart';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit() : super(StorageInitial());

  Future<void> uploadDocumentEvent({
    required String filename,
    required File file,
  }) async {
    logger.i('Uploading file');
    emit(DocumentUploading());
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: filename),
      });
      await dio.post('/storage/upload/$filename', data: formData).then((
        response,
      ) {
        final metadata = DocumentMetadata.fromMap(response.data);
        logger.i('Metadata loaded: $metadata');
        emit(DocumentUploaded(metadata));
      });
    } catch (e) {
      logger.e('Document uploading error: ', error: e);
      emit(DocumentUploadingError(e.toString()));
    }
  }

  Stream<DocumentMetadata> loadStorage() async* {
    emit(StorageLoading());
    try {
      final eventSource = await EventSource.connect('$baseUrl/storage');
      eventSource.listen(
        null,
        onError: (dynamic error) {
          logger.e('Stream Events Error', error: error);
        },
        onDone: () {
          logger.i('Connection closed.');
        },
      );

      await for (final event in eventSource.asBroadcastStream()) {
        if (event.data != null) {
          final metadata = DocumentMetadata.fromJson(event.data!);
          yield metadata;
        }
      }
      emit(StorageLoaded());
    } catch (e) {
      logger.e('Storage loading error: ', error: e);
      emit(StorageLoadingError(e.toString()));
    }
  }
}
