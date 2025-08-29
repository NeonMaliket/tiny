part of 'document_bloc.dart';

@immutable
sealed class DocumentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadDocumentsEvent extends DocumentEvent {}

class SelectDocumentEvent extends DocumentEvent {}
