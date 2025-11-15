part of 'record_bloc.dart';

sealed class RecordState extends Equatable {
  const RecordState();

  @override
  List<Object> get props => [];
}

final class RecordInitial extends RecordState {}

final class Recording extends RecordState {}

final class RecordSaved extends RecordState {
  const RecordSaved({required this.record});

  final File record;

  @override
  List<Object> get props => [];
}

final class RecordError extends RecordState {
  final String error;

  const RecordError(this.error);

  @override
  List<Object> get props => [error];
}
