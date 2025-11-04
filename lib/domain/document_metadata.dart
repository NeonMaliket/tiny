// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class DocumentMetadata with EquatableMixin {
  final int? id;
  final String filename;
  final String type;
  final DateTime createdAt;
  const DocumentMetadata({
    required this.id,
    required this.filename,
    required this.type,
    required this.createdAt,
  });

  DocumentMetadata copyWith({
    int? id,
    String? filename,
    String? type,
    DateTime? createdAt,
  }) {
    return DocumentMetadata(
      id: id ?? this.id,
      filename: filename ?? this.filename,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'filename': filename,
      'type': type,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory DocumentMetadata.fromMap(Map<String, dynamic> map) {
    return DocumentMetadata(
      id: map['id'] as int,
      filename: map['file_name'] as String,
      type: map['type'] as String,
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory DocumentMetadata.fromJson(String source) =>
      DocumentMetadata.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DocumentMetadata(id: $id, filename: $filename, type: $type, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant DocumentMetadata other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.filename == filename &&
        other.type == type &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ filename.hashCode ^ type.hashCode ^ createdAt.hashCode;
  }

  @override
  List<Object?> get props => [id, filename, type, createdAt];
}
