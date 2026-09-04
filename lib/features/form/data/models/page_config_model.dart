import '../../domain/entities/page_config.dart';
import 'property_config_model.dart';

class PageConfigModel {
  static PageConfig fromJson(Map<String, dynamic> json) {
    return PageConfig(
      page: json['page'] as String,
      label: json['label'] as String,
      order: json['order'] as int,
      actionLabel: json['actionLabel'] as String,
      properties: ((json['properties'] as List?) ?? [])
          .map((e) => PropertyConfigModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
