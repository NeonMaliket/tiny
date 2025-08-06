import 'domain.dart';

class Chat {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatEntry> history;

  Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.history,
  });

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, createdAt: $createdAt, history: $history)';
  }
}
