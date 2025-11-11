import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/repository/repository.dart';

part 'storage_state.dart';

const errorMessage =
    'An unexpected error occurred. Please try again later.';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit(this._storageRepository) : super(StorageInitial());

  final StorageRepository _storageRepository;

  Future<List<String>> storageListFiles() async {
    emit(GlobalStorageHandling());
    try {
      final fileList = await _storageRepository.loadUserStorage();
      emit(StorageListSuccess(files: fileList));
      return fileList;
    } catch (e) {
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }

  Future<String> uploadStorageFile(final File file) async {
    emit(GlobalStorageHandling());
    try {
      final uploadedFileName = await _storageRepository
          .uploadStorageFile(file);
      emit(StorageUploadSuccess(fileName: uploadedFileName));
      return uploadedFileName;
    } catch (e) {
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }

  Future<void> deleteStorageFile(final String filename) async {
    emit(GlobalStorageHandling());
    try {
      await _storageRepository.deleteStorageFile(filename);
      emit(StorageDeleteSuccess(fileName: filename));
    } catch (e) {
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }

  Future<File> downloadStorageFile(final String filename) async {
    emit(GlobalStorageHandling());
    try {
      final file = await _storageRepository.downloadStorageFile(
        filename,
      );
      emit(StorageDownloadSuccess(file: file));
      return file;
    } catch (e) {
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }
}
