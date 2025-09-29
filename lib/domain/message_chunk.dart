// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MessageChunk {
  final String chunk;
  final bool isLast;

  MessageChunk({required this.chunk, required this.isLast});

  factory MessageChunk.last() {
    return MessageChunk(chunk: '', isLast: true);
  }

  factory MessageChunk.fromSupabase(String raw) {
    final cleaned = raw.trim().startsWith('data:')
        ? raw.trim().substring(5).trim()
        : raw.trim();

    final Map<String, dynamic> data = jsonDecode(cleaned);

    final choices = data['choices'] as List;
    final choice = choices.first as Map<String, dynamic>;

    final delta = choice['delta'] as Map<String, dynamic>? ?? {};
    final content = delta['content'] as String? ?? '';

    final finishReason = choice['finish_reason'];
    final isLast = finishReason != null && finishReason == 'stop';

    return MessageChunk(chunk: content, isLast: isLast);
  }
}
