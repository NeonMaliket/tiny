// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ChatSettings {
  final int id;
  final int chatId;
  final bool isRagEnabled;

  ChatSettings({
    required this.id,
    required this.chatId,
    required this.isRagEnabled,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chat_id': chatId,
      'is_rag_enabled': isRagEnabled ? 1 : 0,
    };
  }

  factory ChatSettings.fromMap(Map<String, dynamic> map) {
    return ChatSettings(
      id: map['id'] as int,
      chatId: map['chat_id'] as int,
      isRagEnabled: (map['is_rag_enabled'] as int) == 1,
    );
  }
  String toJson() => json.encode(toMap());
  factory ChatSettings.fromJson(String source) =>
      ChatSettings.fromMap(json.decode(source) as Map<String, dynamic>);

  ChatSettings copyWith({int? id, int? chatId, bool? isRagEnabled}) {
    return ChatSettings(
      id: id ?? this.id,
      chatId: chatId ?? this.chatId,
      isRagEnabled: isRagEnabled ?? this.isRagEnabled,
    );
  }
}
