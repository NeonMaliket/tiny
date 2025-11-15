part of 'record_bloc.dart';

sealed class RecordEvent extends Equatable {
  const RecordEvent();

  @override
  List<Object> get props => [];
}

final class TurnOnRecordEvent extends RecordEvent {
  const TurnOnRecordEvent();
}

final class TurnOffRecordEvent extends RecordEvent {
  const TurnOffRecordEvent({required this.chatId});

  final int chatId;

  @override
  List<Object> get props => [chatId];
}
