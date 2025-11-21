import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:tiny/config/config.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  DocumentCubit() : super(DocumentInitial());

  Future<File?> selectPicture() async {
    logger.info('Selecting picture');
    emit(DocumentSelecting());
    return await _pickFiles(type: FileType.image);
  }

  Future<File?> selectDocument() async {
    logger.info('Selecting file');
    return await _pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );
  }

  Future<File?> _pickFiles({
    required FileType type,
    List<String>? allowedExtensions,
  }) async {
    emit(DocumentSelecting());
    try {
      final result = await FilePicker.platform.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );
      final path = result?.files.first.path;
      if (path != null) {
        logger.debug('File selected with path: $path');
        final file = File(path);
        emit(DocumentSelected(file));
        return file;
      } else {
        logger.debug('File hasn`t been selected');
        emit(DocumentNotSelected());
        return null;
      }
    } catch (e) {
      logger.error('File selection error', e);
      emit(DocumentSelectionError(e.toString()));
      return null;
    }
  }
}
