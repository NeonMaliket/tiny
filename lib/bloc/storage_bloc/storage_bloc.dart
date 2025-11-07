import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:tiny/bloc/bloc.dart';
import 'package:tiny/components/components.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

part 'storage_event.dart';
part 'storage_state.dart';

class StorageBloc extends Bloc<StorageEvent, StorageState> {
  StorageBloc({
    required LoaderCubit loaderCubit,
    required StorageRepository storageRepository,
    required CyberpunkAlertBloc cyberpunkAlertBloc,
  }) : _loaderCubit = loaderCubit,
       _cyberpunkAlertBloc = cyberpunkAlertBloc,
       _storageRepository = storageRepository,
       super(StorageInitial()) {
    on<UploadDocumentEvent>(_uploadDocumentEvent);
    on<StreamStorageEvent>(_streamStorage);
    on<DownloadDocumentEvent>(_downloadDocument);
    on<DeleteDocumentEvent>(_deleteDocument);
  }
  final LoaderCubit _loaderCubit;
  final CyberpunkAlertBloc _cyberpunkAlertBloc;
  final StorageRepository _storageRepository;

  Future<void> _uploadDocumentEvent(
    UploadDocumentEvent event,
    Emitter<StorageState> emit,
  ) async {
    logger.i('Uploading file');
    emit(DocumentUploading(filename: event.filename));
    _loaderCubit.loading('Uploading document: ${event.filename}');
    try {
      final path = await _storageRepository.uploadDocumentEvent(
        filename: event.filename,
        file: event.file,
      );
      logger.i('Document loaded: $path');
      emit(DocumentUploaded(path));
      _loaderCubit.loadedSuccess(
        'Document uploaded: ${event.filename}',
      );
    } catch (e) {
      logger.e('Document uploading error: ', error: e);
      _loaderCubit.loadedFailure(
        'Failed to upload document: ${event.filename}',
      );
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to upload document',
        ),
      );
      emit(DocumentUploadingError(e.toString()));
    }
  }

  Future<void> _streamStorage(
    StreamStorageEvent event,
    Emitter<StorageState> emit,
  ) async {
    emit(StorageLoading());
    try {
      final docMetadataRepo = getIt<DocumentMetadataRepository>();

      for (final metadata in await docMetadataRepo.fetchMetadata(
        bucket: 'storage',
      )) {
        emit(StorageDocumentRecived(metadata));
      }
    } catch (e) {
      logger.e('Storage loading error: ', error: e);
      emit(StorageLoadingError(e.toString()));
      _cyberpunkAlertBloc.add(
        ShowCyberpunkAlertEvent(
          type: CyberpunkAlertType.error,
          title: 'Error',
          message: 'Failed to load storage',
        ),
      );
    }
  }

  Future<void> _downloadDocument(
    DownloadDocumentEvent event,
    Emitter<StorageState> emit,
  ) async {
    emit(StorageDocumentDownloading());
    try {
      final String path = await _storageRepository.downloadDocument(
        event.metadata,
      );
      emit(StorageDocumentDownloaded(path));
    } catch (e) {
      emit(StorageDocumentDownloadingError(e.toString()));
      logger.e('Storage document downloading error', error: e);
    }
  }

  Future<void> _deleteDocument(
    DeleteDocumentEvent event,
    Emitter<StorageState> emit,
  ) async {
    emit(StorageDocumentDeleting());
    try {
      await _storageRepository.deleteDocument(event.metadata);
      emit(StorageDocumentDeleted(event.metadata.id!));
    } catch (e) {
      emit(StorageDocumentDeletingError(e.toString()));
      logger.e('Storage document deleting error', error: e);
    }
  }
}
