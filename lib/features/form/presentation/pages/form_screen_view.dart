import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ekfrazo_assignment/features/form/domain/entities/screen_config.dart';
import '../bloc/flow_bloc.dart';
import '../bloc/flow_event.dart';
import '../bloc/flow_state.dart';
import '../widgets/dynamic_field_widget.dart';

/// Renders a screenType: FORM — one page at a time, with page title,
/// "Page X of Y" progress, and a NEXT/SUBMIT action button.
class FormScreenView extends StatelessWidget {
  const FormScreenView({super.key, required this.screen});

  final FormScreenConfig screen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlowBloc, FlowState>(
      builder: (context, state) {
        final bloc = context.read<FlowBloc>();
        final pages = screen.orderedPages;
        final page = pages[state.currentPageIndex];
        final canGoBack = state.currentPageIndex > 0 || state.canGoBackScreen;

        return Scaffold(
          appBar: AppBar(
            title: Text(screen.heading),
            leading: canGoBack
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => bloc.add(
                      state.currentPageIndex > 0
                          ? const PreviousPageRequested()
                          : const BackScreenRequested(),
                    ),
                  )
                : null,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    page.label,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Page ${state.currentPageIndex + 1} of ${pages.length}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView(
                      children: [
                        for (final property in page.properties)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DynamicFieldWidget(
                              // Keyed by screen+page+field so Flutter never
                              // reuses one field's State (and TextEditingController)
                              // for a different field when the page changes.
                              key: ValueKey(
                                '${screen.name}_${page.page}_${property.fieldName}',
                              ),
                              config: property,
                              initialValue: state.formData[property.fieldName],
                              errorText: state.fieldErrors[property.fieldName],
                              onChanged: (value) => bloc.add(
                                FieldChanged(
                                  fieldName: property.fieldName,
                                  value: value,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => bloc.add(const NextRequested()),
                      child: Text(page.actionLabel),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
