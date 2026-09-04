
import 'action_config.dart';

/// A node inside a TEMPLATE screen's `body` OR `footer` — both are the
/// same shape, so this one hierarchy covers either. Renamed from
/// BodyComponent: "body" was misleading once it became clear footer
/// nodes (buttons, and in principle anything else) use it too.
///
/// Sealed so the presentation layer's widget factory gets an exhaustive
/// switch with no default case to forget.
sealed class TemplateNode {
  const TemplateNode();
}

/// format: "card" — a container with nested children.
class CardComponent extends TemplateNode {
  final List<TemplateNode> children;
  const CardComponent({required this.children});
}

/// format: "text" — one or more key/value lines of static/templated text.
class TextComponent extends TemplateNode {
  final List<MapEntry<String, String>> data; // key -> value (may hold {{field}})
  const TextComponent({required this.data});
}

/// format: "labelPairList" — key/value rows, values usually templated.
class LabelPairListComponent extends TemplateNode {
  final List<MapEntry<String, String>> data;
  const LabelPairListComponent({required this.data});
}

/// format: "button" — an action trigger. Appears in footer in every
/// current example, but nothing in the schema restricts it to footer.
class ButtonComponent extends TemplateNode {
  final String label;
  final List<ActionConfig> onAction;
  const ButtonComponent({required this.label, required this.onAction});
}