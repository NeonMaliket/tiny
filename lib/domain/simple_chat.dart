// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SimpleChat {
  final String id;
  final String title;
  final DateTime createdAt;

  SimpleChat({required this.id, required this.title, required this.createdAt});

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, createdAt: $createdAt)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory SimpleChat.fromMap(Map<String, dynamic> map) {
    return SimpleChat(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory SimpleChat.fromJson(String source) =>
      SimpleChat.fromMap(json.decode(source) as Map<String, dynamic>);
}
