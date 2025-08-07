enum ChatEntryAuthor { user, assistant }

class ChatEntry {
  final String id;
  final String content;
  final DateTime createdAt;
  final ChatEntryAuthor author;

  ChatEntry({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.author,
  });

  @override
  String toString() {
    return 'ChatEntry(id: $id, content: $content, timestamp: $createdAt, author: $author)';
  }
}
