// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class SimpleChat with EquatableMixin {
  final int id;
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
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory SimpleChat.fromMap(Map<String, dynamic> map) {
    return SimpleChat(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory SimpleChat.fromJson(String source) =>
      SimpleChat.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [id, title, createdAt];
}
