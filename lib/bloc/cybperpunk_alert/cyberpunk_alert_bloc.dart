import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tiny/components/components.dart';

part 'cyberpunk_alert_event.dart';
part 'cyberpunk_alert_state.dart';

class CyberpunkAlertBloc
    extends Bloc<CyberpunkAlertEvent, CyberpunkAlertState> {
  CyberpunkAlertBloc() : super(CyberpunkAlertInitial()) {
    on<ShowCyberpunkAlertEvent>(_showAlert);
    on<HideCyberpunkAlertEvent>(_hideAlert);
  }

  FutureOr<void> _showAlert(
    ShowCyberpunkAlertEvent event,
    Emitter<CyberpunkAlertState> emit,
  ) {
    emit(
      CyberpunkAlertShown(
        type: event.type,
        title: event.title,
        message: event.message,
        onConfirm: event.onConfirm,
      ),
    );
  }

  FutureOr<void> _hideAlert(
    HideCyberpunkAlertEvent event,
    Emitter<CyberpunkAlertState> emit,
  ) {
    emit(CyberpunkAlertHided());
  }
}
