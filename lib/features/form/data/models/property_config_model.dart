
import '../../domain/entities/property_config.dart';
import 'enum_option_model.dart';
import 'validation_config_model.dart';

class PropertyConfigModel {
  static PropertyConfig fromJson(Map<String, dynamic> json) {
    return PropertyConfig(
      type: json['type'] as String,
      format: FieldFormat.fromJson(json['format'] as String),
      fieldName: json['fieldName'] as String,
      label: json['label'] as String,
      isMandatory: json['mandatory'] as bool? ?? false,
      validations: ((json['validations'] as List?) ?? [])
          .map((e) => ValidationConfigModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      enums: ((json['enums'] as List?) ?? [])
          .map((e) => EnumOptionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}