part of 'alert_bloc.dart';

sealed class AlertEvent extends Equatable {
  const AlertEvent();

  @override
  List<Object> get props => [];
}

final class ShowAlertEvent extends AlertEvent {
  final String title;
  final String message;
  final Function(BuildContext context) onConfirm;

  const ShowAlertEvent({
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  List<Object> get props => [title, message];
}

final class CloseAlertEvent extends AlertEvent {
  final BuildContext context;

  const CloseAlertEvent({required this.context});
}
