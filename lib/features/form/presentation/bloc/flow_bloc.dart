import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ekfrazo_assignment/features/form/domain/entities/action_config.dart';
import 'package:ekfrazo_assignment/features/form/domain/entities/screen_config.dart';
import 'package:ekfrazo_assignment/features/form/domain/repositories/form_repository.dart';
import '../utils/template_resolver.dart';
import '../utils/validation_engine.dart';
import 'flow_event.dart';
import 'flow_state.dart';

/// Owns the whole flow: loads the config, tracks which screen/page is
/// showing, and holds the single form-data map that survives navigation
/// in every direction (NEXT/SUBMIT, footer buttons, and back). All logic
/// here is pure state transition — side effects (SnackBars) are left to
/// the UI, which reacts to [FlowState.toastId] via a BlocListener.
class FlowBloc extends Bloc<FlowEvent, FlowState> {
  final FormRepository repository;

  FlowBloc({required this.repository}) : super(const FlowState()) {
    on<FlowStarted>(_onStarted);
    on<FieldChanged>(_onFieldChanged);
    on<NextRequested>(_onNextRequested);
    on<PreviousPageRequested>(_onPreviousPageRequested);
    on<BackScreenRequested>(_onBackScreenRequested);
    on<ButtonActionsRequested>(_onButtonActionsRequested);
  }

  Future<void> _onStarted(FlowStarted event, Emitter<FlowState> emit) async {
    try {
      final config = await repository.loadFlowConfig();
      emit(
        state.copyWith(
          status: FlowStatus.ready,
          config: config,
          currentScreenName: config.initialPage,
          clearError: true,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: FlowStatus.failure, error: e));
    }
  }

  void _onFieldChanged(FieldChanged event, Emitter<FlowState> emit) {
    // Update the form data
    final formData = {...state.formData, event.fieldName: event.value};

    // Check if the current field have any errors, if any, clear them -
    // because when a field value is changed, its error state should reset and should be validated again
    final fieldErrors = Map<String, String?>.from(state.fieldErrors);
    if (fieldErrors[event.fieldName] != null) {
      fieldErrors[event.fieldName] = null;
    }
    emit(state.copyWith(formData: formData, fieldErrors: fieldErrors));
  }

  /// Validates the current page; on success either advances to the next
  /// page or, once the last page in the screen is done, runs the screen's
  /// onSubmit actions. Whether a page is last is judged by its position in
  /// `pages`, not by its actionLabel text — the config uses "NEXT" as the
  /// label on some terminal pages too, so the label can't drive this.
  void _onNextRequested(NextRequested event, Emitter<FlowState> emit) {
    final screen = state.currentScreen;
    if (screen is! FormScreenConfig) return;

    // Get Current Page
    final pages = screen.orderedPages;
    final page = pages[state.currentPageIndex];

    // Map to store errors on current page
    final errors = <String, String?>{};

    // Boolean to store page validation status
    bool isValid = true;

    // Check if every property of page is validated, and have no errors
    for (final property in page.properties) {
      final value = state.formData[property.fieldName] ?? '';
      final error = ValidationEngine.validateField(value, property.validations);

      // Update the errors Map
      errors[property.fieldName] = error;
      if (error != null) isValid = false;
    }

    // If not valid, emit error state
    if (!isValid) {
      emit(state.copyWith(fieldErrors: errors));
      return;
    }

    // if current page is the last page of the screen, then move to next screen, otherwise increase page number
    final isLastPage = state.currentPageIndex == pages.length - 1;
    if (isLastPage) {
      emit(_runActions(screen.onSubmit, state));
    } else {
      emit(
        state.copyWith(
          currentPageIndex: state.currentPageIndex + 1,
          fieldErrors: const {},
        ),
      );
    }
  }

  void _onPreviousPageRequested(
    PreviousPageRequested event,
    Emitter<FlowState> emit,
  ) {
    // Only react(update the state) when there is a prev page on the same screen
    if (state.currentPageIndex > 0) {
      emit(
        state.copyWith(
          currentPageIndex: state.currentPageIndex - 1,
          fieldErrors: const {},
        ),
      );
    }
  }

  void _onBackScreenRequested(
    BackScreenRequested event,
    Emitter<FlowState> emit,
  ) {
    // If no prev screen, return
    if (state.history.isEmpty) return;

    // Access the screen history and update the currentScreenName, after popping the last screen
    final screenHistory = [...state.history];
    final previousScreen = screenHistory.removeLast();
    emit(
      state.copyWith(
        currentScreenName: previousScreen,
        history: screenHistory,
        currentPageIndex: 0,
        fieldErrors: const {},
      ),
    );
  }

  void _onButtonActionsRequested(
    ButtonActionsRequested event,
    Emitter<FlowState> emit,
  ) {
    emit(_runActions(event.actions, state));
  }

  /// Applies `onSubmit` / `onAction` lists to [fromState], resolving
  /// `{{field}}` templates and following NAVIGATION targets. Shared by
  /// form submission and template footer buttons.
  FlowState _runActions(List<ActionConfig> actions, FlowState fromState) {
    var nextState = fromState;
    for (final action in actions) {
      switch (action) {
        case ShowToastAction():
          final message = TemplateResolver.resolve(
            action.message,
            nextState.formData,
          );
          nextState = nextState.copyWith(
            toastMessage: message,
            toastId: nextState.toastId + 1,
          );
        case NavigationAction():
          // If the target is already on the history stack (e.g. a
          // "BACK TO FORM" style button returning to a screen the user
          // passed through earlier), pop back to it instead of pushing a
          // duplicate entry — otherwise the screen's own back button would
          // just bounce forward again to where we came from.
          final existingIndex = nextState.history.indexOf(
            action.targetFlowName,
          );
          final newHistory = existingIndex != -1
              ? nextState.history.sublist(0, existingIndex)
              : [...nextState.history, nextState.currentScreenName!];
          nextState = nextState.copyWith(
            currentScreenName: action.targetFlowName,
            history: newHistory,
            currentPageIndex: 0,
            fieldErrors: const {},
          );
      }
    }
    return nextState;
  }
}
