// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart';
import 'package:tiny/domain/domain.dart';

enum ChatMessageAuthor { user, assistant }

class ChatMessage extends Equatable {
  final int? id;
  final MessageContent content;
  final DateTime createdAt;
  final int chatId;
  final String messageType;
  final ChatMessageAuthor author;

  const ChatMessage({
    this.id,
    required this.content,
    required this.createdAt,
    required this.chatId,
    required this.author,
    required this.messageType,
  });

  TextMessage toTextMessage() {
    if (content.text == null) {
      throw Exception('Content text is null');
    }
    return TextMessage(
      id: id.toString(),
      authorId: author.name,
      createdAt: createdAt,
      text: content.text ?? '',
    );
  }

  bool get isUser => author == ChatMessageAuthor.user;

  @override
  String toString() {
    return 'ChatMessage(id: $id, content: $content, createdAt: $createdAt, chatId: $chatId, author: $author)';
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'content': content.toMap(),
      'created_at': createdAt.toIso8601String(),
      'author': author.name,
      'chat_id': chatId,
      'message_type': messageType,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] as int,
      content: MessageContent.fromMap(
        map['content'] as Map<String, dynamic>,
      ),
      createdAt: DateTime.parse(map['created_at']),
      author: ChatMessageAuthor.values.firstWhere(
        (x) => x.name == map['author'],
      ),
      chatId: map['chat_id'] as int,
      messageType: map['message_type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) => ChatMessage.fromMap(
    json.decode(source) as Map<String, dynamic>,
  );

  ChatMessage copyWith({
    int? id,
    MessageContent? content,
    DateTime? createdAt,
    int? chatId,
    ChatMessageAuthor? author,
    String? messageType,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      author: author ?? this.author,
      chatId: chatId ?? this.chatId,
      messageType: messageType ?? this.messageType,
    );
  }

  @override
  List<Object?> get props => [
    id,
    content,
    createdAt,
    author,
    chatId,
    messageType,
  ];
}
