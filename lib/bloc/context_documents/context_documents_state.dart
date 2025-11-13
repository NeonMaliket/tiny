part of 'context_documents_cubit.dart';

sealed class ContextDocumentsState extends Equatable {
  const ContextDocumentsState();

  @override
  List<Object> get props => [];
}

final class ContextDocumentsInitial extends ContextDocumentsState {}

final class ContextDocumentsHandling extends ContextDocumentsState {}

final class ContextDocumentsLoaded extends ContextDocumentsState {
  final List<StorageObject> documents;

  const ContextDocumentsLoaded(this.documents);

  @override
  List<Object> get props => [documents];
}

final class ContextDocumentAdded extends ContextDocumentsState {
  final StorageObject document;
  const ContextDocumentAdded(this.document);
  @override
  List<Object> get props => [document];
}

final class ContextDocumentRemoved extends ContextDocumentsState {
  final StorageObject document;
  const ContextDocumentRemoved(this.document);
  @override
  List<Object> get props => [document];
}

final class ContextDocumentsError extends ContextDocumentsState {
  final String error;

  const ContextDocumentsError(this.error);

  @override
  List<Object> get props => [error];
}
