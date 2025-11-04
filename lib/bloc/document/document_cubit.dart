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
    logger.i('Selecting picture');
    emit(DocumentSelecting());
    return await _pickFiles(type: FileType.image);
  }

  Future<File?> selectDocument() async {
    logger.i('Selecting file');
    return await _pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'docx', 'txt', 'md'],
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
      print(result);
      final path = result?.files.first.path;
      if (path != null) {
        logger.d('File selected with path: $path');
        final file = File(path);
        emit(DocumentSelected(file));
        return file;
      } else {
        logger.d('File hasn`t been selected');
        emit(DocumentNotSelected());
        return null;
      }
    } catch (e) {
      logger.e('File selection error', error: e);
      emit(DocumentSelectionError(e.toString()));
      return null;
    }
  }
}
