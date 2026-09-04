import '../../domain/entities/screen_config.dart';
import 'action_config_model.dart';
import 'body_component_model.dart';
import 'page_config_model.dart';

class ScreenConfigModel {
  /// Dispatches on `screenType` — FORM vs TEMPLATE — into the matching
  /// sealed subclass. This is the one place that decision is made; every
  /// widget downstream just switches over the already-typed ScreenConfig.
  static ScreenConfig fromJson(Map<String, dynamic> json) {
    final screenType = json['screenType'] as String;
    switch (screenType) {
      case 'FORM':
        return FormScreenConfig(
          name: json['name'] as String,
          heading: json['heading'] as String,
          pages: ((json['pages'] as List?) ?? [])
              .map((e) => PageConfigModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          onSubmit: ((json['onSubmit'] as List?) ?? [])
              .map((e) => ActionConfigModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      case 'TEMPLATE':
        return TemplateScreenConfig(
          name: json['name'] as String,
          heading: json['heading'] as String,
          body: ((json['body'] as List?) ?? [])
              .map((e) => TemplateNodeModel.fromJson(e as Map<String, dynamic>))
              .toList(),
          footer: ((json['footer'] as List?) ?? [])
              .map((e) => TemplateNodeModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      default:
        throw FormatException('Unknown screenType: "$screenType"');
    }
  }
}
