import 'package:equatable/equatable.dart';

class DiseasePredictionResponse extends Equatable {
  final String? label;
  final double? confidence;
  final Map<String, dynamic> raw;

  const DiseasePredictionResponse({
    required this.raw,
    this.label,
    this.confidence,
  });

  factory DiseasePredictionResponse.fromJson(Map<String, dynamic> json) {
    return DiseasePredictionResponse(
      raw: json,
      label: _firstString(json, const [
        'prediction',
        'class',
        'disease',
        'label',
        'result',
        'name',
      ]),
      confidence: _firstDouble(json, const [
        'confidence',
        'score',
        'probability',
        'accuracy',
      ]),
    );
  }

  static String? _firstString(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is String && value.trim().isNotEmpty) {
        return value;
      }
      if (value is num) {
        return value.toString();
      }
    }
    return null;
  }

  static double? _firstDouble(Map<String, dynamic> json, List<String> keys) {
    for (final key in keys) {
      final value = json[key];
      if (value is num) {
        return value.toDouble();
      }
      if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) {
          return parsed;
        }
      }
    }
    return null;
  }

  @override
  List<Object?> get props => [label, confidence, raw];
}
