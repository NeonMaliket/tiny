import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'loader_state.dart';

class LoaderCubit extends Cubit<LoaderState> {
  LoaderCubit() : super(LoaderInitial());

  Future<void> loading(String message) async {
    emit(LoaderLoading(message));
  }

  Future<void> loadedSuccess(String message) async {
    emit(LoaderSuccess(message));
  }

  Future<void> loadedFailure(String error) async {
    emit(LoaderFailure(error));
  }
}
