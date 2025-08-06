class ChatEntry {
  final String id;
  final String content;
  final DateTime createdAt;

  ChatEntry({required this.id, required this.content, required this.createdAt});

  @override
  String toString() {
    return 'ChatEntry(id: $id, content: $content, timestamp: $createdAt)';
  }
}
