part of 'storage_cubit.dart';

sealed class StorageState extends Equatable {
  const StorageState();

  @override
  List<Object> get props => [];
}

final class StorageInitial extends StorageState {}

final class GlobalStorageHandling extends StorageState {}

final class StorageUploadSuccess extends StorageState {
  final String fileName;

  const StorageUploadSuccess({required this.fileName});

  @override
  List<Object> get props => [fileName];
}

final class StorageListSuccess extends StorageState {
  final List<StorageObject> storageObjects;

  const StorageListSuccess({required this.storageObjects});

  @override
  List<Object> get props => [storageObjects];
}

final class StorageDeleteSuccess extends StorageState {
  final String fileName;

  const StorageDeleteSuccess({required this.fileName});

  @override
  List<Object> get props => [fileName];
}

final class StorageDownloadSuccess extends StorageState {
  final File file;

  const StorageDownloadSuccess({required this.file});

  @override
  List<Object> get props => [file];
}

final class StorageFailure extends StorageState {
  final String error;

  const StorageFailure({required this.error});

  @override
  List<Object> get props => [error];
}
