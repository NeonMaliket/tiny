part of 'storage_bloc.dart';

@immutable
sealed class StorageEvent extends Equatable {}

class StreamStorageEvent extends StorageEvent {
  @override
  List<Object?> get props => [];
}

class UploadDocumentEvent extends StorageEvent {
  final String filename;
  final File file;

  UploadDocumentEvent({required this.filename, required this.file});

  @override
  List<Object?> get props => [filename, file];
}

class DownloadDocumentEvent extends StorageEvent {
  final DocumentMetadata metadata;

  DownloadDocumentEvent({required this.metadata});

  @override
  List<Object?> get props => [metadata];
}

class DeleteDocumentEvent extends StorageEvent {
  final DocumentMetadata metadata;

  DeleteDocumentEvent({required this.metadata});

  @override
  List<Object?> get props => [metadata];
}
