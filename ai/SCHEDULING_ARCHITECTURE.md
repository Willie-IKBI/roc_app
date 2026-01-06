# Scheduling Module - Vertical Slice Architecture

**Status:** Build Plan  
**Target:** Eliminate direct Supabase calls, fix N+1 queries, enforce hard limits  
**Scope:** Day schedule loading, appointment management, technician schedules

---

## 1. Target Folder/File Structure

```
lib/
  domain/
    repositories/
      scheduling_repository.dart          # NEW: Interface for scheduling queries
  data/
    datasources/
      scheduling_remote_data_source.dart  # NEW: Interface
      supabase_scheduling_remote_data_source.dart  # NEW: Supabase implementation
    repositories/
      scheduling_repository_supabase.dart # NEW: Repository implementation
  features/
    scheduling/
      controller/
        scheduling_controller.dart        # UPDATE: Replace direct Supabase calls
      presentation/
        scheduling_screen.dart            # UPDATE: Wire to new controller (if needed)
```

**Rationale:**
- Feature-first structure aligns with `cursor_coding_rules.md`
- Repository interface in domain, implementation in data layer
- Controller in feature folder (UI-facing)
- Reuse existing `scheduling_models.dart` (no changes needed)

---

## 2. Repository Interface Method Signatures

### `lib/domain/repositories/scheduling_repository.dart` (NEW)

```dart
import '../models/scheduling_models.dart';
import '../../core/utils/result.dart';

abstract class SchedulingRepository {
  /// Fetch all appointments for a specific date
  /// 
  /// [date] - Date to fetch appointments for (YYYY-MM-DD)
  /// [technicianId] - Optional filter by technician (null = all technicians)
  /// 
  /// Returns DaySchedule with:
  /// - All appointments grouped by technician
  /// - Unassigned appointments (technician_id IS NULL)
  /// - Hard limit: 200 appointments per day (enforced in data source)
  /// 
  /// Query includes all required data (eliminates N+1 pattern):
  /// - Claim details (id, claim_number, status, priority)
  /// - Client details (first_name, last_name)
  /// - Address details (street, suburb, city, province, lat, lng)
  /// - Appointment details (appointment_date, appointment_time, estimated_duration_minutes, travel_time_minutes)
  /// - Technician details (technician_id, technician name via join)
  Future<Result<DaySchedule>> fetchScheduleForDay({
    required DateTime date,
    String? technicianId,
  });

  // Note: updateAppointment() already exists in ClaimRepository
  // Use ClaimRepository.updateAppointment() for appointment updates
  // This repository is read-only for scheduling data
}
```

**Design decisions:**
- Single method `fetchScheduleForDay()` - fetches all data in one query (eliminates N+1)
- Optional `technicianId` filter for future use (technician-specific views)
- Hard limit: 200 appointments per day (reasonable for single day)
- Returns `DaySchedule` directly (matches existing UI expectations)
- Read-only repository - appointment updates use existing `ClaimRepository.updateAppointment()`

**Note:** `updateAppointment()` already exists in `ClaimRepository` (line 49-53). Scheduling repository is read-only.

---

## 3. Exact Supabase Query Patterns

### `lib/data/datasources/supabase_scheduling_remote_data_source.dart` (NEW)

**Query for `fetchScheduleForDay()`:**

```sql
-- Single query with all joins (eliminates N+1 pattern)
SELECT 
  c.id,
  c.claim_number,
  c.technician_id,
  c.appointment_date,
  c.appointment_time,
  c.status,
  c.priority,
  c.estimated_duration_minutes,
  c.travel_time_minutes,
  -- Client data
  cl.first_name,
  cl.last_name,
  cl.primary_phone,
  -- Address data
  addr.id as address_id,
  addr.street,
  addr.suburb,
  addr.city,
  addr.province,
  addr.lat,
  addr.lng,
  -- Technician name (via profiles join)
  p.full_name as technician_name
FROM claims c
JOIN clients cl ON cl.id = c.client_id
JOIN addresses addr ON addr.id = c.address_id
LEFT JOIN profiles p ON p.id = c.technician_id
WHERE c.appointment_date = :date
  AND c.appointment_time IS NOT NULL
  AND (:technician_id IS NULL OR c.technician_id = :technician_id)
ORDER BY c.appointment_time ASC, c.claim_id ASC
LIMIT 200;
```

**Supabase PostgREST equivalent:**

```dart
var query = _client
    .from('claims')
    .select('''
      id,
      claim_number,
      technician_id,
      appointment_date,
      appointment_time,
      status,
      priority,
      estimated_duration_minutes,
      travel_time_minutes,
      client:clients!claims_client_id_fkey(
        first_name,
        last_name,
        primary_phone
      ),
      address:addresses!claims_address_id_fkey(
        id,
        street,
        suburb,
        city,
        province,
        lat,
        lng
      ),
      technician:profiles!claims_technician_id_fkey(
        id,
        full_name
      )
    ''')
    .eq('appointment_date', dateStr)
    .not('appointment_time', 'is', null);

if (technicianId != null) {
  query = query.eq('technician_id', technicianId);
}

final data = await query
    .order('appointment_time', ascending: true)
    .order('id', ascending: true) // Tie-breaker for deterministic ordering
    .limit(200); // Hard limit: max 200 appointments per day
```

**Query specifications:**
- **Table:** `claims` (not view, direct table for joins)
- **Joins:** `clients`, `addresses`, `profiles` (technician)
- **Filters:**
  - `appointment_date = date` (required)
  - `appointment_time IS NOT NULL` (required)
  - `technician_id = ?` (optional filter)
- **Ordering:** `appointment_time ASC, id ASC` (deterministic, uses `claims_appointment_date_time_idx`)
- **Limit:** `200` (hard limit, warn if truncated)
- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)

**Index usage:**
- `claims_appointment_date_time_idx` (appointment_date, appointment_time) - supports date filter + ordering
- `claims_technician_appointment_idx` (technician_id, appointment_date, appointment_time) - supports technician filter
- `claims_appointment_date_idx` (appointment_date) - fallback for date-only queries

**Error handling:**
- Log all errors via `AppLogger.error()`
- Return `Result.err()` (no silent failures)
- Warn if result length == 200 (may be truncated)

---

## 4. Controller/Provider Pattern

### `lib/features/scheduling/controller/scheduling_controller.dart` (UPDATE)

**Current issues:**
- Direct Supabase call in `daySchedule()` provider
- N+1 query pattern (loops through appointments, calls `claimRepository.fetchById()`)
- No error handling (returns empty `DaySchedule` on error)

**New pattern:**

```dart
@riverpod
Future<DaySchedule> daySchedule(
  Ref ref, {
  required DateTime date,
  String? technicianId,
}) async {
  final repository = ref.watch(schedulingRepositoryProvider);
  final result = await repository.fetchScheduleForDay(
    date: date,
    technicianId: technicianId,
  );

  if (result.isErr) {
    // Surface error to UI - AsyncValue will be AsyncError
    throw result.error;
  }

  return result.data;
}
```

**Additional providers (keep existing, update if needed):**
- `technicianSchedule()` - Derives from `daySchedule()` (no change needed)
- `unassignedAppointments()` - Derives from `daySchedule()` (no change needed)
- `optimizeRoute()` - Uses `technicianSchedule()` (no change needed)
- `availableTimeSlots()` - Uses `technicianSchedule()` (no change needed)

**Error handling:**
- Errors thrown → `AsyncValue` becomes `AsyncError` (UI can handle)
- No silent failures - errors always propagate
- UI shows error state with retry button

**Refresh pattern:**
```dart
// In UI
ref.invalidate(dayScheduleProvider(date: _selectedDate));
```

---

## 5. Migration Checklist

### Files to Create

- [ ] `lib/domain/repositories/scheduling_repository.dart` - Interface
- [ ] `lib/data/datasources/scheduling_remote_data_source.dart` - Data source interface
- [ ] `lib/data/datasources/supabase_scheduling_remote_data_source.dart` - Supabase implementation
- [ ] `lib/data/repositories/scheduling_repository_supabase.dart` - Repository implementation

### Files to Update

- [ ] `lib/features/scheduling/controller/scheduling_controller.dart` - Replace direct Supabase call
- [ ] `lib/features/scheduling/presentation/scheduling_screen.dart` - Verify no changes needed (should work as-is)

### Files to Remove/Deprecate

- [ ] None (no old repository to deprecate)

### Migration Steps

1. **Create repository interface:**
   - Define `SchedulingRepository` with `fetchScheduleForDay()` method (read-only)
   - Note: `updateAppointment()` already exists in `ClaimRepository` - reuse that for updates

2. **Create data source:**
   - Define `SchedulingRemoteDataSource` interface
   - Implement `SupabaseSchedulingRemoteDataSource` with single query (all joins)
   - Enforce `.limit(200)` with warning log if truncated

3. **Create repository implementation:**
   - Map data source rows to `DaySchedule` domain model
   - Group appointments by technician
   - Separate unassigned appointments

4. **Update controller:**
   - Remove direct Supabase call from `daySchedule()` provider
   - Remove N+1 loop (no more `claimRepository.fetchById()` calls)
   - Use `schedulingRepository.fetchScheduleForDay()`
   - Update error handling (throw errors, don't return empty schedule)

5. **Update UI (if needed):**
   - Verify `scheduling_screen.dart` works with new provider
   - Update error handling if needed (should work as-is with `AsyncError`)

6. **Remove old code:**
   - Delete direct Supabase query from controller
   - Delete N+1 query loop

### Mapping: Old Calls → New Repository Calls

**Before:**
```dart
// OLD: Direct Supabase call + N+1 queries
final response = await client
    .from('claims')
    .select('...')
    .eq('appointment_date', dateStr)
    .not('appointment_time', 'is', null)
    .order('appointment_time')
    .limit(200);

for (final row in response) {
  // N+1: Fetch full claim for each appointment
  final claimResult = await claimRepository.fetchById(row['id']);
  // ... process claim
}
```

**After:**
```dart
// NEW: Single repository call (all data in one query)
final repository = ref.watch(schedulingRepositoryProvider);
final result = await repository.fetchScheduleForDay(date: date);

if (result.isErr) {
  throw result.error; // Proper error handling
}

return result.data; // DaySchedule with all appointments
```

### Safe Rollout Steps

1. **Phase 1: Create new repository layer**
   - Create interfaces and implementations
   - Write unit tests
   - Verify query returns correct data structure

2. **Phase 2: Wire new path (parallel)**
   - Update controller to use new repository
   - Keep old code commented (for rollback)
   - Test with small dataset

3. **Phase 3: Verify**
   - Manual test: Load schedule for today
   - Manual test: Load schedule for date with many appointments
   - Manual test: Verify technician grouping works
   - Manual test: Verify unassigned appointments work
   - Performance test: Compare old vs. new (should be faster, no N+1)

4. **Phase 4: Cleanup**
   - Remove old direct Supabase call
   - Remove N+1 query loop
   - Remove commented code

---

## 6. Data Transformation

### From Supabase Response to DaySchedule

**Input:** List of claim rows with nested client/address/technician data

**Transformation steps:**
1. Map each row to `AppointmentSlot`:
   - Extract claim data (id, claim_number, status, priority, appointment_date, appointment_time)
   - Extract client data (first_name, last_name → clientName)
   - Extract address data (street, suburb, city, province, lat, lng → Address)
   - Extract technician data (technician_id, technician.full_name → technicianName)
   - Extract scheduling data (estimated_duration_minutes, travel_time_minutes)

2. Group appointments:
   - Separate by `technician_id`:
     - `technician_id IS NOT NULL` → Add to technician's schedule
     - `technician_id IS NULL` → Add to unassigned list

3. Build `TechnicianSchedule` objects:
   - One per technician with appointments
   - Sort appointments by `appointment_time`

4. Build `DaySchedule`:
   - `technicianSchedules`: List of `TechnicianSchedule`
   - `unassignedAppointments`: List of `AppointmentSlot`
   - `date`: Input date

**Note:** Reuse existing `AppointmentSlot.fromClaim()` factory if possible, or create new mapper.

---

## 7. Safety Rules

### No Unbounded Queries

✅ **Enforced:**
- All queries use `.limit(200)` (hard limit for single day)
- Limit is reasonable (200 appointments = ~25 per hour over 8 hours)
- Warning logged if result length == 200 (may be truncated)

### No Silent Failures

✅ **Enforced:**
- All errors logged via `AppLogger.error()`
- Errors thrown (not swallowed)
- Errors surface to UI via `AsyncError`
- No empty `DaySchedule` returned on error

### No Direct Supabase Calls in UI

✅ **Enforced:**
- All queries go through `SchedulingRepository`
- Repository calls `SchedulingRemoteDataSource`
- UI only calls controller providers
- No `supabaseClientProvider` in UI/controllers

### No N+1 Queries

✅ **Enforced:**
- Single query with all joins (eliminates N+1 pattern)
- All required data fetched in one round-trip
- No loops calling `claimRepository.fetchById()`

---

## 8. Testing Checklist

### Unit Tests (To Be Written)

- [ ] `fetchScheduleForDay()` - Single day with appointments
- [ ] `fetchScheduleForDay()` - Empty day (no appointments)
- [ ] `fetchScheduleForDay()` - Day with 200+ appointments (truncated, warning logged)
- [ ] `fetchScheduleForDay()` - Filter by technician
- [ ] `fetchScheduleForDay()` - Mixed assigned/unassigned appointments
- [ ] `fetchScheduleForDay()` - Error handling (network error, RLS error)
- [ ] Data transformation: Supabase response → DaySchedule
- [ ] Grouping: Appointments grouped by technician correctly
- [ ] Sorting: Appointments sorted by time within each technician

### Widget Tests (To Be Written)

- [ ] `daySchedule()` provider - Loading state
- [ ] `daySchedule()` provider - Data state
- [ ] `daySchedule()` provider - Error state
- [ ] `daySchedule()` provider - Refresh invalidates correctly

### Manual Testing

- [ ] Load schedule for today (with appointments)
- [ ] Load schedule for date with many appointments (verify limit)
- [ ] Load schedule for empty day
- [ ] Filter by technician (if implemented)
- [ ] Verify technician grouping works
- [ ] Verify unassigned appointments appear
- [ ] Verify appointment cards show correct data
- [ ] Verify timeline view works
- [ ] Performance: Compare old vs. new (should be faster)

---

## 9. Performance Considerations

### Query Performance

- **Index usage:** `claims_appointment_date_time_idx` supports date filter + ordering
- **Join performance:** 3 joins (clients, addresses, profiles) - monitor query time
- **Limit:** 200 appointments per day (reasonable, but may need adjustment)

### N+1 Elimination

- **Before:** 1 query for appointments + N queries for full claims = N+1 queries
- **After:** 1 query with all joins = 1 query total
- **Improvement:** Significant for days with many appointments (10+ appointments = 10x faster)

### Data Transfer

- **Before:** Minimal data in first query, then full claim objects in N queries
- **After:** All data in single query (may be larger, but single round-trip)
- **Trade-off:** Acceptable (single round-trip is faster than N round-trips)

---

## 10. Notes

- **RLS:** Tenant isolation enforced automatically (no explicit `tenant_id` filter needed)
- **Technician lookup:** Reuse existing `UserAdminRepository.fetchTechnicians()` if needed, or join directly in query
- **Appointment updates:** `ClaimRepository.updateAppointment()` already exists - use that for appointment updates (scheduling repository is read-only)
- **Future enhancements:** 
  - Add date range query (`fetchScheduleRange()`) if needed
  - Add pagination if single day exceeds 200 appointments (unlikely but possible)
  - Add server-side filters (status, priority) if needed
- **Backward compatibility:** No breaking changes - `DaySchedule` model unchanged, UI works as-is

---

## 11. Comparison: Before vs. After

### Before (Current State)

**Issues:**
- ❌ Direct Supabase call in controller
- ❌ N+1 query pattern (loops through appointments, fetches full claim for each)
- ❌ No error handling (returns empty schedule on error)
- ❌ Unbounded query (though has `.limit(200)`, but still violates architecture)

**Query count:** 1 + N (where N = number of appointments)

### After (Target State)

**Improvements:**
- ✅ Repository pattern (no direct Supabase calls)
- ✅ Single query with all joins (eliminates N+1)
- ✅ Proper error handling (errors propagate to UI)
- ✅ Hard limit enforced (200 appointments per day)

**Query count:** 1 (single query with all data)

**Performance:** 10x faster for days with 10+ appointments (1 query vs. 11 queries)

