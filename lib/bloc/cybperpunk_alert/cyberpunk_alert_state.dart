part of 'cyberpunk_alert_bloc.dart';

sealed class CyberpunkAlertState extends Equatable {
  const CyberpunkAlertState();

  @override
  List<Object> get props => [];
}

final class CyberpunkAlertInitial extends CyberpunkAlertState {}

final class CyberpunkAlertShown extends CyberpunkAlertState {
  const CyberpunkAlertShown({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    this.onConfirm,
  });
  final String id;
  final CyberpunkAlertType type;
  final String title;
  final String message;
  final Function(BuildContext context)? onConfirm;

  @override
  List<Object> get props => [id, type, title, message];
}

final class CyberpunkAlertHided extends CyberpunkAlertState {}
