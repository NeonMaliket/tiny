// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:tiny/domain/domain.dart';

class Chat with EquatableMixin {
  final int id;
  final String title;
  final DateTime createdAt;
  final String? avatar;
  final ChatSettings settings;
  final List<String> rag;

  Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.settings,
    this.avatar,
    this.rag = const [],
  });

  factory Chat.withDefaultSettings({
    required int id,
    required String title,
    required DateTime createdAt,
    String? avatar,
  }) {
    return Chat(
      id: id,
      title: title,
      createdAt: createdAt,
      settings: ChatSettings.defaultSettings(),
      avatar: avatar,
    );
  }

  String? get avatarFileName {
    if (avatar != null) {
      return avatar!.split('/').last;
    }
    return avatar;
  }

  Chat copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    String? avatar,
    ChatSettings? settings,
    List<String>? rag,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
      avatar: avatar ?? this.avatar,
      rag: rag ?? this.rag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'avatar': avatar,
      'settings': settings.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      avatar: map['avatar'],
      settings: ChatSettings.fromMap(
        map['settings'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
      rag: [],
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, createdAt: $createdAt, avatarMetadata: $avatar, settings: $settings, rag: $rag)';
  }

  @override
  List<Object?> get props => [id, title, createdAt, avatar, settings];
}
