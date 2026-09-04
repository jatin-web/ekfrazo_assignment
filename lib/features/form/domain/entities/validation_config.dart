import 'package:equatable/equatable.dart';

/// One validation rule attached to a field, e.g.
/// {"type": "required", "message": "MEDICINE_REQUIRED"}
/// {"type": "minLength", "value": 2, "message": "MIN_2_CHARS"}
class ValidationConfig extends Equatable {
  final String type;
  final int? value;
  final String message;

  const ValidationConfig({
    required this.type,
    required this.message,
    this.value,
  });

  @override
  List<Object?> get props => [type, value, message];
}
