// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageChunk {
  final String chunk;
  final bool isLast;
  MessageChunk({required this.chunk, required this.isLast});

  MessageChunk copyWith({String? chunk, bool? isLast}) {
    return MessageChunk(
      chunk: chunk ?? this.chunk,
      isLast: isLast ?? this.isLast,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'chunk': chunk, 'isLast': isLast};
  }

  factory MessageChunk.fromMap(Map<String, dynamic> map) {
    return MessageChunk(
      chunk: map['chunk'] as String,
      isLast: map['isLast'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageChunk.fromJson(String source) =>
      MessageChunk.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'MessageChunk(chunk: $chunk, isLast: $isLast)';

  @override
  bool operator ==(covariant MessageChunk other) {
    if (identical(this, other)) return true;

    return other.chunk == chunk && other.isLast == isLast;
  }

  @override
  int get hashCode => chunk.hashCode ^ isLast.hashCode;
}
