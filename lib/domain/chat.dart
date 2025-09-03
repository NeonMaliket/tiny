// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'domain.dart';

class Chat extends EntityBase {
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> history;

  Chat({
    required super.id,
    required this.title,
    required this.createdAt,
    required this.history,
  });

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, createdAt: $createdAt, history: $history)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'history': history.map((x) => x.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['createdAt']),
      history: (List<ChatMessage>.from(
        (map['history'] as List<dynamic>).map<ChatMessage>(
          (x) => ChatMessage.fromMap(x as Map<String, dynamic>),
        ),
      )),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}
