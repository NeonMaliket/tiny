part of 'loader_cubit.dart';

sealed class LoaderState extends Equatable {
  const LoaderState();

  @override
  List<Object> get props => [];
}

final class LoaderInitial extends LoaderState {}

final class LoaderLoading extends LoaderState {
  final String message;

  const LoaderLoading(this.message);

  @override
  List<Object> get props => [message];
}

final class LoaderSuccess extends LoaderState {
  final String message;

  const LoaderSuccess(this.message);

  @override
  List<Object> get props => [message];
}

final class LoaderFailure extends LoaderState {
  final String errorMessage;

  const LoaderFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
