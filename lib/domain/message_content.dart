import 'dart:convert';

import 'package:equatable/equatable.dart';

class MessageContent extends Equatable {
  final String? text;
  final String? src;

  const MessageContent({this.text, this.src});

  factory MessageContent.text(String text) =>
      MessageContent(text: text);
  factory MessageContent.voice(String src) =>
      MessageContent(src: src);

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    if (text != null) map['text'] = text;
    if (src != null) map['src'] = src;
    return map;
  }

  factory MessageContent.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const MessageContent();
    return MessageContent(
      text: map['text'] as String?,
      src: map['src'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  factory MessageContent.fromJson(String source) =>
      MessageContent.fromMap(
        json.decode(source) as Map<String, dynamic>,
      );

  @override
  List<Object?> get props => [text, src];

  @override
  String toString() => 'MessageContent(text: $text, src: $src)';
}
