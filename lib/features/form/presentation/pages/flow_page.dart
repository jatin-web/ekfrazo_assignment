import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ekfrazo_assignment/features/form/domain/entities/screen_config.dart';
import '../bloc/flow_bloc.dart';
import '../bloc/flow_state.dart';
import 'form_screen_view.dart';
import 'template_screen_view.dart';

/// Root of the flow: reacts to [FlowBloc]'s state, dispatching on the
/// current screen's type into the matching view, and shows the one-shot
/// toast messages the bloc surfaces via [FlowState.toastId].
class FlowPage extends StatelessWidget {
  const FlowPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FlowBloc, FlowState>(
      listenWhen: (previous, current) => previous.toastId != current.toastId,
      listener: (context, state) {
        final message = state.toastMessage;
        if (message == null) return;
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.currentScreenName != current.currentScreenName ||
          previous.error != current.error,
      builder: (context, state) {
        if (state.status == FlowStatus.failure) {
          return Scaffold(
            body: Center(child: Text('Failed to load form: ${state.error}')),
          );
        }

        if (state.status == FlowStatus.loading) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final screen = state.currentScreen;
        return switch (screen) {
          FormScreenConfig() => FormScreenView(screen: screen),
          TemplateScreenConfig() => TemplateScreenView(screen: screen),
        };
      },
    );
  }
}
