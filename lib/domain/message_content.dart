import 'dart:convert';

import 'package:equatable/equatable.dart';

class MessageContent extends Equatable {
  final String? text;
  final String? src;

  const MessageContent({this.text, this.src});

  Map<String, dynamic> toMap() {
    return {'text': text, 'src': src};
  }

  factory MessageContent.fromMap(Map<String, dynamic> map) {
    return MessageContent(
      text: map['text'] as String?,
      src: map['src'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  MessageContent fromJson(String source) => MessageContent.fromMap(
    json.decode(source) as Map<String, dynamic>,
  );

  @override
  String toString() => 'MessageContent(text: $text, src: $src)';

  @override
  List<Object> get props => throw UnimplementedError();
}
