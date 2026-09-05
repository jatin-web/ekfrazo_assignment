import 'property_config.dart';

/// One page inside a FORM screen's `pages` array.
class PageConfig {
  final String page; // internal key
  final String label; 
  final int order;
  final String actionLabel; // "NEXT" | "SUBMIT"
  final List<PropertyConfig> properties;

  const PageConfig({
    required this.page,
    required this.label,
    required this.order,
    required this.actionLabel,
    required this.properties,
  });
}