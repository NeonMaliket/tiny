// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class EntityBase {
  final String id;

  EntityBase({required this.id});

  EntityBase copyWith({String? id}) {
    return EntityBase(id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id};
  }

  factory EntityBase.fromMap(Map<String, dynamic> map) {
    return EntityBase(id: map['id'] as String);
  }

  String toJson() => json.encode(toMap());

  factory EntityBase.fromJson(String source) =>
      EntityBase.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'EntityBase(id: $id)';

  @override
  bool operator ==(covariant EntityBase other) {
    if (identical(this, other)) return true;

    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
