import 'package:ekfrazo_assignment/features/form/data/models/screen_config_model.dart';
import '../../domain/entities/flow_config.dart';

class FlowConfigModel {
  static FlowConfig fromJson(Map<String, dynamic> json) {
    return FlowConfig(
      name: json['name'] as String,
      active: json['active'] as bool? ?? true,
      initialPage: json['initialPage'] as String,
      flows: ((json['flows'] as List?) ?? [])
          .map((e) => ScreenConfigModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
