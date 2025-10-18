import 'package:equatable/equatable.dart';

class ChatDocuments extends Equatable {
  final int id;
  final DateTime createdAt;
  final int chatId;
  final int documentMetadataId;

  const ChatDocuments({
    required this.id,
    required this.createdAt,
    required this.chatId,
    required this.documentMetadataId,
  });

  factory ChatDocuments.fromMap(Map<String, dynamic> map) {
    return ChatDocuments(
      id: map['id'] as int,
      createdAt: DateTime.parse(map['created_at'] as String),
      chatId: map['chat_id'] as int,
      documentMetadataId: map['metadata_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'chat_id': chatId,
      'metadata_id': documentMetadataId,
    };
  }

  @override
  List<Object> get props => [
    id,
    createdAt,
    chatId,
    documentMetadataId,
  ];
}
