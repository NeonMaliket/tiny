// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'author': author.name,
    };
  }

  factory ChatEntry.fromMap(Map<String, dynamic> map) {
    return ChatEntry(
      id: map['id'] as String,
      content: map['content'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      author: ChatEntryAuthor.values.firstWhere((x) => x == map['author']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatEntry.fromJson(String source) =>
      ChatEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}
