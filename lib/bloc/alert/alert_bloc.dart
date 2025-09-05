import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'alert_event.dart';
part 'alert_state.dart';

class AlertBloc extends Bloc<AlertEvent, AlertState> {
  AlertBloc() : super(AlertInitial()) {
    on<ShowAlertEvent>(_onShowAlertEvent);
    on<CloseAlertEvent>(_onCloseAlertEvent);
  }
  Future<void> _onCloseAlertEvent(
    CloseAlertEvent event,
    Emitter<AlertState> emit,
  ) async {
    emit(AlertClosed(context: event.context));
  }

  Future<void> _onShowAlertEvent(
    ShowAlertEvent event,
    Emitter<AlertState> emit,
  ) async {
    emit(
      AlertOpened(
        title: event.title,
        message: event.message,
        onConfirm: event.onConfirm,
      ),
    );
  }
}
