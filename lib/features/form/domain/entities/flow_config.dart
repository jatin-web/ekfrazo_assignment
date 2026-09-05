import 'screen_config.dart';

/// The whole top-level JSON config: a named, versioned set of flows plus
/// which one to show first.
class FlowConfig {
  final String name;
  final bool active;
  final String initialPage;
  final List<ScreenConfig> flows;

  const FlowConfig({
    required this.name,
    required this.active,
    required this.initialPage,
    required this.flows,
  });

  ScreenConfig screenByName(String flowName) {
    return flows.firstWhere(
      (f) => f.name == flowName,
      orElse: () => throw StateError('No flow named "$flowName" in config'),
    );
  }
}