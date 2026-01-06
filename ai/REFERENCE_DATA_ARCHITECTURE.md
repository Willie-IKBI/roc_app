# Reference Data Providers - Vertical Slice Architecture

**Status:** Build Plan  
**Target:** Standardize reference data access pattern across ROC  
**Scope:** Insurers, Service Providers, Brands, Estates

---

## 1. Folder/File Structure

```
lib/
  domain/
    models/
      reference_option.dart          # NEW: Shared model for simple id/label pairs
    repositories/
      reference_data_repository.dart # NEW: Interface for reference data queries
  data/
    repositories/
      reference_data_repository_supabase.dart  # NEW: Implementation
  features/
    reference_data/                 # NEW: Feature folder
      controller/
        reference_data_controller.dart          # NEW: Riverpod controller
      domain/
        models/
          reference_option.dart      # Re-export from domain (or move here)
```

**Rationale:**
- Feature-first structure aligns with `cursor_coding_rules.md`
- Shared `ReferenceOption` model in domain (used by multiple features)
- Repository interface in domain, implementation in data layer
- Controller in feature folder (UI-facing)

---

## 2. Repository Interface + Method Signatures

### `lib/domain/repositories/reference_data_repository.dart`

```dart
import '../models/reference_option.dart';
import '../../core/utils/result.dart';

/// Repository for read-only reference data (lookups, dropdowns, etc.)
/// All methods return lightweight ReferenceOption models for UI consumption.
abstract class ReferenceDataRepository {
  /// Fetch all insurers as reference options (id + name)
  /// Returns empty list if no insurers found (not an error).
  Future<Result<List<ReferenceOption>>> fetchInsurerOptions();

  /// Fetch all service providers as reference options (id + company_name)
  /// Returns empty list if no providers found (not an error).
  Future<Result<List<ReferenceOption>>> fetchServiceProviderOptions();

  /// Fetch all brands as reference options (id + name)
  /// Returns empty list if no brands found (not an error).
  Future<Result<List<ReferenceOption>>> fetchBrandOptions();

  /// Fetch all estates as reference options (id + formatted label)
  /// Returns empty list if no estates found (not an error).
  /// Note: Estate labels include suburb/city for disambiguation.
  Future<Result<List<ReferenceOption>>> fetchEstateOptions();
}
```

**Design decisions:**
- All methods return `Result<List<ReferenceOption>>` for consistency
- Empty list is OK (not an error) - reference data may legitimately be empty
- No tenant_id parameter (resolved from current user context in data source)
- Lightweight models (id + label only) for UI dropdowns

---

## 3. Data Source Methods + Supabase Queries

### `lib/data/repositories/reference_data_repository_supabase.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show PostgrestException;

import '../../../core/errors/domain_error.dart';
import '../../../core/logging/logger.dart';
import '../../../core/utils/result.dart';
import '../../../domain/models/reference_option.dart';
import '../../../domain/repositories/reference_data_repository.dart';
import '../../clients/supabase_client.dart';
import '../../datasources/supabase_insurer_admin_remote_data_source.dart';
import '../../datasources/supabase_brand_admin_remote_data_source.dart';
import '../../datasources/supabase_service_provider_admin_remote_data_source.dart';
import '../../repositories/estate_repository.dart';

final referenceDataRepositoryProvider = Provider<ReferenceDataRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  final insurerDs = ref.watch(insurerAdminRemoteDataSourceProvider);
  final brandDs = ref.watch(brandAdminRemoteDataSourceProvider);
  final serviceProviderDs = ref.watch(serviceProviderAdminRemoteDataSourceProvider);
  final estateRepo = ref.watch(estateRepositoryProvider);
  return ReferenceDataRepositorySupabase(
    client: client,
    insurerDataSource: insurerDs,
    brandDataSource: brandDs,
    serviceProviderDataSource: serviceProviderDs,
    estateRepository: estateRepo,
  );
});

class ReferenceDataRepositorySupabase implements ReferenceDataRepository {
  ReferenceDataRepositorySupabase({
    required SupabaseClient client,
    required InsurerAdminRemoteDataSource insurerDataSource,
    required BrandAdminRemoteDataSource brandDataSource,
    required ServiceProviderAdminRemoteDataSource serviceProviderDataSource,
    required EstateRepository estateRepository,
  })  : _client = client,
        _insurerDataSource = insurerDataSource,
        _brandDataSource = brandDataSource,
        _serviceProviderDataSource = serviceProviderDataSource,
        _estateRepository = estateRepository;

  final SupabaseClient _client;
  final InsurerAdminRemoteDataSource _insurerDataSource;
  final BrandAdminRemoteDataSource _brandDataSource;
  final ServiceProviderAdminRemoteDataSource _serviceProviderDataSource;
  final EstateRepository _estateRepository;

  @override
  Future<Result<List<ReferenceOption>>> fetchInsurerOptions() async {
    try {
      // Query: SELECT id, name FROM insurers ORDER BY name
      // RLS enforces tenant_id filtering automatically
      final response = await _client
          .from('insurers')
          .select('id, name')
          .order('name');

      final rows = (response as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((row) => ReferenceOption(
                id: row['id'] as String,
                label: row['name'] as String,
              ))
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch insurer options',
        name: 'ReferenceDataRepository',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching insurer options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ReferenceOption>>> fetchServiceProviderOptions() async {
    try {
      // Query: SELECT id, company_name FROM service_providers ORDER BY company_name
      // RLS enforces tenant_id filtering automatically
      final response = await _client
          .from('service_providers')
          .select('id, company_name')
          .order('company_name');

      final rows = (response as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((row) => ReferenceOption(
                id: row['id'] as String,
                label: row['company_name'] as String,
              ))
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch service provider options',
        name: 'ReferenceDataRepository',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching service provider options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ReferenceOption>>> fetchBrandOptions() async {
    try {
      // Query: SELECT id, name FROM brands ORDER BY name
      // RLS enforces tenant_id filtering automatically
      final response = await _client
          .from('brands')
          .select('id, name')
          .order('name');

      final rows = (response as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((row) => ReferenceOption(
                id: row['id'] as String,
                label: row['name'] as String,
              ))
          .toList(growable: false);

      return Result.ok(rows);
    } on PostgrestException catch (err) {
      AppLogger.error(
        'Failed to fetch brand options',
        name: 'ReferenceDataRepository',
        error: err,
      );
      return Result.err(mapPostgrestException(err));
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching brand options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  @override
  Future<Result<List<ReferenceOption>>> fetchEstateOptions() async {
    try {
      // Reuse existing EstateRepository (already follows pattern)
      // Query handled by EstateRepository.fetchEstates()
      // Returns estates with formatted labels (name, suburb, city)
      final tenantId = await _resolveTenantId();
      if (tenantId == null) {
        return Result.err(
          const AuthError(code: 'not-authenticated', detail: 'No tenant context'),
        );
      }

      final result = await _estateRepository.fetchEstates(tenantId: tenantId);
      if (result.isErr) {
        return Result.err(result.error);
      }

      final options = result.data
          .map((estate) {
            // Format label: "Name, Suburb, City" (same logic as EstateOption.label)
            final parts = <String>[
              estate.name,
              if (estate.suburb?.trim().isNotEmpty ?? false) estate.suburb!,
              if (estate.city?.trim().isNotEmpty ?? false) estate.city!,
            ];
            final label = parts.where((p) => p.trim().isNotEmpty).join(', ');

            return ReferenceOption(
              id: estate.id,
              label: label,
            );
          })
          .toList(growable: false);

      return Result.ok(options);
    } catch (err, stackTrace) {
      AppLogger.error(
        'Unexpected error fetching estate options',
        name: 'ReferenceDataRepository',
        error: err,
        stackTrace: stackTrace,
      );
      return Result.err(UnknownError(err));
    }
  }

  /// Resolve tenant_id from current user context
  /// Returns null if user not authenticated or profile missing
  Future<String?> _resolveTenantId() async {
    try {
      final user = _client.auth.currentUser;
      if (user == null) return null;

      final profile = await _client
          .from('profiles')
          .select('tenant_id')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) return null;
      return (profile as Map<String, dynamic>)['tenant_id'] as String?;
    } catch (_) {
      return null;
    }
  }
}
```

**Query specifications:**
- **Insurers:** `SELECT id, name FROM insurers ORDER BY name` (RLS filters tenant_id)
- **Service Providers:** `SELECT id, company_name FROM service_providers ORDER BY company_name` (RLS filters tenant_id)
- **Brands:** `SELECT id, name FROM brands ORDER BY name` (RLS filters tenant_id)
- **Estates:** Reuse `EstateRepository.fetchEstates()` (already correct pattern)

**Error handling:**
- All methods catch `PostgrestException` → map to `DomainError`
- All methods catch generic exceptions → `UnknownError`
- All errors logged via `AppLogger.error()` with context
- No silent failures - errors propagate as `Result.err()`

---

## 4. Provider/Controller Pattern

### `lib/features/reference_data/controller/reference_data_controller.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/utils/result.dart';
import '../../../domain/models/reference_option.dart';
import '../../../data/repositories/reference_data_repository_supabase.dart';

part 'reference_data_controller.g.dart';

/// Provider for insurer options (id + name)
/// Returns AsyncValue<List<ReferenceOption>> for UI consumption.
/// Errors are surfaced as AsyncError (no silent failures).
@riverpod
Future<List<ReferenceOption>> insurerOptions(InsurerOptionsRef ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchInsurerOptions();
  
  if (result.isErr) {
    // Surface error to UI - AsyncValue will be AsyncError
    throw result.error;
  }
  
  return result.data;
}

/// Provider for service provider options (id + company_name)
@riverpod
Future<List<ReferenceOption>> serviceProviderOptions(ServiceProviderOptionsRef ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchServiceProviderOptions();
  
  if (result.isErr) {
    throw result.error;
  }
  
  return result.data;
}

/// Provider for brand options (id + name)
@riverpod
Future<List<ReferenceOption>> brandOptions(BrandOptionsRef ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchBrandOptions();
  
  if (result.isErr) {
    throw result.error;
  }
  
  return result.data;
}

/// Provider for estate options (id + formatted label)
@riverpod
Future<List<ReferenceOption>> estateOptions(EstateOptionsRef ref) async {
  final repository = ref.watch(referenceDataRepositoryProvider);
  final result = await repository.fetchEstateOptions();
  
  if (result.isErr) {
    throw result.error;
  }
  
  return result.data;
}
```

**Pattern:**
- Use `@riverpod` generator (aligns with `cursor_coding_rules.md`)
- Auto-dispose by default (reference data is lightweight, can be re-fetched)
- Errors thrown → `AsyncValue` becomes `AsyncError` (UI can handle)
- No silent failures - errors always propagate

**Usage in UI:**
```dart
final insurersAsync = ref.watch(insurerOptionsProvider);

insurersAsync.when(
  data: (options) => DropdownButton(items: options.map(...)),
  loading: () => CircularProgressIndicator(),
  error: (err, stack) => ErrorWidget(err), // Error visible to user
);
```

---

## 5. Error Handling Standard + Retry Guidance

### Error Handling Rules

1. **No Silent Failures**
   - Never return empty list on error
   - Never catch and ignore exceptions
   - Always propagate errors via `Result.err()` or `throw`

2. **Error Logging**
   - Log all errors via `AppLogger.error()` with:
     - Descriptive message
     - Error object
     - Stack trace (if available)
     - Context (table name, operation)

3. **Error Mapping**
   - `PostgrestException` → `mapPostgrestException()` → `DomainError`
   - Generic exceptions → `UnknownError`
   - Auth errors → `AuthError(code: 'not-authenticated')`

4. **UI Error Handling**
   - `AsyncValue` automatically surfaces errors as `AsyncError`
   - UI must handle `error` case (show message, retry button, etc.)
   - Never show empty state when error occurred

### Retry Guidance

**When to Retry:**
- Network errors (timeout, connection refused)
- Transient database errors (connection pool exhausted)
- Rate limiting (429 responses)

**When NOT to Retry:**
- Authentication errors (401, 403) - user must re-authenticate
- Not found (404) - data doesn't exist
- Validation errors (400) - invalid request
- RLS policy violations - user lacks permission

**Retry Pattern (Optional - for critical reference data):**
```dart
Future<Result<List<ReferenceOption>>> fetchInsurerOptionsWithRetry({
  int maxRetries = 2,
  Duration delay = const Duration(seconds: 1),
}) async {
  int attempts = 0;
  while (attempts <= maxRetries) {
    final result = await fetchInsurerOptions();
    if (result.isOk) return result;
    
    // Don't retry on auth/validation errors
    if (result.error is AuthError || result.error is ValidationError) {
      return result;
    }
    
    attempts++;
    if (attempts <= maxRetries) {
      await Future.delayed(delay * attempts); // Exponential backoff
    }
  }
  return result;
}
```

**Recommendation:** Start without retry logic. Add only if production shows transient failures.

---

## 6. Migration Checklist

### Files to Create

- [ ] `lib/domain/models/reference_option.dart` - Shared model
- [ ] `lib/domain/repositories/reference_data_repository.dart` - Interface
- [ ] `lib/data/repositories/reference_data_repository_supabase.dart` - Implementation
- [ ] `lib/features/reference_data/controller/reference_data_controller.dart` - Providers

### Files to Replace

#### 1. `lib/features/claims/controller/reference_data_providers.dart`

**Current state:**
- `insurersOptionsProvider` - Direct Supabase call (❌ violation)
- `brandsOptionsProvider` - Direct Supabase call (❌ violation)
- `estatesOptionsProvider` - Uses repository (✅ correct)

**Migration steps:**
1. Replace `insurersOptionsProvider`:
   ```dart
   // OLD:
   final insurersOptionsProvider = FutureProvider.autoDispose<List<ReferenceOption>>((ref) async {
     final client = ref.read(supabaseClientProvider);
     final rows = await client.from('insurers').select('id, name').order('name') as List<dynamic>;
     // ...
   });
   
   // NEW:
   import '../../reference_data/controller/reference_data_controller.dart';
   // Use: ref.watch(insurerOptionsProvider)
   ```

2. Replace `brandsOptionsProvider`:
   ```dart
   // OLD:
   final brandsOptionsProvider = FutureProvider.autoDispose<List<BrandOption>>((ref) async {
     final client = ref.read(supabaseClientProvider);
     final rows = await client.from('brands').select('id, name').order('name') as List<dynamic>;
     // ...
   });
   
   // NEW:
   import '../../reference_data/controller/reference_data_controller.dart';
   // Use: ref.watch(brandOptionsProvider)
   // Note: BrandOption → ReferenceOption (unified model)
   ```

3. Update `estatesOptionsProvider`:
   ```dart
   // OLD:
   final estatesOptionsProvider = FutureProvider.autoDispose<List<EstateOption>>((ref) async {
     final profile = ref.watch(currentUserProvider).asData?.value;
     if (profile == null) return const [];
     final repository = ref.watch(estateRepositoryProvider);
     final result = await repository.fetchEstates(tenantId: profile.tenantId);
     if (result.isErr) throw result.error;
     return result.data.map((estate) => EstateOption(...)).toList();
   });
   
   // NEW:
   import '../../reference_data/controller/reference_data_controller.dart';
   // Use: ref.watch(estateOptionsProvider)
   // Note: EstateOption → ReferenceOption (unified model)
   ```

4. **Delete file** after migration complete (providers moved to `reference_data_controller.dart`)

### Files to Update (Callers)

#### Search for usages:
```bash
# Find all references to old providers
grep -r "insurersOptionsProvider" lib/
grep -r "brandsOptionsProvider" lib/
grep -r "estatesOptionsProvider" lib/
grep -r "EstateOption" lib/
grep -r "BrandOption" lib/
grep -r "ReferenceOption" lib/
```

#### Expected callers (from codebase scan):

1. **`lib/features/claims/presentation/capture_claim_screen.dart`**
   - Uses: `insurersOptionsProvider`, `brandsOptionsProvider`, `estatesOptionsProvider`
   - **Update:** Import from `reference_data_controller.dart`
   - **Change:** `BrandOption` → `ReferenceOption` (if type used)

2. **`lib/features/claims/presentation/claim_detail_screen.dart`**
   - May use reference data for display
   - **Update:** Import from `reference_data_controller.dart`

3. **Any admin screens using reference data**
   - **Update:** Import from `reference_data_controller.dart`

### Model Migration

**Old models (delete after migration):**
- `EstateOption` (in `reference_data_providers.dart`) → `ReferenceOption`
- `BrandOption` (in `reference_data_providers.dart`) → `ReferenceOption`
- `ReferenceOption` (in `reference_data_providers.dart`) → Move to `domain/models/`

**New unified model:**
```dart
// lib/domain/models/reference_option.dart
@immutable
class ReferenceOption {
  const ReferenceOption({required this.id, required this.label});

  final String id;
  final String label;
}
```

**Migration impact:**
- `EstateOption.label` getter → `ReferenceOption.label` (direct field)
- `BrandOption.name` → `ReferenceOption.label`
- All dropdowns use same model type

### Testing Checklist

- [ ] Unit test: `ReferenceDataRepositorySupabase` (mock Supabase client)
- [ ] Unit test: Error handling (PostgrestException, generic exceptions)
- [ ] Unit test: Empty result handling (empty list is OK, not error)
- [ ] Widget test: `insurerOptionsProvider` (loading, data, error states)
- [ ] Widget test: `brandOptionsProvider` (loading, data, error states)
- [ ] Widget test: `estateOptionsProvider` (loading, data, error states)
- [ ] Integration test: Claim capture flow with new providers
- [ ] Manual test: Verify dropdowns populate correctly
- [ ] Manual test: Verify error messages show on failure

### Build Steps

1. **Generate code:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Run tests:**
   ```bash
   flutter test
   ```

3. **Verify no linter errors:**
   ```bash
   flutter analyze
   ```

4. **Update imports:**
   - Search/replace old provider imports
   - Update model types (`BrandOption` → `ReferenceOption`)

5. **Delete old file:**
   - Remove `lib/features/claims/controller/reference_data_providers.dart`

---

## 7. Validation Checklist

Before marking migration complete:

- [ ] No direct Supabase calls in `lib/features/` (verify with grep)
- [ ] All reference data providers use repository pattern
- [ ] Error handling tested (errors surface to UI)
- [ ] No silent failures (empty list only on success)
- [ ] All callers updated (no broken imports)
- [ ] Tests pass
- [ ] Linter clean
- [ ] Manual smoke test: claim capture flow works

---

## Notes

- **Tenant scoping:** RLS policies enforce tenant isolation. No explicit `tenant_id` filter needed in queries (defense-in-depth optional).
- **Performance:** Reference data is lightweight. Auto-dispose providers are appropriate (re-fetch on demand).
- **Caching:** Consider adding `keepAlive()` if reference data changes infrequently and is used across many screens.
- **Future expansion:** Add `fetchServiceProviderOptions()` when service provider dropdowns are needed.

