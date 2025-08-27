import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tiny/config/config.dart';

part 'document_event.dart';
part 'document_state.dart';

class DocumentBloc extends Bloc<DocumentEvent, DocumentState> {
  DocumentBloc() : super(DocumentInitial()) {
    on<SelectDocumentEvent>(_onSelectDocumentEvent);
  }

  Future<void> _onSelectDocumentEvent(
    SelectDocumentEvent event,
    Emitter<DocumentState> emit,
  ) async {
    logger.i('Selecting file');
    emit(DocumentSelecting());
    try {
      final result = await FilePicker.platform.pickFiles();
      final path = result?.files.first.path;
      if (path != null) {
        logger.d('File selected with path: $path');
        emit(DocumentSelected(File(path)));
      } else {
        logger.d('File hasn`t been selected');
        emit(DocumentNotSelected());
      }
    } catch (e) {
      logger.e('File selection error', error: e);
      emit(DocumentSelectionError(e.toString()));
    }
  }
}
