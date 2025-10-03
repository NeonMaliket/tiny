// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:tiny/domain/domain.dart';

class Chat with EquatableMixin {
  final int id;
  final String title;
  final DateTime createdAt;
  final DocumentMetadata? avatarMetadata;
  final ChatSettings settings;

  Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.settings,
    this.avatarMetadata,
  });

  factory Chat.withDefaultSettings({
    required int id,
    required String title,
    required DateTime createdAt,
    DocumentMetadata? avatarMetadata,
  }) {
    return Chat(
      id: id,
      title: title,
      createdAt: createdAt,
      settings: ChatSettings.defaultSettings(),
      avatarMetadata: avatarMetadata,
    );
  }

  Chat copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    DocumentMetadata? avatarMetadata,
    ChatSettings? settings,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
      avatarMetadata: avatarMetadata ?? this.avatarMetadata,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'avatar_metadata': avatarMetadata?.toMap(),
      'settings': settings.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      avatarMetadata: map['avatar_metadata'] != null
          ? DocumentMetadata.fromMap(
              map['avatar_metadata'] as Map<String, dynamic>,
            )
          : null,
      settings: ChatSettings.fromMap(
        map['settings'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, createdAt: $createdAt, avatarMetadata: $avatarMetadata, settings: $settings)';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    createdAt,
    avatarMetadata,
    settings,
  ];
}
