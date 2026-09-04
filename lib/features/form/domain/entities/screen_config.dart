import 'action_config.dart';
import 'template_node.dart';
import 'page_config.dart';

/// A single flow entry from the top-level `flows` array.
/// Sealed on `screenType` so ScreenRouter can switch exhaustively between
/// a paged form and a static template screen — the two only share a name
/// and a heading, everything else about how they render differs.
sealed class ScreenConfig {
  final String name;
  final String heading;
  const ScreenConfig({required this.name, required this.heading});
}

/// screenType: "FORM" — a sequence of pages, rendered one at a time.
class FormScreenConfig extends ScreenConfig {
  final List<PageConfig> pages;
  final List<ActionConfig> onSubmit;

  const FormScreenConfig({
    required super.name,
    required super.heading,
    required this.pages,
    required this.onSubmit,
  });

  /// Pages in `order`, so the engine never depends on JSON array order.
  List<PageConfig> get orderedPages =>
      [...pages]..sort((a, b) => a.order.compareTo(b.order));
}

/// screenType: "TEMPLATE" — a static body plus an optional footer.
class TemplateScreenConfig extends ScreenConfig {
  final List<TemplateNode> body;
  final List<TemplateNode> footer;

  const TemplateScreenConfig({
    required super.name,
    required super.heading,
    required this.body,
    this.footer = const [],
  });
}
