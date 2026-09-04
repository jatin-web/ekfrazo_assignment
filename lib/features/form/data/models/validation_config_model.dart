import '../../domain/entities/validation_config.dart';

class ValidationConfigModel {
  static ValidationConfig fromJson(Map<String, dynamic> json) {
    return ValidationConfig(
      type: json['type'] as String,
      message: json['message'] as String,
      value: json['value'] as int?,
    );
  }
}