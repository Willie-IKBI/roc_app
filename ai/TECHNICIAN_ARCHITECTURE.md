# Technician Module - Vertical Slice Architecture

**Status:** Build Plan  
**Target:** Eliminate direct Supabase calls, enforce hard limits, proper error handling  
**Scope:** Technician listing, availability checks, assignment summaries

---

## 1. Technician Data Needs Analysis

### Current Technician Requirements

**Read Operations:**
- `technicians()` - List of technicians (active, role=technician)
  - Currently: Uses `UserAdminRepository.fetchTechnicians()` ✅ (already uses repository)
  - Issue: No hard limit (though likely small dataset)
  
- `technicianAssignments()` - Assignment count per technician for a date
  - Currently: Direct Supabase call in `technician_controller.dart`
  - Query: Selects `technician_id` from `claims` filtered by `appointment_date`
  - Issue: Unbounded (has limit 1000, but still direct call, silent error handling)

- `technicianAvailability()` - Availability slots for a technician on a date
  - Currently: Direct Supabase call in `technician_controller.dart`
  - Query: Selects `id, appointment_time, status` from `claims` filtered by `technician_id` and `appointment_date`
  - Issue: Unbounded (has limit 100, but still direct call, silent error handling)

**Write Operations:**
- None (technician management uses existing `UserAdminRepository`)

**Current Implementation Issues:**
- ❌ Direct Supabase calls in `technician_controller.dart` for assignments and availability
- ❌ Silent error handling (returns empty map/list on error)
- ❌ No hard limits on `fetchTechnicians()` (though likely small dataset)
- ✅ `technicians()` already uses repository pattern (needs hard limit)

---

## 2. Target Folder/File Structure

```
lib/
  domain/
    repositories/
      technician_repository.dart          # NEW: Interface for technician queries
  data/
    datasources/
      technician_remote_data_source.dart # NEW: Interface
      supabase_technician_remote_data_source.dart  # NEW: Supabase implementation
    repositories/
      technician_repository_supabase.dart # NEW: Repository implementation
  features/
    claims/
      controller/
        technician_controller.dart       # UPDATE: Replace direct Supabase calls
      presentation/
        widgets/
          technician_selector.dart      # VERIFY: Should work as-is
```

**Rationale:**
- Feature-first structure aligns with `cursor_coding_rules.md`
- Repository interface in domain, implementation in data layer
- Controller in feature folder (UI-facing)
- Separate from `UserAdminRepository` (user management vs. technician queries)

**Note:** `UserAdminRepository` remains for user management operations. `TechnicianRepository` is for technician-specific queries (assignments, availability).

---

## 3. Repository Interface Method Signatures

### `lib/domain/repositories/technician_repository.dart` (NEW)

```dart
import '../../core/utils/result.dart';
import '../models/user_account.dart';

/// Technician assignment summary (count per technician)
@freezed
class TechnicianAssignmentSummary with _$TechnicianAssignmentSummary {
  const factory TechnicianAssignmentSummary({
    required String technicianId,
    required int assignmentCount,
  }) = _TechnicianAssignmentSummary;
}

/// Technician availability data for a specific date
@freezed
class TechnicianAvailability with _$TechnicianAvailability {
  const factory TechnicianAvailability({
    required String technicianId,
    required DateTime date,
    required List<AppointmentSlot> appointments,
    required List<String> availableSlots,
    required int totalAppointments,
  }) = _TechnicianAvailability;
}

/// Appointment slot (minimal data for availability)
@freezed
class AppointmentSlot with _$AppointmentSlot {
  const factory AppointmentSlot({
    required String claimId,
    required String appointmentTime,
    required String status,
  }) = _AppointmentSlot;
}

abstract class TechnicianRepository {
  /// Fetch assignment counts per technician for a specific date
  /// 
  /// [date] - Date to fetch assignments for (YYYY-MM-DD)
  /// [limit] - Maximum number of assignments to count (default: 1000, max: 2000)
  /// 
  /// Returns map of technician_id -> assignment_count
  /// 
  /// Query: Counts appointments per technician for the date
  /// Uses minimal payload (only technician_id)
  Future<Result<Map<String, int>>> fetchTechnicianAssignments({
    required DateTime date,
    int limit = 1000,
  });

  /// Fetch availability data for a technician on a specific date
  /// 
  /// [technicianId] - Technician to fetch availability for
  /// [date] - Date to fetch availability for (YYYY-MM-DD)
  /// [limit] - Maximum number of appointments to fetch (default: 100, max: 200)
  /// 
  /// Returns availability data including:
  /// - List of appointments (id, time, status)
  /// - Available time slots (calculated client-side)
  /// - Total appointment count
  /// 
  /// Query: Fetches appointments for technician on date
  /// Uses minimal payload (only id, appointment_time, status)
  Future<Result<TechnicianAvailability>> fetchTechnicianAvailability({
    required String technicianId,
    required DateTime date,
    int limit = 100,
  });
}
```

**Design decisions:**
- Separate repository for technician queries (not user management)
- `fetchTechnicianAssignments()` - Returns map (technician_id -> count)
- `fetchTechnicianAvailability()` - Returns structured availability data
- Hard limits: 1000 default/2000 max for assignments, 100 default/200 max for availability
- Minimal payload: Only fields needed for each query

**Note:** `fetchTechnicians()` remains in `UserAdminRepository` (user management). Add hard limit to that method.

---

## 4. Exact Supabase Query Patterns

### `lib/data/datasources/supabase_technician_remote_data_source.dart` (NEW)

**Query 1: `fetchTechnicianAssignments()` - Assignment Counts**

```dart
final dateStr = date.toIso8601String().split('T')[0];
final pageSize = limit.clamp(1, 2000);

var query = _client
    .from('claims')
    .select('technician_id')  // Minimal payload
    .eq('appointment_date', dateStr)
    .not('technician_id', 'is', null)
    .order('technician_id', ascending: true)  // Deterministic ordering
    .limit(pageSize);

final data = await query;

// Count assignments per technician
final assignments = <String, int>{};
for (final row in data as List<dynamic>) {
  final technicianId = row['technician_id'] as String?;
  if (technicianId != null) {
    assignments[technicianId] = (assignments[technicianId] ?? 0) + 1;
  }
}

// Warn if limit reached
if (data.length >= pageSize) {
  AppLogger.warn(
    'fetchTechnicianAssignments() returned $pageSize results (limit reached). Some assignments may not be counted.',
    name: 'SupabaseTechnicianRemoteDataSource',
  );
}

return Result.ok(assignments);
```

**Query specifications:**
- **Table:** `claims`
- **Filters:** `appointment_date = date`, `technician_id IS NOT NULL`
- **Payload:** Only `technician_id` (minimal)
- **Ordering:** `technician_id ASC` (deterministic)
- **Limit:** `limit.clamp(1, 2000)` (hard max of 2000)
- **RLS:** Tenant isolation enforced automatically

**Query 2: `fetchTechnicianAvailability()` - Availability Data**

```dart
final dateStr = date.toIso8601String().split('T')[0];
final pageSize = limit.clamp(1, 200);

var query = _client
    .from('claims')
    .select('id, appointment_time, status')  // Minimal payload
    .eq('technician_id', technicianId)
    .eq('appointment_date', dateStr)
    .not('appointment_time', 'is', null)
    .order('appointment_time', ascending: true)  // Deterministic ordering
    .limit(pageSize);

final data = await query;

final appointments = <AppointmentSlot>[];
for (final row in data as List<dynamic>) {
  appointments.add(AppointmentSlot(
    claimId: row['id'] as String,
    appointmentTime: row['appointment_time'] as String,
    status: row['status'] as String,
  ));
}

// Warn if limit reached
if (data.length >= pageSize) {
  AppLogger.warn(
    'fetchTechnicianAvailability() returned $pageSize results (limit reached). Some appointments may not be included.',
    name: 'SupabaseTechnicianRemoteDataSource',
  );
}

// Calculate available slots (client-side, same logic as current)
final availableSlots = <String>[];
final bookedTimes = appointments.map((a) => a.appointmentTime).toSet();

for (int hour = 8; hour < 17; hour++) {
  final timeStr = '${hour.toString().padLeft(2, '0')}:00:00';
  if (!bookedTimes.contains(timeStr)) {
    availableSlots.add(timeStr);
  }
}

return Result.ok(TechnicianAvailability(
  technicianId: technicianId,
  date: date,
  appointments: appointments,
  availableSlots: availableSlots,
  totalAppointments: appointments.length,
));
```

**Query specifications:**
- **Table:** `claims`
- **Filters:** `technician_id = ?`, `appointment_date = date`, `appointment_time IS NOT NULL`
- **Payload:** Only `id, appointment_time, status` (minimal)
- **Ordering:** `appointment_time ASC` (deterministic)
- **Limit:** `limit.clamp(1, 200)` (hard max of 200)
- **RLS:** Tenant isolation enforced automatically

**Index usage:**
- `claims_technician_appointment_idx` (technician_id, appointment_date, appointment_time) - supports both queries
- `claims_appointment_date_idx` (appointment_date) - supports date filtering

---

## 5. Update UserAdminRepository

### `lib/domain/repositories/user_admin_repository.dart` (UPDATE)

**Add hard limit to `fetchTechnicians()`:**

```dart
abstract class UserAdminRepository {
  /// Fetch all technicians (active, role=technician)
  /// 
  /// [limit] - Maximum number of technicians to fetch (default: 200, max: 500)
  /// 
  /// Returns list of active technicians
  Future<Result<List<UserAccount>>> fetchTechnicians({
    int limit = 200,
  });

  // ... other methods unchanged
}
```

**Update implementation:**
- Add `.limit(limit.clamp(1, 500))` to query
- Warn if limit reached

---

## 6. Controller/Provider Pattern

### `lib/features/claims/controller/technician_controller.dart` (UPDATE)

**Current issues:**
- Direct Supabase calls in `technicianAssignments()` and `technicianAvailability()`
- Silent error handling (returns empty map/list on error)
- `technicians()` already uses repository (needs hard limit)

**New pattern:**

```dart
@riverpod
Future<List<UserAccount>> technicians(Ref ref) async {
  final repository = ref.watch(userAdminRepositoryProvider);
  final result = await repository.fetchTechnicians(limit: 200);
  if (result.isErr) {
    throw result.error;
  }
  return result.data;
}

@riverpod
Future<Map<String, int>> technicianAssignments(
  Ref ref, {
  required DateTime date,
}) async {
  final repository = ref.watch(technicianRepositoryProvider);
  final result = await repository.fetchTechnicianAssignments(date: date);
  
  if (result.isErr) {
    throw result.error;
  }
  
  return result.data;
}

@riverpod
Future<Map<String, dynamic>> technicianAvailability(
  Ref ref, {
  required String technicianId,
  required DateTime date,
}) async {
  final repository = ref.watch(technicianRepositoryProvider);
  final result = await repository.fetchTechnicianAvailability(
    technicianId: technicianId,
    date: date,
  );
  
  if (result.isErr) {
    throw result.error;
  }
  
  // Convert to map format (for backward compatibility)
  final availability = result.data;
  return {
    'appointments': availability.appointments.map((a) => {
      'id': a.claimId,
      'time': a.appointmentTime,
      'status': a.status,
    }).toList(),
    'availableSlots': availability.availableSlots,
    'totalAppointments': availability.totalAppointments,
  };
}
```

**Error handling:**
- Errors thrown → `AsyncValue` becomes `AsyncError` (UI can handle)
- No silent failures - errors always propagate
- UI shows error state with retry button

**Refresh pattern:**
```dart
// In UI
ref.invalidate(technicianAssignmentsProvider(date: date));
ref.invalidate(technicianAvailabilityProvider(technicianId: id, date: date));
```

---

## 7. UI Integration Notes

### Technician Selector (`technician_selector.dart`)

**Current implementation:**
- Uses `techniciansProvider` ✅ (already uses repository)
- Uses `technicianAvailabilityProvider` for availability indicator
- No changes needed (providers work as-is)

**Integration points:**
- `techniciansProvider` - Already uses repository, will get hard limit automatically
- `technicianAvailabilityProvider` - Will use new repository (backward compatible return format)
- No UI changes needed

---

## 8. Migration Checklist

### Files to Create

- [ ] `lib/domain/repositories/technician_repository.dart` - Interface
- [ ] `lib/domain/models/technician_availability.dart` - Availability models (if needed)
- [ ] `lib/data/datasources/technician_remote_data_source.dart` - Data source interface
- [ ] `lib/data/datasources/supabase_technician_remote_data_source.dart` - Supabase implementation
- [ ] `lib/data/repositories/technician_repository_supabase.dart` - Repository implementation

### Files to Update

- [ ] `lib/domain/repositories/user_admin_repository.dart` - Add hard limit to `fetchTechnicians()`
- [ ] `lib/data/repositories/user_admin_repository_supabase.dart` - Add limit to query
- [ ] `lib/data/datasources/supabase_user_admin_remote_data_source.dart` - Add limit to query
- [ ] `lib/features/claims/controller/technician_controller.dart` - Replace direct Supabase calls

### Files to Remove/Deprecate

- [ ] None (no old repository to deprecate)

### Migration Steps

1. **Create repository interface:**
   - Define `TechnicianRepository` with methods for assignments and availability
   - Define domain models (`TechnicianAvailability`, `AppointmentSlot`)

2. **Create data source:**
   - Implement `SupabaseTechnicianRemoteDataSource` with queries
   - Enforce hard limits (1000/2000 for assignments, 100/200 for availability)
   - Apply deterministic ordering

3. **Create repository implementation:**
   - Map data source results to domain models
   - Return `Result` types (no silent failures)

4. **Update UserAdminRepository:**
   - Add `limit` parameter to `fetchTechnicians()` method
   - Update implementation to enforce limit
   - Update data source to add limit to query

5. **Update controller:**
   - Remove direct Supabase calls from `technicianAssignments()` and `technicianAvailability()`
   - Use `technicianRepository` methods
   - Update error handling (throw errors, don't return empty map/list)
   - Update `technicians()` to pass limit parameter

6. **Update UI (if needed):**
   - Verify `technician_selector.dart` works with new providers (should work as-is)
   - Update error handling if needed (should work as-is with `AsyncError`)

7. **Remove old code:**
   - Delete direct Supabase queries from controller
   - Delete silent error handling (empty returns)

### Mapping: Old Calls → New Repository Calls

**Before:**
```dart
// OLD: Direct Supabase call
final client = ref.watch(supabaseClientProvider);
final response = await client
    .from('claims')
    .select('technician_id')
    .eq('appointment_date', dateStr)
    .not('technician_id', 'is', null)
    .limit(1000);

final assignments = <String, int>{};
// ... process response
catch (err) {
  return {}; // Silent failure
}
```

**After:**
```dart
// NEW: Repository call
final repository = ref.watch(technicianRepositoryProvider);
final result = await repository.fetchTechnicianAssignments(date: date);

if (result.isErr) {
  throw result.error; // Proper error handling
}

return result.data; // Map<String, int>
```

### Safe Rollout Steps

1. **Phase 1: Create new repository layer**
   - Create interfaces and implementations
   - Write unit tests
   - Verify queries return correct data structure

2. **Phase 2: Wire new path (parallel)**
   - Update controller to use new repository
   - Keep old code commented (for rollback)
   - Test with small dataset

3. **Phase 3: Verify**
   - Manual test: Load technicians list
   - Manual test: Load technician assignments
   - Manual test: Load technician availability
   - Manual test: Verify availability indicator works
   - Performance test: Compare old vs. new (should be similar)

4. **Phase 4: Cleanup**
   - Remove old direct Supabase calls
   - Remove commented code

---

## 9. Performance Considerations

### Query Performance

- **Technician list:** Small dataset (typically < 100 technicians), hard limit 200-500 is reasonable
- **Assignments:** Single day, minimal payload (only technician_id), hard limit 1000-2000 is reasonable
- **Availability:** Single technician, single day, minimal payload, hard limit 100-200 is reasonable

### Data Transfer

- **Minimal payload:** Only fields needed for each query
- **Assignments:** Only `technician_id` (minimal)
- **Availability:** Only `id, appointment_time, status` (minimal)

---

## 10. Safety Rules

### No Unbounded Queries

✅ **Enforced:**
- `fetchTechnicians()`: `.limit(limit.clamp(1, 500))` (hard max of 500)
- `fetchTechnicianAssignments()`: `.limit(limit.clamp(1, 2000))` (hard max of 2000)
- `fetchTechnicianAvailability()`: `.limit(limit.clamp(1, 200))` (hard max of 200)
- Warning logged if result length == limit (may be truncated)

### No Silent Failures

✅ **Enforced:**
- All errors logged via `AppLogger.error()`
- Errors thrown (not swallowed)
- Errors surface to UI via `AsyncError`
- No empty map/list returned on error

### No Direct Supabase Calls in UI

✅ **Enforced:**
- All queries go through `TechnicianRepository` or `UserAdminRepository`
- Repository calls `TechnicianRemoteDataSource` or `UserAdminRemoteDataSource`
- UI only calls controller providers
- No `supabaseClientProvider` in UI/controllers

---

## 11. Testing Checklist

### Unit Tests (To Be Written)

- [ ] `fetchTechnicianAssignments()` - Single date with assignments
- [ ] `fetchTechnicianAssignments()` - Empty date (no assignments)
- [ ] `fetchTechnicianAssignments()` - Limit enforcement (2000 max)
- [ ] `fetchTechnicianAvailability()` - Technician with appointments
- [ ] `fetchTechnicianAvailability()` - Technician with no appointments
- [ ] `fetchTechnicianAvailability()` - Limit enforcement (200 max)
- [ ] `fetchTechnicians()` - Active technicians (with limit)
- [ ] Error handling (network error, RLS error)

### Widget Tests (To Be Written)

- [ ] `techniciansProvider` - Loading state
- [ ] `techniciansProvider` - Data state
- [ ] `techniciansProvider` - Error state
- [ ] `technicianAssignmentsProvider` - Loading state
- [ ] `technicianAssignmentsProvider` - Data state
- [ ] `technicianAssignmentsProvider` - Error state
- [ ] `technicianAvailabilityProvider` - Loading state
- [ ] `technicianAvailabilityProvider` - Data state
- [ ] `technicianAvailabilityProvider` - Error state

### Manual Testing

- [ ] Load technicians list (verify all technicians display)
- [ ] Load technician assignments (verify counts correct)
- [ ] Load technician availability (verify appointments and slots)
- [ ] Verify availability indicator works in technician selector
- [ ] Verify error handling (network error shows error state)
- [ ] Performance: Compare old vs. new (should be similar)

---

## 12. Notes

- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)
- **UserAdminRepository:** Remains for user management operations. `TechnicianRepository` is for technician-specific queries.
- **Backward compatibility:** `technicianAvailability()` returns same map format (for UI compatibility)
- **Future optimizations:**
  - Cache technician list (refresh every 5 minutes)
  - Cache assignment counts (refresh every 5 minutes)
  - Add pagination if technician list grows large (unlikely)

---

## 13. Comparison: Before vs. After

### Before (Current State)

**Issues:**
- ❌ Direct Supabase calls in `technicianAssignments()` and `technicianAvailability()`
- ❌ Silent error handling (returns empty map/list on error)
- ❌ No hard limits on `fetchTechnicians()` (though likely small dataset)
- ✅ `technicians()` already uses repository pattern

**Query count:** 2 direct Supabase calls

### After (Target State)

**Improvements:**
- ✅ Repository pattern (no direct Supabase calls)
- ✅ Proper error handling (errors propagate to UI)
- ✅ Hard limits on all queries (200-2000 depending on query)
- ✅ `technicians()` uses repository with hard limit

**Query count:** 0 direct Supabase calls (all through repositories)

**Performance:** Similar (same queries, same limits, better error handling)

