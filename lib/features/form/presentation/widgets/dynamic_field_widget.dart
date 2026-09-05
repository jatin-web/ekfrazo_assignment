import 'package:flutter/material.dart';

import 'package:ekfrazo_assignment/features/form/domain/entities/property_config.dart';

/// Renders one form field from a [PropertyConfig] — textInput or dropdown —
/// the single place new `format` values need a matching widget branch.
class DynamicFieldWidget extends StatefulWidget {
  const DynamicFieldWidget({
    super.key,
    required this.config,
    required this.initialValue,
    required this.errorText,
    required this.onChanged,
  });

  final PropertyConfig config;
  final String? initialValue;
  final String? errorText;
  final ValueChanged<String> onChanged;

  @override
  State<DynamicFieldWidget> createState() => _DynamicFieldWidgetState();
}

class _DynamicFieldWidgetState extends State<DynamicFieldWidget> {
  late final TextEditingController _textController = TextEditingController(
    text: widget.initialValue,
  );

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final label = widget.config.isMandatory
        ? '${widget.config.label} *'
        : widget.config.label;

    switch (widget.config.format) {
      case FieldFormat.textInput:
        return TextFormField(
          controller: _textController,
          decoration: InputDecoration(labelText: label, errorText: widget.errorText),
          onChanged: widget.onChanged,
        );
      case FieldFormat.dropdown:
        final value = widget.initialValue;
        return DropdownButtonFormField<String>(
          initialValue: (value == null || value.isEmpty) ? null : value,
          decoration: InputDecoration(labelText: label, errorText: widget.errorText),
          items: [
            for (final option in widget.config.enums)
              DropdownMenuItem(value: option.code, child: Text(option.name)),
          ],
          onChanged: (selected) {
            if (selected != null) widget.onChanged(selected);
          },
        );
    }
  }
}
