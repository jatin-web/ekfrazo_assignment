import '../../domain/entities/enum_option.dart';

class EnumOptionModel {
  static EnumOption fromJson(Map<String, dynamic> json) {
    return EnumOption(
      code: json['code'] as String,
      name: json['name'] as String,
    );
  }
}