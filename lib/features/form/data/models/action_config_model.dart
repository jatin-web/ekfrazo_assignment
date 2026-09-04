import '../../domain/entities/action_config.dart';

class ActionConfigModel {
  /// Dispatches on `actionType` — same pattern as ScreenConfigModel
  /// (screenType) and BodyComponentModel (format): each branch reads
  /// only the `properties` keys that variant actually needs.
  static ActionConfig fromJson(Map<String, dynamic> json) {
    final actionType = json['actionType'] as String;
    final properties = (json['properties'] as Map<String, dynamic>?) ?? {};

    switch (actionType) {
      case 'SHOW_TOAST':
        return ShowToastAction(message: properties['message'] as String);
      case 'NAVIGATION':
        return NavigationAction(targetFlowName: properties['name'] as String);
      default:
        throw FormatException('Unknown actionType: "$actionType"');
    }
  }
}
