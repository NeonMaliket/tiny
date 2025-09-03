import 'package:equatable/equatable.dart';
import 'package:eventsource/eventsource.dart';

class StreamEvent<T> extends Equatable {
  final T? data;
  final StreamEventType event;

  const StreamEvent(this.data, this.event);

  static StreamEvent<String> fromStreamEvent(Event event) =>
      StreamEvent<String>(event.data, StreamEventType.fromString(event.event));

  @override
  List<Object?> get props => [data, event];
}

enum StreamEventType {
  newInstance,
  history,
  delete,
  unknown;

  static StreamEventType fromString(String? event) {
    switch (event) {
      case 'new':
        return StreamEventType.newInstance;
      case 'history':
        return StreamEventType.history;
      case 'delete':
        return StreamEventType.delete;
      default:
        return StreamEventType.unknown;
    }
  }

  StreamEvent<T> build<T>(T data) {
    return StreamEvent(data, this);
  }
}
