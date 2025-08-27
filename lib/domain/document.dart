// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Document {
  final String id;
  final String name;
  final String type;
  Document({required this.id, required this.name, required this.type});

  Document copyWith({String? id, String? name, String? type}) {
    return Document(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'name': name, 'type': type};
  }

  factory Document.fromMap(Map<String, dynamic> map) {
    return Document(
      id: map['id'] as String,
      name: map['name'] as String,
      type: map['type'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Document.fromJson(String source) =>
      Document.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Document(id: $id, name: $name, type: $type)';

  @override
  bool operator ==(covariant Document other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name && other.type == type;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ type.hashCode;
}
