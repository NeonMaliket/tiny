part of 'storage_cubit.dart';

sealed class StorageState extends Equatable {
  const StorageState();

  @override
  List<Object> get props => [];
}

final class StorageInitial extends StorageState {}

final class DocumentUploading extends StorageState {}

final class DocumentUploaded extends StorageState {
  final DocumentMetadata metadata;

  const DocumentUploaded(this.metadata);

  @override
  List<Object> get props => [metadata];
}

final class DocumentUploadingError extends StorageState {
  final String message;

  const DocumentUploadingError(this.message);

  @override
  List<Object> get props => [message];
}

final class StorageLoading extends StorageState {}

final class StorageLoaded extends StorageState {}

final class StorageLoadingError extends StorageState {
  final String message;

  const StorageLoadingError(this.message);

  @override
  List<Object> get props => [message];
}

final class StorageDocumentDownloading extends StorageState {}

final class StorageDocumentDownloaded extends StorageState {
  final String filePath;

  const StorageDocumentDownloaded(this.filePath);

  @override
  List<Object> get props => [filePath];
}

final class StorageDocumentDownloadingError extends StorageState {
  final String message;

  const StorageDocumentDownloadingError(this.message);

  @override
  List<Object> get props => [message];
}

final class StorageDocumentDeleting extends StorageState {}

final class StorageDocumentDeleted extends StorageState {}

final class StorageDocumentDeletingError extends StorageState {
  final String message;

  const StorageDocumentDeletingError(this.message);

  @override
  List<Object> get props => [message];
}
