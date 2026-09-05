# Stock Reports — Dynamic Multi-Page Form Renderer

A Flutter app that renders a multi-screen form entirely from a JSON config
(`lib/db/flow_config_json.dart`) — no screen, page, or field is hardcoded.

## Setup

```bash
flutter pub get
flutter run
```

Requires Flutter 3.44+ / Dart 3.12+ and a configured device (`flutter
devices` to list, `flutter run -d <id>` to target one). No backend or env
setup needed — the config is bundled locally.

Run `flutter analyze` to type-check after changes.

## Architecture

This project follows a modular, feature-based Clean Architecture: each
feature has its own `data`, `domain`, and `presentation` layer. Only one
feature — `form` — exists so far.

```
lib/
├── core/theme/          app-wide ThemeData
├── db/                  the given flow config JSON (stands in for a backend)
└── features/form/
    ├── domain/          entities + repository interface — pure Dart
    ├── data/             *Model.fromJson + repository impl
    └── presentation/
        ├── bloc/          FlowBloc — all flow state
        ├── pages/         FlowPage (router), FormScreenView, TemplateScreenView
        ├── widgets/       DynamicFieldWidget, TemplateNodeWidget
        └── utils/         ValidationEngine, TemplateResolver
```

#### Config → typed entities
Each model's `fromJson` reads one discriminator key (`screenType` / `format`
/ `actionType`) and returns the matching sealed subclass (e.g.
`FormScreenConfig` vs `TemplateScreenConfig`). Everything downstream
switches on typed entities, never raw JSON.

#### State
`FlowBloc` loads the config once, then owns everything: current screen,
page index, the shared `formData` map, and per-field errors. Every widget
just renders that state.

#### Rendering
`FlowPage` switches on the screen type: `FormScreenView` walks one page at
a time (progress bar only when there's >1 page); `TemplateScreenView`
recursively renders `TemplateNode`s for its body/footer (so a `card` can
nest a `labelPairList` or another `card`). `DynamicFieldWidget` switches on
`format` to pick `TextFormField` vs `DropdownButtonFormField`.

#### Validation
`ValidationEngine` is a `Map<type, validator>`; `FlowBloc` runs it for the
current page before allowing NEXT/SUBMIT.

#### Navigation
`FlowState.history` is a stack of screen names. Forward navigation pushes
the current screen — unless the target is already in history, in which
case history truncates back to that point (see [Assumptions](#assumptions)).

#### Templating
`TemplateResolver` replaces `{{field}}` placeholders against `formData`;
used by toasts, text nodes, and label/value pairs alike.

## Assumptions

**Scope**
- The JSON config is fixed and isn't extended with app-specific fields
  (e.g. no added "numeric" validation type) — anything it doesn't express
  is handled in code instead.
- Only `textInput`/`dropdown` formats and `required`/`minLength`
  validations are implemented (per the spec), each as a small registry so
  adding another is a one-line change, not a structural one.
- `SHOW_TOAST` and `NAVIGATION` are the only action types implemented,
  matching what the config uses; nothing is persisted beyond memory.
- No validation is added beyond what the config specifies (assumed to be
  backend-driven) — e.g. `quantity` accepts alphabets too, since the config
  attaches no numeric validation to it.

**Navigation & data**
- `fieldName`s are unique across the whole flow, not just per page, since
  all screens share one `formData` map keyed by name.
- A "back" button means the previous *distinct* screen, not literally the
  last one visited: navigating to a screen already in history pops back to
  it instead of pushing a duplicate, so a "BACK TO FORM" button doesn't
  trap the next back-arrow tap in a loop.
- Going back to a screen always re-enters it at its first page.

**Not implemented (out of scope)**
- Mobile-first: layout isn't tuned for wide/web viewports.
- No dependency injection / service locator (get_it, Riverpod, etc.) —
  dependencies are wired by hand in `main.dart`.
