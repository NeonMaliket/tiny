part of 'alert_bloc.dart';

sealed class AlertState extends Equatable {
  const AlertState();

  @override
  List<Object> get props => [];
}

final class AlertInitial extends AlertState {}

final class AlertOpened extends AlertState {
  final String title;
  final String message;
  final Function(BuildContext context) onConfirm;

  const AlertOpened({
    required this.title,
    required this.message,
    required this.onConfirm,
  });

  @override
  List<Object> get props => [title, message];
}

final class AlertClosed extends AlertState {
  final BuildContext context;

  const AlertClosed({required this.context});
}
