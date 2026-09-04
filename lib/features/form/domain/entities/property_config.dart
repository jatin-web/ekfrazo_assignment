import 'package:ekfrazo_assignment/features/form/domain/entities/enum_option.dart';
import 'package:ekfrazo_assignment/features/form/domain/entities/validation_config.dart';

class PropertyConfig {
  final String type;
  final FieldFormat format;
  final String fieldName;
  final String label;
  final bool isMandatory;
  final List<ValidationConfig> validations;
  final List<EnumOption> enums;

  const PropertyConfig({
    required this.type,
    required this.format,
    required this.fieldName,
    required this.label,
    required this.isMandatory,
    this.validations = const [],
    this.enums = const [],
  });
}

enum FieldFormat {
  textInput,
  dropdown;

  static FieldFormat fromJson(String value) {
    switch (value) {
      case "textInput":
        return textInput;
      case "dropdown":
        return dropdown;
      default:
        throw FormatException('Unknown field format: "$value"');
    }
  }
}
