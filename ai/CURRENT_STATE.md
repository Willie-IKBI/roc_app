# ROC Current State Map

**Generated:** 2025-01-XX  
**Based on:** Codebase scan + `SUPABASE_SNAPSHOT.md`

---

## 1) What Works Today (Known Working Flows)

### Authentication & User Management
- ✅ Login/Signup/Password Reset (`lib/features/auth/presentation/`)
- ✅ Profile viewing and self-update (`lib/features/profile/`)
- ✅ Role-based navigation (admin vs agent) (`lib/features/shell/presentation/app_shell.dart`)
- ✅ Auth guards in routing (`lib/core/routing/app_router.dart`)

### Claims Management
- ✅ Claim capture flow (`lib/features/claims/presentation/capture_claim_screen.dart`)
- ✅ Claims queue with status filtering (`lib/features/claims/presentation/claims_queue_screen.dart`)
- ✅ Claim detail view (`lib/features/claims/presentation/claim_detail_screen.dart`)
- ✅ Contact attempts logging (`lib/data/datasources/supabase_claim_remote_data_source.dart` - `addContactAttempt`)
- ✅ Claim status updates with history tracking (`lib/data/datasources/supabase_claim_remote_data_source.dart` - `updateClaimStatus`)

### Admin Features
- ✅ User management (`lib/features/admin/presentation/admin_users_screen.dart`)
- ✅ Insurer management (`lib/features/admin/presentation/admin_insurers_screen.dart`)
- ✅ Service provider management (`lib/features/admin/presentation/admin_service_providers_screen.dart`)
- ✅ Brand management (`lib/features/admin/presentation/admin_brands_screen.dart`)
- ✅ SMS template management (`lib/features/admin/presentation/admin_settings_screen.dart`)
- ✅ SLA rules configuration (`lib/features/admin/presentation/admin_settings_screen.dart`)

### Reporting
- ✅ Daily reports (`lib/features/reporting/presentation/reporting_screen.dart`)
- ✅ Agent performance reports (`lib/data/datasources/supabase_reporting_remote_data_source.dart`)
- ✅ Status distribution reports
- ✅ Damage cause reports
- ✅ Geographic reports
- ✅ Insurer performance reports

### Scheduling & Assignments
- ✅ Scheduling screen (`lib/features/scheduling/presentation/scheduling_screen.dart`)
- ✅ Assignment screen (`lib/features/assignments/presentation/assignment_screen.dart`)
- ✅ Technician assignment tracking

### Dashboard
- ✅ Dashboard with claim statistics (`lib/features/dashboard/presentation/dashboard_screen.dart`)

### Data Layer (Properly Architected)
- ✅ Repository pattern implemented (`lib/data/repositories/`)
- ✅ Data source abstraction (`lib/data/datasources/`)
- ✅ Result<T> error handling pattern (`lib/core/utils/result.dart`)
- ✅ RLS policies enforced on all tables (verified in `SUPABASE_SNAPSHOT.md`)

---

## 2) What Is Broken / Flaky (Symptoms + Where)

### Silent Error Handling
**Symptom:** Errors are swallowed, returning empty results instead of error states.

**Locations:**
- `lib/features/claims/controller/map_view_controller.dart` - `claimMapMarkers()` function catches all errors and returns `[]`
- `lib/features/claims/controller/technician_controller.dart` - `technicianAssignments()` returns `{}` on error
- `lib/features/claims/controller/technician_controller.dart` - `technicianAvailability()` returns empty map on error
- `lib/features/claims/controller/reference_data_providers.dart` - `insurersOptionsProvider` and `brandsOptionsProvider` have no error handling

**Impact:** Users see empty data instead of error messages, making debugging difficult.

### Missing Error Handling in Reference Data
**Symptom:** Reference data providers can throw unhandled exceptions.

**Locations:**
- `lib/features/claims/controller/reference_data_providers.dart` - `insurersOptionsProvider` (no try-catch)
- `lib/features/claims/controller/reference_data_providers.dart` - `brandsOptionsProvider` (no try-catch)

**Impact:** App crashes when reference data queries fail.

### Profile Fetch Fallback Logic
**Symptom:** Profile fetch errors return default profile with empty tenantId.

**Location:** `lib/core/providers/current_user_provider.dart` - `_fetchProfile()` function

**Impact:** User may appear authenticated but with invalid tenant, causing RLS policy failures.

### N+1 Query Pattern in Scheduling
**Symptom:** Fetches full claim object for each appointment in a loop.

**Location:** `lib/features/scheduling/controller/scheduling_controller.dart` - `daySchedule()` function loops through appointments and calls `claimRepository.fetchById()` for each

**Impact:** Performance degradation with many appointments.

### Unbounded Queries (Performance Risk)
**Symptom:** Queries can return unlimited results.

**Locations:**
- `lib/data/datasources/supabase_claim_remote_data_source.dart` - `fetchQueue()` has no `.limit()`
- `lib/features/claims/controller/map_view_controller.dart` - `claimMapMarkers()` has no `.limit()`
- `lib/features/scheduling/controller/scheduling_controller.dart` - `daySchedule()` has no `.limit()`

**Impact:** App slows down or crashes with large datasets.

---

## 3) Top 5 Risks (Exact Files/Functions)

### Risk #1: Architectural Violation - Direct Supabase Calls in Controllers
**Severity:** Critical  
**Files:**
- `lib/features/claims/controller/map_view_controller.dart` - `claimMapMarkers()` function
- `lib/features/scheduling/controller/scheduling_controller.dart` - `daySchedule()` function
- `lib/features/claims/controller/technician_controller.dart` - `technicianAssignments()` and `technicianAvailability()` functions
- `lib/features/claims/controller/agent_lookup_provider.dart` - `agentName()` function
- `lib/features/claims/controller/reference_data_providers.dart` - `insurersOptionsProvider` and `brandsOptionsProvider`
- `lib/features/profile/controller/profile_controller.dart` - `updateProfile()` and `_fetchProfile()` functions

**Why:** Violates `DEV_RULES.md` rule: "No direct Supabase calls from UI widgets". Controllers are part of the UI layer. Makes testing impossible, bypasses repository validation, and creates inconsistent patterns.

### Risk #2: Silent Failures Hide Production Bugs
**Severity:** High  
**Files:**
- `lib/features/claims/controller/map_view_controller.dart` - `claimMapMarkers()` catch block returns `[]`
- `lib/features/claims/controller/technician_controller.dart` - Both functions return empty collections on error

**Why:** Errors are swallowed, making production issues invisible. Users see empty data instead of error messages, making debugging impossible.

### Risk #3: Missing Tenant Scoping in Direct Queries
**Severity:** Medium (RLS protects, but defense-in-depth missing)  
**Files:**
- All 6 direct Supabase calls listed in Risk #1

**Why:** While RLS policies enforce tenant isolation at the database level, client-side queries don't explicitly filter by `tenant_id`. If RLS is misconfigured, data could leak. Also makes queries less explicit about intent.

### Risk #4: Unbounded Queries Cause Performance Issues
**Severity:** High  
**Files:**
- `lib/data/datasources/supabase_claim_remote_data_source.dart` - `fetchQueue()` method
- `lib/features/claims/controller/map_view_controller.dart` - `claimMapMarkers()` function
- `lib/features/scheduling/controller/scheduling_controller.dart` - `daySchedule()` function

**Why:** No pagination or limits. Large tenants will cause timeouts, memory issues, and poor UX.

### Risk #5: N+1 Query Pattern in Scheduling
**Severity:** Medium  
**File:** `lib/features/scheduling/controller/scheduling_controller.dart` - `daySchedule()` function

**Why:** Loops through appointments and fetches full claim for each (line ~72). With 50 appointments, this makes 51 queries instead of 1.

---

## 4) Data-Access Inventory: Direct Supabase Calls Outside Data Layer

All direct Supabase calls found in `lib/features/` (controllers/providers):

### Claims Feature
1. **File:** `lib/features/claims/controller/map_view_controller.dart`  
   **Function:** `claimMapMarkers()`  
   **Query Type:** SELECT  
   **Table:** `claims`  
   **Details:** Complex select with joins to `addresses`, `profiles` (technician), `clients`. Filters by status, technician_id. No tenant_id filter. No limit. Returns empty list on error.

2. **File:** `lib/features/claims/controller/technician_controller.dart`  
   **Function:** `technicianAssignments()`  
   **Query Type:** SELECT  
   **Table:** `claims`  
   **Details:** Selects `technician_id` filtered by `appointment_date`. No tenant_id filter. Returns empty map on error.

3. **File:** `lib/features/claims/controller/technician_controller.dart`  
   **Function:** `technicianAvailability()`  
   **Query Type:** SELECT  
   **Table:** `claims`  
   **Details:** Selects `id, appointment_time, status` filtered by `technician_id` and `appointment_date`. No tenant_id filter. Returns empty map on error.

4. **File:** `lib/features/claims/controller/agent_lookup_provider.dart`  
   **Function:** `agentName()`  
   **Query Type:** SELECT  
   **Table:** `profiles`  
   **Details:** Selects `full_name` filtered by `id`. No tenant_id filter. No error handling (throws on error).

5. **File:** `lib/features/claims/controller/reference_data_providers.dart`  
   **Function:** `insurersOptionsProvider` (FutureProvider)  
   **Query Type:** SELECT  
   **Table:** `insurers`  
   **Details:** Selects `id, name` ordered by name. No tenant_id filter. No error handling.

6. **File:** `lib/features/claims/controller/reference_data_providers.dart`  
   **Function:** `brandsOptionsProvider` (FutureProvider)  
   **Query Type:** SELECT  
   **Table:** `brands`  
   **Details:** Selects `id, name` ordered by name. No tenant_id filter. No error handling.

### Scheduling Feature
7. **File:** `lib/features/scheduling/controller/scheduling_controller.dart`  
   **Function:** `daySchedule()`  
   **Query Type:** SELECT  
   **Table:** `claims`  
   **Details:** Complex select with joins to `clients` and `addresses`. Filters by `appointment_date` and `appointment_time IS NOT NULL`. No tenant_id filter. No limit. Then makes N+1 queries to fetch full claims.

### Profile Feature
8. **File:** `lib/features/profile/controller/profile_controller.dart`  
   **Function:** `updateProfile()`  
   **Query Type:** UPDATE  
   **Table:** `profiles`  
   **Details:** Updates `full_name` and `phone` filtered by `id`. Uses `eq('id', previous.id)` which is safe (self-update), but bypasses repository.

9. **File:** `lib/features/profile/controller/profile_controller.dart`  
   **Function:** `_fetchProfile()`  
   **Query Type:** SELECT  
   **Table:** `profiles`  
   **Details:** Selects profile fields filtered by `id` (auth.uid()). Uses `eq('id', user.id)` which is safe, but bypasses repository.

**Summary:** 9 direct Supabase calls across 5 files. All SELECT queries except 1 UPDATE. None have explicit tenant_id filtering (rely on RLS). 5 have no error handling or return empty results on error.

---

## 5) Recommended First "Vertical Slice" to Standardize

### Recommendation: **Reference Data Providers**

**Files to refactor:**
- `lib/features/claims/controller/reference_data_providers.dart`

**Why this slice first:**

1. **Smallest scope** - Only 2 providers (`insurersOptionsProvider`, `brandsOptionsProvider`) + 1 already correct (`estatesOptionsProvider` uses repository)

2. **High impact** - Used in claim capture flow (critical path). Fixing this establishes the pattern for other direct calls.

3. **Clear pattern** - Simple SELECT queries that map perfectly to existing repository pattern:
   - `InsurerAdminRepository` already exists (`lib/data/repositories/insurer_admin_repository_supabase.dart`)
   - `BrandAdminRepository` already exists (`lib/data/repositories/brand_admin_repository_supabase.dart`)

4. **Low risk** - Reference data is read-only, no complex business logic, easy to test.

5. **Establishes precedent** - Shows how to refactor direct calls → repository pattern for the team.

**Refactoring steps:**

1. Create repository methods (if missing):
   - `InsurerAdminRepository.fetchInsurersForOptions()` → returns `List<ReferenceOption>`
   - `BrandAdminRepository.fetchBrandsForOptions()` → returns `List<BrandOption>`

2. Update providers to use repositories:
   ```dart
   final insurersOptionsProvider = FutureProvider.autoDispose<List<ReferenceOption>>((ref) async {
     final repository = ref.watch(insurerAdminRepositoryProvider);
     final result = await repository.fetchInsurersForOptions();
     if (result.isErr) throw result.error; // Proper error handling
     return result.data;
   });
   ```

3. Add error handling (replace silent failures with proper AsyncError states)

4. Add tenant_id filtering (defense in depth, even though RLS handles it)

**Estimated effort:** 2-4 hours  
**Blocks:** Nothing  
**Unblocks:** Pattern for refactoring remaining 7 direct calls

**Next slices (in order):**
- Profile controller (2 calls, self-contained)
- Agent lookup provider (1 call, simple)
- Technician controller (2 calls, related)
- Map view controller (1 call, complex)
- Scheduling controller (1 call, complex + N+1 issue)

---

## Notes

- **RLS Status:** Verified in `SUPABASE_SNAPSHOT.md` - all tables have RLS enabled with proper tenant scoping
- **Repository Pattern:** Well-established in `lib/data/repositories/` - 10+ repositories follow consistent pattern
- **Error Handling:** `Result<T>` pattern is standard in repositories, but not used in direct Supabase calls
- **Testing:** Direct Supabase calls are untestable (can't mock). Repositories are testable.

