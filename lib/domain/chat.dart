// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:tiny/domain/domain.dart';

class Chat with EquatableMixin {
  final int id;
  final String title;
  final DateTime createdAt;
  final StorageObject? avatarObject;
  final ChatSettings settings;
  final List<StorageObject> rag;

  Chat({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.settings,
    this.avatarObject,
    this.rag = const [],
  });

  factory Chat.withDefaultSettings({
    required int id,
    required String title,
    required DateTime createdAt,
    StorageObject? avatar,
  }) {
    return Chat(
      id: id,
      title: title,
      createdAt: createdAt,
      settings: ChatSettings.defaultSettings(),
      avatarObject: avatar,
    );
  }

  Chat copyWith({
    int? id,
    String? title,
    DateTime? createdAt,
    StorageObject? avatarObject,
    ChatSettings? settings,
    List<StorageObject>? rag,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      settings: settings ?? this.settings,
      avatarObject: avatarObject ?? this.avatarObject,
      rag: rag ?? this.rag,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'avatar_id': avatarObject?.id,
      'settings': settings.toMap(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'] as int,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      avatarObject: map['avatar_object'] == null
          ? null
          : StorageObject.fromMap(
              map['avatar_object'] as Map<String, dynamic>? ??
                  <String, dynamic>{},
            ),
      settings: ChatSettings.fromMap(
        map['settings'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
      rag: map['rag'] == null
          ? []
          : (map['rag'] as List<dynamic>?)
                    ?.map(
                      (e) => StorageObject.fromMap(
                        e['object'] as Map<String, dynamic>,
                      ),
                    )
                    .toList() ??
                [],
    );
  }

  @override
  String toString() {
    return 'Chat(id: $id, title: $title, createdAt: $createdAt, avatarObject: $avatarObject, settings: $settings, rag: $rag)';
  }

  @override
  List<Object?> get props => [
    id,
    title,
    createdAt,
    avatarObject,
    settings,
  ];
}
