import 'package:flutter/material.dart';

import 'package:ekfrazo_assignment/features/form/domain/entities/action_config.dart';
import 'package:ekfrazo_assignment/features/form/domain/entities/template_node.dart';
import '../utils/template_resolver.dart';

/// Renders one [TemplateNode] — card / text / labelPairList / button —
/// recursing into card children. Used for both TEMPLATE body and footer.
class TemplateNodeWidget extends StatelessWidget {
  const TemplateNodeWidget({
    super.key,
    required this.node,
    required this.formData,
    required this.onButtonAction,
  });

  final TemplateNode node;
  final Map<String, String> formData;
  final ValueChanged<List<ActionConfig>> onButtonAction;

  @override
  Widget build(BuildContext context) {
    switch (node) {
      case CardComponent(:final children):
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final child in children)
                  TemplateNodeWidget(
                    node: child,
                    formData: formData,
                    onButtonAction: onButtonAction,
                  ),
              ],
            ),
          ),
        );

      case TextComponent(:final data):
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final entry in data)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  TemplateResolver.resolve(entry.value, formData),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
          ],
        );

      case LabelPairListComponent(:final data):
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final (index, entry) in data.indexed) ...[
              if (index > 0) const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entry.key,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        TemplateResolver.resolve(entry.value, formData),
                        textAlign: TextAlign.right,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        );

      case ButtonComponent(:final label, :final onAction):
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => onButtonAction(onAction),
              child: Text(label),
            ),
          ),
        );
    }
  }
}
