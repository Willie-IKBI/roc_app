# Claims Queue Audit - Unbounded Queries

**Generated:** 2025-01-XX  
**Purpose:** Identify all unbounded claim list queries and legacy `fetchQueue()` usage

---

## 1) Legacy `fetchQueue()` Usage

### Deprecated Method Signature
**Location:** `lib/domain/repositories/claim_repository.dart` (line 24-25)  
**Status:** `@Deprecated('Use fetchQueuePage instead. This method will be removed in a future version.')`

### Implementation (Unbounded - No Limit)
**Location:** `lib/data/datasources/supabase_claim_remote_data_source.dart` (line 119-150)  
**Query:** `.from('v_claims_list').select('*')` → **NO `.limit()`**  
**Risk:** ⚠️ **HIGH** - Can return unlimited claims

### Call Sites

#### Call Site #1: Dashboard Controller
**File:** `lib/features/dashboard/controller/dashboard_controller.dart`  
**Function:** `_load()` (line 20-27)  
**Usage:** `repository.fetchQueue(status: null)`  
**Purpose:** Load all claims for dashboard statistics  
**Risk:** ⚠️ **HIGH** - Fetches ALL claims (no status filter)  
**Impact:** Dashboard loads slowly or crashes with large tenant  
**Recommended Action:** **C) Keep it but enforce hard limit + warn logging**

#### Call Site #2: Assignment Controller
**File:** `lib/features/assignments/controller/assignment_controller.dart`  
**Function:** `assignableJobs()` (line 16-109)  
**Usage:** `claimRepository.fetchQueue(status: statusFilter)` (line 30)  
**Purpose:** Base query for assignable jobs, then filters in memory  
**Risk:** ⚠️ **HIGH** - Fetches ALL claims matching status, then makes N+1 queries to fetch full claims for filtering  
**Impact:** Very slow with many claims, especially with assignment filters  
**Recommended Action:** **C) Keep it but enforce hard limit + warn logging** (short-term), then refactor to use `fetchQueuePage()` with server-side filters

---

## 2) Unbounded Claim List Queries (Direct Supabase)

### Query #1: Map View Controller
**File:** `lib/features/claims/controller/map_view_controller.dart`  
**Function:** `claimMapMarkers()` (line 35-142)  
**Query:** `.from('claims').select(...)` with joins  
**Filters:** Status (excludes closed/cancelled), technician_id, technician assignment  
**Limit:** ❌ **NONE**  
**Risk:** ⚠️ **HIGH** - Can return unlimited claims for map markers  
**Impact:** Map view slow/crashes with large tenant, browser memory issues  
**Recommended Action:** **B) Keep it but enforce hard limit + warn logging**

### Query #2: Scheduling Controller
**File:** `lib/features/scheduling/controller/scheduling_controller.dart`  
**Function:** `daySchedule()` (line 18-164)  
**Query:** `.from('claims').select(...)` with joins  
**Filters:** `appointment_date = dateStr`, `appointment_time IS NOT NULL`  
**Limit:** ❌ **NONE**  
**Risk:** ⚠️ **MEDIUM** - Filtered by date (single day), but no limit on appointments per day  
**Impact:** Slow if many appointments scheduled for one day  
**Recommended Action:** **B) Keep it but enforce hard limit + warn logging**

### Query #3: Technician Controller - Assignments
**File:** `lib/features/claims/controller/technician_controller.dart`  
**Function:** `technicianAssignments()` (line 20-46)  
**Query:** `.from('claims').select('technician_id')`  
**Filters:** `appointment_date = dateStr`, `technician_id IS NOT NULL`  
**Limit:** ❌ **NONE**  
**Risk:** ⚠️ **LOW** - Only selects `technician_id` (minimal data), filtered by date  
**Impact:** Low (minimal data transfer), but still unbounded  
**Recommended Action:** **B) Keep it but enforce hard limit + warn logging**

### Query #4: Technician Controller - Availability
**File:** `lib/features/claims/controller/technician_controller.dart`  
**Function:** `technicianAvailability()` (line 49-99)  
**Query:** `.from('claims').select('id, appointment_time, status')`  
**Filters:** `technician_id`, `appointment_date = dateStr`, `appointment_time IS NOT NULL`  
**Limit:** ❌ **NONE**  
**Risk:** ⚠️ **LOW** - Filtered by technician + date (single day), minimal columns  
**Impact:** Low (single technician, single day), but still unbounded  
**Recommended Action:** **B) Keep it but enforce hard limit + warn logging**

---

## 3) Bounded Queries (Verified Safe)

### ✅ fetchQueuePage() - Paginated
**Location:** `lib/data/datasources/supabase_claim_remote_data_source.dart` (line 26-118)  
**Query:** `.from('v_claims_list').select('*')`  
**Limit:** ✅ `.limit(pageSize + 1)` where `pageSize = limit.clamp(1, 100)`  
**Status:** ✅ **SAFE** - Properly paginated with cursor

### ✅ Reporting Queries
**Location:** `lib/data/datasources/supabase_reporting_remote_data_source.dart`  
**Queries:**
- `fetchDailyReports()` - `.limit(90)` ✅
- Fallback queries - `.limit(10000)` ⚠️ (large but bounded)

**Status:** ✅ **BOUNDED** (though limits are large)

---

## 4) Recommended Actions

### Action A) Remove (Safe, No Longer Used)
**None** - All deprecated methods are still in use.

### Action B) Keep but Enforce Hard Limit + Warn Logging

#### B1: Map View Controller
**File:** `lib/features/claims/controller/map_view_controller.dart`  
**Function:** `claimMapMarkers()`  
**Change:** Add `.limit(500)` before `.order()`  
**Rationale:** Map view doesn't need all claims, 500 markers is reasonable limit  
**Add logging:** Warn if result length == 500 (may be truncated)

#### B2: Scheduling Controller
**File:** `lib/features/scheduling/controller/scheduling_controller.dart`  
**Function:** `daySchedule()`  
**Change:** Add `.limit(200)` before `.order()`  
**Rationale:** Single day appointments, 200 is reasonable (8 hours × 25 slots/hour max)  
**Add logging:** Warn if result length == 200 (may be truncated)

#### B3: Technician Controller - Assignments
**File:** `lib/features/claims/controller/technician_controller.dart`  
**Function:** `technicianAssignments()`  
**Change:** Add `.limit(1000)` before query execution  
**Rationale:** Minimal data (just technician_id), date-filtered, 1000 is safe  
**Add logging:** Warn if result length == 1000 (may be truncated)

#### B4: Technician Controller - Availability
**File:** `lib/features/claims/controller/technician_controller.dart`  
**Function:** `technicianAvailability()`  
**Change:** Add `.limit(100)` before `.order()`  
**Rationale:** Single technician, single day, 100 appointments max  
**Add logging:** Warn if result length == 100 (may be truncated)

### Action C) Keep but Enforce Hard Limit + Warn Logging (Legacy Methods)

#### C1: Deprecated fetchQueue() Implementation
**File:** `lib/data/datasources/supabase_claim_remote_data_source.dart`  
**Function:** `fetchQueue()` (line 119-150)  
**Change:** Add `.limit(1000)` before `.order()`  
**Add logging:** 
```dart
AppLogger.warn(
  'fetchQueue() is deprecated and limited to 1000 claims. Use fetchQueuePage() for pagination.',
  name: 'SupabaseClaimRemoteDataSource',
);
```
**Rationale:** Backward compatibility during migration, but enforce safety limit

#### C2: Dashboard Controller
**File:** `lib/features/dashboard/controller/dashboard_controller.dart`  
**Function:** `_load()`  
**Change:** No code change needed (limit enforced in C1)  
**Add logging:** Already logs errors, no additional logging needed  
**Future:** Migrate to `fetchQueuePage()` when dashboard supports pagination

#### C3: Assignment Controller
**File:** `lib/features/assignments/controller/assignment_controller.dart`  
**Function:** `assignableJobs()`  
**Change:** No code change needed (limit enforced in C1)  
**Add logging:** Already logs errors  
**Future:** Refactor to use `fetchQueuePage()` with server-side filters (technician_id, appointment_date) to avoid N+1 queries

---

## 5) Action Checklist

### Immediate (Safety Limits)

- [ ] **B1:** Add `.limit(500)` to `map_view_controller.dart` → `claimMapMarkers()` query
- [ ] **B2:** Add `.limit(200)` to `scheduling_controller.dart` → `daySchedule()` query
- [ ] **B3:** Add `.limit(1000)` to `technician_controller.dart` → `technicianAssignments()` query
- [ ] **B4:** Add `.limit(100)` to `technician_controller.dart` → `technicianAvailability()` query
- [ ] **C1:** Add `.limit(1000)` to `supabase_claim_remote_data_source.dart` → `fetchQueue()` method
- [ ] **C1:** Add deprecation warning log to `fetchQueue()` method

### Short-Term (Migration)

- [ ] **C2:** Migrate `dashboard_controller.dart` to use `fetchQueuePage()` (may need pagination support in UI)
- [ ] **C3:** Refactor `assignment_controller.dart` to use `fetchQueuePage()` with server-side filters (eliminate N+1 queries)

### Long-Term (Architecture)

- [ ] **B1-B4:** Move all direct Supabase calls to repository layer (per `DEV_RULES.md`)
- [ ] **C1:** Remove deprecated `fetchQueue()` method after all call sites migrated

---

## 6) Risk Summary

| Query | Risk Level | Impact | Limit Needed |
|-------|-----------|--------|--------------|
| `fetchQueue()` (deprecated) | ⚠️ HIGH | Dashboard/assignments slow/crash | 1000 |
| `map_view_controller.dart` | ⚠️ HIGH | Map view slow/crash | 500 |
| `scheduling_controller.dart` | ⚠️ MEDIUM | Day schedule slow | 200 |
| `technician_controller.dart` (assignments) | ⚠️ LOW | Minimal impact | 1000 |
| `technician_controller.dart` (availability) | ⚠️ LOW | Minimal impact | 100 |

**Total Unbounded Queries:** 5  
**Total Call Sites:** 7 (2 for deprecated method, 5 for direct queries)

---

## 7) Verification

After implementing limits, verify:

- [ ] Dashboard loads with 1000+ claims (should be limited, not crash)
- [ ] Map view loads with 500+ claims (should show max 500 markers)
- [ ] Day schedule loads with 200+ appointments (should show max 200)
- [ ] Assignment screen works with 1000+ claims (should be limited)
- [ ] Warning logs appear when limits are hit
- [ ] No performance degradation in normal usage (< limit)

---

## Notes

- All queries rely on RLS for tenant scoping (verified in `SUPABASE_SNAPSHOT.md`)
- Limits are defensive - RLS prevents cross-tenant data, but doesn't prevent large result sets
- `fetchQueuePage()` is the correct pattern going forward (cursor-based pagination)
- Direct Supabase calls in features violate `DEV_RULES.md` but are kept for now with limits

