import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:record/record.dart';
import 'package:tiny/config/config.dart';
import 'package:tiny/repository/storage_repository.dart';

part 'record_event.dart';
part 'record_state.dart';

class RecordBloc extends Bloc<RecordEvent, RecordState> {
  RecordBloc({required StorageRepository storage})
    : _storage = storage,
      super(RecordInitial()) {
    on<TurnOnRecordEvent>(_onTurnOnRecord);
    on<TurnOffRecordEvent>(_onTurnOffRecord);
  }

  final StorageRepository _storage;
  final _rec = AudioRecorder();

  @override
  Future<void> close() async {
    try {
      await _rec.dispose();
    } catch (e, st) {
      addError(e, st);
    }
    return super.close();
  }

  void _onTurnOnRecord(
    TurnOnRecordEvent event,
    Emitter<RecordState> emit,
  ) async {
    try {
      final hasPerm = await _rec.hasPermission();
      if (!hasPerm) {
        emit(RecordError("No mic permission"));
        return;
      }

      final toFile = '${Directory.systemTemp.path}/$_fileName';

      await _rec.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: toFile,
      );

      emit(Recording());
    } catch (e, st) {
      addError(e, st);
      logger.error("Recording error", e, st);
      emit(RecordError("Failed to start recording"));
    }
  }

  void _onTurnOffRecord(
    TurnOffRecordEvent event,
    Emitter<RecordState> emit,
  ) async {
    emit(RecordSaving());
    try {
      final filePath = await _rec.stop();
      if (filePath == null) {
        emit(RecordInitial());
        return;
      }

      final file = File(filePath);

      final storagePath = await _storage.uploadVoiceMessage(
        event.chatId,
        file,
      );

      final recordFromStorage = await _storage.downloadVoiceMessage(
        event.chatId,
        storagePath.split('/').last,
      );

      emit(
        RecordSaved(
          record: recordFromStorage,
          cloudPath: storagePath,
        ),
      );
    } catch (e, st) {
      addError(e, st);
      logger.error("Recording error", e, st);
      emit(RecordError("Failed to save recording"));
    }
  }

  String get _fileName =>
      'record_${DateTime.now().millisecondsSinceEpoch}.m4a';
}
