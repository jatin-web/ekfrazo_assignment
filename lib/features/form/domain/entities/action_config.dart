/// One action from an `onSubmit` list or a button's `onAction` list.
/// Sealed so each variant only carries the field it actually needs —
/// a ShowToastAction can't be missing a message, and a NavigationAction
/// can't be missing a target, because there's no field to leave null.
sealed class ActionConfig {
  const ActionConfig();
}

/// actionType: "SHOW_TOAST"
class ShowToastAction extends ActionConfig {
  final String message; // may contain {{field}} placeholders, unresolved
  const ShowToastAction({required this.message});
}

/// actionType: "NAVIGATION"
class NavigationAction extends ActionConfig {
  final String targetFlowName;
  const NavigationAction({required this.targetFlowName});
}