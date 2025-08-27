part of 'document_bloc.dart';

@immutable
sealed class DocumentEvent extends Equatable {}

class SelectDocumentEvent extends DocumentEvent {
  @override
  List<Object?> get props => [];
}
