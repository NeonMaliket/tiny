import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/bloc/loader/loader_cubit.dart';
import 'package:tiny/domain/storage_object.dart';
import 'package:tiny/repository/repository.dart';

part 'storage_state.dart';

const errorMessage =
    'An unexpected error occurred. Please try again later.';

class StorageCubit extends Cubit<StorageState> {
  StorageCubit(this._storageRepository, this._loaderCubit)
    : super(StorageInitial());

  final LoaderCubit _loaderCubit;
  final StorageRepository _storageRepository;

  Future<List<StorageObject>> storageListFiles() async {
    emit(GlobalStorageHandling());
    try {
      final fileList = await _storageRepository.loadUserStorage();
      emit(StorageListSuccess(storageObjects: fileList));
      return fileList;
    } catch (e) {
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }

  Future<String> uploadStorageFile(final File file) async {
    final fileName = file.path.split('/').last;
    emit(GlobalStorageHandling());
    await _loaderCubit.loading(fileName);
    try {
      final uploadedFileName = await _storageRepository
          .uploadStorageFile(file);
      emit(StorageUploadSuccess(fileName: uploadedFileName));
      await _loaderCubit.loadedSuccess(fileName);
      return uploadedFileName;
    } catch (e) {
      _loaderCubit.loadedFailure(fileName);
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }

  Future<void> deleteStorageFile(final String path) async {
    emit(GlobalStorageHandling());
    try {
      await _storageRepository.deleteStorageFile(path);
      emit(StorageDeleteSuccess(fileName: path));
    } catch (e) {
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }

  Future<File> downloadStorageFile(final String path) async {
    emit(GlobalStorageHandling());
    try {
      final file = await _storageRepository.downloadUserStorageFile(
        path,
      );
      emit(StorageDownloadSuccess(file: file));
      return file;
    } catch (e) {
      emit(StorageFailure(error: errorMessage));
      rethrow;
    }
  }
}
