class StreamEvent<T> {
  final T? data;
  final StreamEventType event;

  StreamEvent(this.data, this.event);
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
