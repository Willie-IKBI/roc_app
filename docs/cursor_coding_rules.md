# IKBI / ROC - Cursor Coding Rules (Flutter, Riverpod, Supabase, Material 3)

## 0) Golden Principles

- Single source of truth per concern (state -> Riverpod providers; data -> repositories).
- Clean architecture: UI <-> State (controllers/providers) <-> Domain (models/use-cases) <-> Data (repos/clients).
- No direct Supabase calls in Widgets. UI only talks to a controller/provider which calls a repository.
- Immutable models (Freezed + json_serializable), pure functions, typed errors.
- Material 3 theming everywhere; no inline colors - use Theme and tokens.
- Small PRs, strong typing, zero TODOs in main branch.
- Every feature ships with tests (unit for repo/logic, widget test for important screens).

## 1) Project Structure (feature-first, clean)

```
lib/
  core/
    config/            # env, constants, flavors
    routing/           # go_router routes & guards
    theme/             # material3 theme, color scheme, tokens
    utils/             # pure utils, formatters, result types
    logging/           # logger & error reporting adapters
  data/
    clients/           # supabase client wrappers, http clients
    repositories/      # impls: ClaimRepositorySupabase, etc.
  domain/
    models/            # Freezed entities + DTOs
    value_objects/     # non-trivial validated types
    usecases/          # optional: interactor/services
  features/
    <feature_name>/
      presentation/    # screens, widgets (stateless/stateful)
      controller/      # Riverpod Notifiers/Providers
      data/            # feature-local repos if needed
      domain/          # feature-local models/usecases
  app.dart
  main.dart
  test/
```

Cursor rule: when adding a new screen/feature, generate the four folders above with stubs plus tests.

## 2) State Management (Riverpod)

- Prefer AsyncNotifier or Notifier with @Riverpod generator (riverpod_annotation).
- UI subscribes to selectors (derived providers) to minimize rebuilds.
- No business logic in Widgets. Widgets only:
  - read provider state (`ref.watch`)
  - dispatch intents (`ref.read(controller.notifier).action()`)

Asynchronous pattern:

```
@riverpod
class ClaimDetailController extends AsyncNotifier<ClaimDetailState> {
  @override
  Future<ClaimDetailState> build() async => repo.load(claimId);

  Future<void> addContactAttempt(ContactAttempt input) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.addAttempt(claimId, input)
        .then((_) => repo.load(claimId)));
  }
}
```

Cursor rule: never call `setState` for domain mutations; use controller methods.

## 3) Data & Repositories (Supabase)

- Repository interface in domain, implementation in `data/repositories`.
- No UI-layer Supabase imports.
- CRUD methods return `Result<T, DomainError>` or `Either<DomainError, T>`.

Result type example:

```
sealed class DomainError { const DomainError(); }
class NetworkError extends DomainError {}
class AuthError extends DomainError { final String code; AuthError(this.code); }
class NotFound extends DomainError {}

class Result<T> {
  final T? data;
  final DomainError? error;

  const Result.ok(this.data) : error = null;
  const Result.err(this.error) : data = null;

  bool get isOk => error == null;
}
```

Supabase usage:

- Use Row Level Security (RLS); all queries must include tenant scoping on the server side.
- Use `from('table').select()` with typed DTOs, map to domain models.
- Prefer Edge Functions for multi-step mutations or when secrets/validation required.
- Handle auth session refresh centrally in `core/data/clients/supabase_client.dart`.

Cursor rule: when writing a repository method, also write (1) a unit test (mock Supabase client) and (2) an error path test (for example 401/forbidden, 404).

## 4) Models & Serialization

- Freezed for immutability/equality/copyWith.
- `json_serializable` for DTO <-> JSON; keep DTOs distinct from domain when needed.
- Validate value objects (for example `PhoneNumber`, `ClaimNumber`) at the edges.

Cursor rule: every new model -> generate Freezed plus JSON boilerplate plus tests for (de)serialization.

## 5) UI & Material 3

- Centralize color/typography/shape in `core/theme/` (M3).
- Use `Theme.of(context).colorScheme`; no hex codes in widgets.
- Responsive first: use `LayoutBuilder`/breakpoints for mobile/web.
- Accessibility: minimum tap targets 48dp, contrast AA, semantics labels on icons.

Components:

- Buttons: `FilledButton` (primary), `OutlinedButton` (secondary), `TextButton` (tertiary).
- Inputs: `TextField` with validators (reactive_forms or formz recommended for complex cases).
- Lists: `ListView.builder` with `SliverAppBar` for long lists; pagination for large datasets.

Cursor rule: when adding a widget with custom color, first add a semantic token to theme, then use it.

## 5.1) Glassmorphism Design System

The app uses a dark glassmorphism design system with both light and dark theme support.

### Design Tokens

- Always use `DesignTokens` helper methods for theme-aware colors:
  ```dart
  DesignTokens.glassBase(Theme.of(context).brightness)
  DesignTokens.textPrimary(Theme.of(context).brightness)
  ```
- Use spacing tokens: `DesignTokens.spaceXS` through `DesignTokens.spaceXL`
- Use radius tokens: `DesignTokens.radiusSmall`, `radiusMedium`, `radiusLarge`, `radiusPill`
- Blur values are optimized for performance (10-15px range)

### Glass Components

Use glass components from `core/widgets/`:

- **GlassCard**: For content containers with backdrop blur
- **GlassButton**: Primary, secondary, ghost, and outlined variants (all rounded-full)
- **GlassInput**: Text fields with glass styling
- **GlassBadge**: Status indicators with transparent backgrounds
- **GlassContainer**: General-purpose glass surfaces
- **GlassDialog**: Dialogs with glass styling
- **GlassNavBar**: Floating navigation with pill-shaped tabs

### Best Practices

- All glass surfaces use `BackdropFilter` with optimized blur (sigma 10-15)
- All cards use `rounded-3xl` (24px) border radius
- All buttons use `rounded-full` (pill shape)
- Navigation uses floating design with margins from edges
- Use `RepaintBoundary` for glass components in lists (already included in components)
- Always provide `semanticLabel` for icon-only buttons

### Performance

- Blur values are optimized to 12px (reduced from 24px for performance)
- `RepaintBoundary` is used in all glass components
- For lower-end devices, consider using `PerformanceUtils.getOptimizedBlur()` if needed

Cursor rule: when creating new UI, use glass components instead of Material widgets. Always use design tokens, never hardcode colors or spacing.

## 6) Navigation (GoRouter)

- Typed routes with names and nested shells.
- Guards: auth gate; redirect if no profile or inactive.
- All route paths live in `core/routing/app_router.dart`.

Cursor rule: new screens must be registered in GoRouter with a named route plus deep link path.

## 7) Forms & Validation

- Simple forms: inline validators.
- Complex, multi-step: controller-managed state plus reactive_forms or formz.
- Always trim and normalize inputs (phone, email, claim number) in controller layer.

Cursor rule: form submit must (1) validate, (2) show progress, (3) handle `Result.err` with user-friendly error from `DomainError` -> UI message.

## 8) Error Handling & UX

- Convert infra errors to `DomainError` in repositories.
- Map `DomainError` to snackbars/banners/dialogs in UI.
- Non-blocking operations -> show linear progress/loading overlay.

Cursor rule: never show raw exceptions; always show mapped, human-readable messages.

## 9) Auth, Roles, RLS

- Supabase Auth with profiles table.
- On login, fetch profile plus role; store in a provider (`currentUserProvider`).
- UI guards hide admin features for non-admins.
- RLS on every table: `tenant_id = auth.jwt().tenant_id` (or claim method you use); implement soft deletes if needed.

Cursor rule: any feature touching PII must verify RLS coverage in schema comments.

## 10) Environment & Secrets

- No secrets in code. Use `--dart-define` or `.env` (Flutter flavors).
- Split dev/staging/prod Supabase projects; never point dev to prod.

Cursor rule: when adding a new config, touch `core/config/` and wire via constructor DI or providers.

## 11) Logging, Analytics, Monitoring

- Logger wrapper in `core/logging` with levels.
- Log: navigation events (debug), API failures (warn/error), auth changes (info).
- Optional: Sentry integration (errors plus performance).

Cursor rule: repository catches -> log error (once) -> return `Result.err`.

## 12) Testing (must-have)

- Unit tests for repositories and controllers (AsyncNotifier).
- Widget tests for critical screens (login, capture claim, claim detail).
- Golden tests for stable UI components when feasible.

Cursor rule: for each new repo/controller, generate
- happy path test,
- error path test,
- serialization test for models.

## 13) Performance

- Use `select(columns)` to fetch only required fields.
- Paginate long lists; do not stream unbounded tables.
- Memoize derived providers; use `ref.keepAlive()` only when justified.
- Avoid rebuilding heavy widgets - factor into smaller widgets with `const` where possible.

## 14) Accessibility & i18n

- All icons with `semanticLabel`.
- Large touch targets, focus traversal on web.
- Prepare for i18n by keeping strings centralized (even if only English initially).

## 15) CI/CD & Migrations

- Supabase migrations in repo (`supabase/migrations/`), reviewed in PRs.
- GitHub Actions should run `flutter analyze`, `flutter test`, formatting check.
- Build web preview (if applicable) on staging branch.

Cursor rule: when schema changes, update DTOs, Repos, Mock data, Tests, and `docs/CHANGELOG.md`.

## 16) Git Hygiene

- Conventional commits: `feat:`, `fix:`, `refactor:`, `chore:`, `test:`, `docs:`.
- One feature per PR; include screenshots or terminal output for UX/CLI work.
- Keep PR description: Context -> Changes -> How to test -> Risks.

## 17) Security Checklist (every feature)

- [ ] RLS policy confirmed for all new tables
- [ ] Inputs validated/sanitized
- [ ] Errors do not leak internals
- [ ] No secrets in code
- [ ] Least-privilege role usage (service role only in server contexts/edge functions)

## 18) Cursor Behavior Contract (How AI should work)

Before generating code, Cursor must:

1. Read `/docs/cursor_coding_rules.md`, `/core/theme/`, `/core/routing/` to align with architecture and theme.
2. Confirm file paths it will create/modify (feature-first structure).
3. Generate tests alongside code.
4. Use Riverpod controllers plus repositories (no Supabase in Widgets).
5. Use Material 3 theme tokens (no hardcoded colors).

When uncertain, Cursor should:

- Ask for model or schema snippets (tables, columns, enums).
- Propose two options with trade-offs; pick one and proceed.
- Produce compilable code with imports resolved.

Output expectations:

- Code blocks are complete, not fragments.
- Include brief usage example and test stubs.
- Add a post-generation checklist (for example `Run: flutter pub run build_runner build`).

Anti-patterns Cursor must avoid:

- Direct Supabase calls in UI
- Business logic in Widgets
- Untyped `dynamic` or `Map<String, dynamic>` escaping domain
- Missing tests
- Inline colors/spacing outside theme/tokens
- Creating parallel architectures (stick to this guide)

## 19) Material 3 Theme Tokens (example names)

- `brandPrimary`, `brandOnPrimary`, `brandSurface`, `brandOnSurface`
- `warning`, `onWarning`, `success`, `onSuccess`
- Spacing: `spaceXS = 4`, `spaceS = 8`, `spaceM = 16`, `spaceL = 24`, `spaceXL = 32`
- Radius: `radius = 12`, `radiusLarge = 16`
- Elevation: `elev1` .. `elev5`

Cursor rule: add tokens to `core/theme/tokens.dart` then consume in components.

## 20) Feature Definition Template (Cursor prompt)

Create feature `claims/claim_capture` with:

- `ClaimCaptureScreen`, `ClaimCaptureController` (AsyncNotifier), tests
- `ClaimRepository` interface plus Supabase implementation
- Freezed models: `Claim`, `ClaimItem`
- Form validation (name, phone, insurer, claim number, at least one item)
- Repo method `createClaim()` returns `Result<Claim, DomainError>`

Follow the coding rules: no Supabase in UI, Material 3, add route, and write tests.

