import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ekfrazo_assignment/features/form/domain/entities/screen_config.dart';
import '../bloc/flow_bloc.dart';
import '../bloc/flow_event.dart';
import '../bloc/flow_state.dart';
import '../widgets/template_node_widget.dart';

/// Renders a screenType: TEMPLATE — a static body plus an optional footer
/// (e.g. the success screens' card + "BACK TO FORM" button).
class TemplateScreenView extends StatelessWidget {
  const TemplateScreenView({super.key, required this.screen});

  final TemplateScreenConfig screen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlowBloc, FlowState>(
      builder: (context, state) {
        final bloc = context.read<FlowBloc>();

        return Scaffold(
          appBar: AppBar(
            title: Text(screen.heading),
            leading: state.canGoBackScreen
                ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => bloc.add(const BackScreenRequested()),
                  )
                : null,
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  for (final node in screen.body)
                    TemplateNodeWidget(
                      node: node,
                      formData: state.formData,
                      onButtonAction: (actions) =>
                          bloc.add(ButtonActionsRequested(actions)),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: screen.footer.isEmpty
              ? null
              : SafeArea(
                  minimum: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final node in screen.footer)
                        TemplateNodeWidget(
                          node: node,
                          formData: state.formData,
                          onButtonAction: (actions) =>
                              bloc.add(ButtonActionsRequested(actions)),
                        ),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
