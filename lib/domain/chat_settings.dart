import 'package:equatable/equatable.dart';
import 'package:tiny/domain/domain.dart';

class ChatSettings with EquatableMixin {
  final bool isRagEnabled;
  final AiOptions aiOptions;

  ChatSettings({required this.isRagEnabled, required this.aiOptions});

  factory ChatSettings.defaultSettings() {
    return ChatSettings(
      isRagEnabled: false,
      aiOptions: AiOptions.defaultOptions(),
    );
  }

  ChatSettings copyWith({bool? isRagEnabled, AiOptions? aiOptions}) {
    return ChatSettings(
      isRagEnabled: isRagEnabled ?? this.isRagEnabled,
      aiOptions: aiOptions ?? this.aiOptions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'is_rag_enabled': isRagEnabled,
      'ai_options': aiOptions.toMap(),
    };
  }

  factory ChatSettings.fromMap(Map<String, dynamic> map) {
    return ChatSettings(
      isRagEnabled: map['is_rag_enabled'] as bool? ?? false,
      aiOptions: AiOptions.fromMap(
        map['ai_options'] as Map<String, dynamic>? ??
            <String, dynamic>{},
      ),
    );
  }

  @override
  List<Object?> get props => [isRagEnabled, aiOptions];
}
