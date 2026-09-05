import 'package:equatable/equatable.dart';

import 'package:ekfrazo_assignment/features/form/domain/entities/flow_config.dart';
import 'package:ekfrazo_assignment/features/form/domain/entities/screen_config.dart';

enum FlowStatus { loading, ready, failure }

/// The whole flow's state: which screen/page is showing, the single form
/// data map shared across every screen, and the current page's errors.
class FlowState extends Equatable {
  const FlowState({
    this.status = FlowStatus.loading,
    this.config,
    this.error,
    this.currentScreenName,
    this.history = const [],
    this.formData = const {},
    this.fieldErrors = const {},
    this.currentPageIndex = 0,
    this.toastMessage,
    this.toastId = 0,
  });

  final FlowStatus status;
  final FlowConfig? config;
  final Object? error;
  final String? currentScreenName;

  /// Screen names visited, oldest first — popped by BackScreenRequested.
  final List<String> history;

  /// fieldName -> entered value, shared by every screen in the flow.
  final Map<String, String> formData;

  /// fieldName -> current validation error for the page on screen.
  final Map<String, String?> fieldErrors;

  final int currentPageIndex;

  /// Set alongside [toastId] so the UI can show it exactly once via a
  /// BlocListener gated on `toastId` changing, even for a repeated message.
  final String? toastMessage;
  final int toastId;

  ScreenConfig get currentScreen => config!.screenByName(currentScreenName!);

  bool get canGoBackScreen => history.isNotEmpty;

  FlowState copyWith({
    FlowStatus? status,
    FlowConfig? config,
    Object? error,
    bool clearError = false,
    String? currentScreenName,
    List<String>? history,
    Map<String, String>? formData,
    Map<String, String?>? fieldErrors,
    int? currentPageIndex,
    String? toastMessage,
    int? toastId,
  }) {
    return FlowState(
      status: status ?? this.status,
      config: config ?? this.config,
      error: clearError ? null : (error ?? this.error),
      currentScreenName: currentScreenName ?? this.currentScreenName,
      history: history ?? this.history,
      formData: formData ?? this.formData,
      fieldErrors: fieldErrors ?? this.fieldErrors,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      toastMessage: toastMessage ?? this.toastMessage,
      toastId: toastId ?? this.toastId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    config,
    error,
    currentScreenName,
    history,
    formData,
    fieldErrors,
    currentPageIndex,
    toastMessage,
    toastId,
  ];
}
