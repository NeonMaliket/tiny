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

  bool get isUser => author == ChatEntryAuthor.user;

  @override
  String toString() {
    return 'ChatEntry(id: $id, content: $content, timestamp: $createdAt, author: $author)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'author': author.name,
    };
  }

  factory ChatEntry.fromMap(Map<String, dynamic> map) {
    return ChatEntry(
      id: map['id'] as String,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      author: ChatEntryAuthor.values.firstWhere((x) => x.name == map['author']),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatEntry.fromJson(String source) =>
      ChatEntry.fromMap(json.decode(source) as Map<String, dynamic>);
}
