part of 'document_bloc.dart';

sealed class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object> get props => [];
}

final class DocumentInitial extends DocumentState {}

final class DocumentSelecting extends DocumentState {}

final class DocumentNotSelected extends DocumentState {}

final class DocumentSelected extends DocumentState {
  final File file;

  const DocumentSelected(this.file);
}

final class DocumentSelectionError extends DocumentState {
  final String message;

  const DocumentSelectionError(this.message);

  @override
  List<Object> get props => [message];
}

final class DocumentUploading extends DocumentState {}

final class DocumentUploaded extends DocumentState {
  final File file;

  const DocumentUploaded(this.file);

  @override
  List<Object> get props => [file];
}

final class DocumentUploadingError extends DocumentState {
  final String message;

  const DocumentUploadingError(this.message);

  @override
  List<Object> get props => [message];
}
