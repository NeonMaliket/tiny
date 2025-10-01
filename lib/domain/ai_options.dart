import 'package:equatable/equatable.dart';

class AiOptions with EquatableMixin {
  final double temperature;
  final double topP;
  final int topK;
  final double repeatPenalty;

  AiOptions({
    required this.temperature,
    required this.topP,
    required this.topK,
    required this.repeatPenalty,
  });

  AiOptions.defaultOptions()
    : temperature = 0.3,
      topP = 0.7,
      topK = 20,
      repeatPenalty = 1.1;

  AiOptions copyWith({
    double? temperature,
    double? topP,
    int? topK,
    double? repeatPenalty,
  }) {
    return AiOptions(
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      topK: topK ?? this.topK,
      repeatPenalty: repeatPenalty ?? this.repeatPenalty,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'temperature': temperature,
      'top_p': topP,
      'top_k': topK,
      'repeat_penalty': repeatPenalty,
    };
  }

  factory AiOptions.fromMap(Map<String, dynamic> map) {
    return AiOptions(
      temperature: (map['temperature'] ?? 0.3).toDouble(),
      topP: (map['top_p'] ?? 0.7).toDouble(),
      topK: (map['top_k'] ?? 20).toInt(),
      repeatPenalty: (map['repeat_penalty'] ?? 1.1)
          .toDouble(),
    );
  }

  @override
  String toString() {
    return 'AiOptions(temperature: $temperature, topP: $topP, topK: $topK, repeatPenalty: $repeatPenalty)';
  }

  @override
  List<Object?> get props => [
    temperature,
    topP,
    topK,
    repeatPenalty,
  ];
}
