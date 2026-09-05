import 'package:ekfrazo_assignment/features/form/domain/entities/validation_config.dart';

typedef FieldValidator = String? Function(String value, ValidationConfig rule);

/// Registry-based validation engine: each `type` from the config maps to a
/// small validator function, so supporting a new validation type is a one
/// line addition here rather than a new branch scattered across widgets.
class ValidationEngine {
  const ValidationEngine._();

  static final Map<String, FieldValidator> _validators = {
    'required': (value, rule) => value.trim().isEmpty ? rule.message : null,
    'minLength': (value, rule) =>
        value.trim().length < (rule.value ?? 0) ? rule.message : null,
  };

  /// Runs every rule in order and returns the first failing message,
  /// or null when the value satisfies all of them.
  static String? validateField(String value, List<ValidationConfig> rules) {
    for (final rule in rules) {
      final validator = _validators[rule.type];
      final error = validator?.call(value, rule);
      if (error != null) return error;
    }
    return null;
  }
}
