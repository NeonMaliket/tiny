import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:eventsource/eventsource.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/storage_repository.dart';

part 'storage_state.dart';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit({required StorageRepository storageRepository})
    : _storageRepository = storageRepository,
      super(StorageInitial());

  final StorageRepository _storageRepository;

  Future<void> uploadDocumentEvent({
    required String filename,
    required File file,
  }) async {
    logger.i('Uploading file');
    emit(DocumentUploading());
    try {
      _storageRepository
          .uploadDocumentEvent(filename: filename, file: file)
          .then((metadata) {
            logger.i('Metadata loaded: $metadata');
            emit(DocumentUploaded(metadata));
          });
    } catch (e) {
      logger.e('Document uploading error: ', error: e);
      emit(DocumentUploadingError(e.toString()));
    }
  }

  Stream<Event> streamStorage() async* {
    emit(StorageLoading());
    try {
      final eventSource = await EventSource.connect('$baseUrl/storage');
      eventSource.listen(
        null,
        onError: (dynamic error) {
          logger.e('Stream Events Error', error: error);
        },
        onDone: () {
          emit(StorageLoaded());
          logger.i('Connection closed.');
        },
      );

      await for (final event in eventSource.asBroadcastStream()) {
        if (event.data != null) {
          yield event;
        }
      }
    } catch (e) {
      logger.e('Storage loading error: ', error: e);
      emit(StorageLoadingError(e.toString()));
    }
  }

  Future<void> downloadDocument(DocumentMetadata metadata) async {
    emit(StorageDocumentDownloading());
    try {
      final String path = await _storageRepository.downloadDocument(metadata);
      emit(StorageDocumentDownloaded(path));
      return Future.value();
    } catch (e) {
      emit(StorageDocumentDownloadingError(e.toString()));
      logger.e('Storage document downloading error', error: e);
      return Future.error(e);
    }
  }

  Future<void> deleteDocument(DocumentMetadata metadata) async {
    emit(StorageDocumentDeleting());
    try {
      await _storageRepository.deleteDocument(metadata);
      emit(StorageDocumentDeleted());
      return Future.value();
    } catch (e) {
      emit(StorageDocumentDeletingError(e.toString()));
      logger.e('Storage document deleting error', error: e);
      return Future.error(e);
    }
  }
}
