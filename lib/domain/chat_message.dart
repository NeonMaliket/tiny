// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';

enum ChatMessageAuthor { user, assistant }

class ChatMessage extends Equatable {
  final int id;
  final String content;
  final DateTime createdAt;
  final ChatMessageAuthor author;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.author,
  });

  TextMessage toTextMessage() {
    return TextMessage(
      id: id.toString(),
      authorId: author.name,
      createdAt: createdAt,
      text: content,
    );
  }

  bool get isUser => author == ChatMessageAuthor.user;

  @override
  String toString() {
    return 'ChatEntry(id: $id, content: $content, timestamp: $createdAt, author: $author)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'author': author.name,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int,
      content: map['content'] as String,
      createdAt: DateTime.parse(map['created_at']),
      author: ChatMessageAuthor.values.firstWhere(
        (x) => x.name == map['author'],
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  ChatMessage copyWith({
    int? id,
    String? content,
    DateTime? createdAt,
    ChatMessageAuthor? author,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
    );
  }

  @override
  List<Object> get props => [id, content, createdAt, author];
}
