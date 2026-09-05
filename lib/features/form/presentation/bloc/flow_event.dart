import 'package:ekfrazo_assignment/features/form/domain/entities/action_config.dart';

/// Every user/lifecycle input the flow reacts to. Sealed so FlowBloc's
/// `on<...>` handlers cover every case with no default branch to forget.
sealed class FlowEvent {
  const FlowEvent();
}

/// Fired once on startup to load the config and show the initial screen.
class FlowStarted extends FlowEvent {
  const FlowStarted();
}

/// A field's text/dropdown value changed.
class FieldChanged extends FlowEvent {
  const FieldChanged({required this.fieldName, required this.value});
  final String fieldName;
  final String value;
}

/// The page's action button (NEXT/SUBMIT label) was pressed.
class NextRequested extends FlowEvent {
  const NextRequested();
}

/// Back arrow pressed while on a page after the first in a FORM screen.
class PreviousPageRequested extends FlowEvent {
  const PreviousPageRequested();
}

/// Back arrow pressed on the first page of a screen — pops screen history.
class BackScreenRequested extends FlowEvent {
  const BackScreenRequested();
}

/// A TEMPLATE screen's footer/body button was pressed.
class ButtonActionsRequested extends FlowEvent {
  const ButtonActionsRequested(this.actions);
  final List<ActionConfig> actions;
}
