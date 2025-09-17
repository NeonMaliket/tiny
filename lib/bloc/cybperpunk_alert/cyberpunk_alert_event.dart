part of 'cyberpunk_alert_bloc.dart';

sealed class CyberpunkAlertEvent extends Equatable {
  const CyberpunkAlertEvent();

  @override
  List<Object> get props => [];
}

final class ShowCyberpunkAlertEvent extends CyberpunkAlertEvent {
  const ShowCyberpunkAlertEvent({
    required this.type,
    required this.title,
    required this.message,
    this.onConfirm,
  });

  final CyberpunkAlertType type;
  final String title;
  final String message;
  final Function(BuildContext context)? onConfirm;

  @override
  List<Object> get props => [type, title, message];
}

final class HideCyberpunkAlertEvent extends CyberpunkAlertEvent {}
