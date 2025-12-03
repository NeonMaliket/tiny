import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/domain/domain.dart';
import 'package:tiny/repository/repository.dart';

part 'context_documents_state.dart';

class ContextDocumentsCubit extends Cubit<ContextDocumentsState> {
  ContextDocumentsCubit({
    required ContextDocumentsRepository contextDocumentsRepository,
  }) : _contextDocumentsRepository = contextDocumentsRepository,
       super(ContextDocumentsInitial());

  final ContextDocumentsRepository _contextDocumentsRepository;

  Future<List<StorageObject>> loadContextDocuments({
    required int chatId,
  }) async {
    emit(ContextDocumentsHandling());
    try {
      final documents = await _contextDocumentsRepository
          .loadContextDocuments(chatId);
      emit(ContextDocumentsLoaded(documents));
      return documents;
    } catch (e, st) {
      addError(e, st);
      emit(ContextDocumentsError(e.toString()));
      rethrow;
    }
  }

  Future<void> addContextDocument({
    required int chatId,
    required StorageObject document,
  }) async {
    emit(ContextDocumentsHandling());
    try {
      await _contextDocumentsRepository.addContextDocument(
        chatId,
        document.id,
      );
      emit(ContextDocumentAdded(document));
    } catch (e, st) {
      addError(e, st);
      emit(ContextDocumentsError(e.toString()));
      rethrow;
    }
  }

  Future<void> removeContextDocument({
    required int chatId,
    required StorageObject document,
  }) async {
    emit(ContextDocumentsHandling());
    try {
      await _contextDocumentsRepository.removeContextDocument(
        chatId,
        document.id,
      );
      emit(ContextDocumentRemoved(document));
    } catch (e, st) {
      addError(e, st);
      emit(ContextDocumentsError(e.toString()));
      rethrow;
    }
  }
}
