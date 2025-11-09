import 'dart:convert';

import 'package:equatable/equatable.dart';

class MessageContent extends Equatable {
  final String? text;
  final String? audioId;

  const MessageContent({this.text, this.audioId});

  Map<String, dynamic> toMap() {
    return {'text': text, 'audio_id': audioId};
  }

  factory MessageContent.fromMap(Map<String, dynamic> map) {
    return MessageContent(
      text: map['text'] as String?,
      audioId: map['audio_id'] as String?,
    );
  }

  String toJson() => json.encode(toMap());

  MessageContent fromJson(String source) => MessageContent.fromMap(
    json.decode(source) as Map<String, dynamic>,
  );

  @override
  String toString() =>
      'MessageContent(text: $text, audioId: $audioId)';

  @override
  List<Object> get props => throw UnimplementedError();
}
