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
