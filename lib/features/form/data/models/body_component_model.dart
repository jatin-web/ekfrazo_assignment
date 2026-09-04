import '../../domain/entities/template_node.dart';
import 'action_config_model.dart';

class TemplateNodeModel {
  /// Dispatches on `format` — card/text/labelPairList/button — and
  /// recurses into `children` for nested cards. Renamed from
  /// BodyComponentModel to match the TemplateNode entity rename.
  static TemplateNode fromJson(Map<String, dynamic> json) {
    final format = json['format'] as String;
    switch (format) {
      case 'card':
        return CardComponent(
          children: ((json['children'] as List?) ?? [])
              .map((e) => TemplateNodeModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      case 'text':
        return TextComponent(data: _dataEntries(json));
      case 'labelPairList':
        return LabelPairListComponent(data: _dataEntries(json));
      case 'button':
        return ButtonComponent(
          label: json['label'] as String,
          onAction: ((json['onAction'] as List?) ?? [])
              .map((e) => ActionConfigModel.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      default:
        throw FormatException('Unknown template node format: "$format"');
    }
  }

  static List<MapEntry<String, String>> _dataEntries(
    Map<String, dynamic> json,
  ) {
    return ((json['data'] as List?) ?? [])
        .map(
          (e) => MapEntry(
            (e as Map<String, dynamic>)['key'] as String,
            e['value'] as String,
          ),
        )
        .toList();
  }
}
