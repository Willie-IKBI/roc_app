# Codebase Compliance Sweep

**Date:** 2025-01-XX  
**Scope:** Architecture rules compliance across entire codebase

---

## Summary

**Total Issues Found:** 6  
**Critical:** 2  
**Medium:** 2  
**Low:** 2

**Quick Wins (≤30 min):** 2  
**Medium Items (1-2 hours):** 2  
**Low Priority:** 2

---

## 1. Direct Supabase Client Usage Outside Data Sources/Repositories

### ❌ **CRITICAL** - Controller Violations

#### Issue #1: `agent_lookup_provider.dart`
**File:** `lib/features/claims/controller/agent_lookup_provider.dart`  
**Lines:** 13-18  
**Pattern:** `supabaseClientProvider` + `.from('profiles').select()`  
**Severity:** **CRITICAL** (UI/controller)

**Code:**
```dart
final client = ref.watch(supabaseClientProvider);
final data = await client
    .from('profiles')
    .select('full_name')
    .eq('id', agentId)
    .maybeSingle();
```

**Issue:** Direct Supabase query in controller violates clean architecture.  
**Recommendation:** Create `UserRepository.fetchUserById()` or `ProfileRepository.fetchProfileById()` and use it.  
**Effort:** Quick win (≤30 min)

---

#### Issue #2: `profile_controller.dart`
**File:** `lib/features/profile/controller/profile_controller.dart`  
**Lines:** 26-34, 54-64  
**Pattern:** `supabaseClientProvider` + `.from('profiles').update()` / `.select()`  
**Severity:** **CRITICAL** (UI/controller)

**Code:**
```dart
// Line 26-34: Update
final client = ref.read(supabaseClientProvider);
await client.from('profiles').update({...}).eq('id', previous.id);

// Line 54-64: Fetch
final client = ref.watch(supabaseClientProvider);
final data = await client
    .from('profiles')
    .select('id, full_name, phone, role, is_active, tenant_id')
    .eq('id', user.id)
    .maybeSingle();
```

**Issue:** Direct Supabase queries in controller violate clean architecture.  
**Recommendation:** Create `ProfileRepository.fetchProfile()` and `ProfileRepository.updateProfile()` and use them.  
**Effort:** Medium (1-2 hours) - requires repository creation

---

### ⚠️ **MEDIUM** - Core Provider Violations

#### Issue #3: `current_user_provider.dart`
**File:** `lib/core/providers/current_user_provider.dart`  
**Lines:** 51-73, 69-73  
**Pattern:** `supabaseClientProvider` + `.from('profiles').select()`  
**Severity:** **MEDIUM** (feature controller - core provider)

**Code:**
```dart
final client = ref.watch(supabaseClientProvider);
final data = await client
    .from('profiles')
    .select('id, full_name, phone, role, is_active, tenant_id')
    .eq('id', user.id)
    .maybeSingle();
```

**Issue:** Direct Supabase query in core provider. While this is a core provider, it still violates clean architecture.  
**Recommendation:** Create `ProfileRepository.fetchProfileById()` and use it.  
**Note:** This provider is used throughout the app, so changes need careful testing.  
**Effort:** Medium (1-2 hours) - requires repository creation + careful testing

---

### ✅ **LOW** - Acceptable Usage (Auth Only)

#### Issue #4: `auth_controller.dart`
**File:** `lib/features/auth/controller/auth_controller.dart`  
**Lines:** 16, 39, 64, 97  
**Pattern:** `supabaseClientProvider` + `.auth` only  
**Severity:** **LOW** (legacy/deprecated - acceptable)

**Code:**
```dart
final auth = ref.read(supabaseClientProvider).auth;
```

**Issue:** Uses Supabase client but only for auth operations (`.auth`), not direct queries.  
**Recommendation:** **ACCEPTABLE** - Auth operations are an exception to the rule.  
**Effort:** None (acceptable pattern)

---

#### Issue #5: `app_router.dart`
**File:** `lib/core/routing/app_router.dart`  
**Lines:** 41, 47  
**Pattern:** `supabaseClientProvider` + `.auth` only  
**Severity:** **LOW** (legacy/deprecated - acceptable)

**Code:**
```dart
final client = ref.watch(supabaseClientProvider);
ref.watch(supabaseClientProvider).auth.onAuthStateChange,
```

**Issue:** Uses Supabase client but only for auth operations (`.auth`), not direct queries.  
**Recommendation:** **ACCEPTABLE** - Auth operations are an exception to the rule.  
**Effort:** None (acceptable pattern)

---

#### Issue #6: `app_shell.dart`
**File:** `lib/features/shell/presentation/app_shell.dart`  
**Lines:** 95  
**Pattern:** `supabaseClientProvider` + `.auth` only  
**Severity:** **LOW** (legacy/deprecated - acceptable)

**Code:**
```dart
final client = ref.read(supabaseClientProvider);
await client.auth.signOut();
```

**Issue:** Uses Supabase client but only for auth operations (`.auth`), not direct queries.  
**Recommendation:** **ACCEPTABLE** - Auth operations are an exception to the rule.  
**Effort:** None (acceptable pattern)

---

## 2. Silent Failure Patterns

### ❌ **MEDIUM** - Silent Failure in Core Provider

#### Issue #7: `current_user_provider.dart`
**File:** `lib/core/providers/current_user_provider.dart`  
**Lines:** 111-138  
**Pattern:** `catch (e, stackTrace) { return Profile(...); }`  
**Severity:** **MEDIUM**

**Code:**
```dart
} catch (e, stackTrace) {
  // Handle database/network errors gracefully
  developer.log('Error fetching user profile: $e', ...);
  
  // Return a default profile based on auth user to prevent app crash
  // This allows the app to continue functioning even if profile fetch fails
  return Profile(
    id: user.id,
    email: user.email ?? '',
    fullName: user.email ?? '',
    phone: null,
    role: 'agent',
    isActive: true,
    tenantId: '',
  );
}
```

**Issue:** Silent failure - returns default profile instead of throwing error. This hides database/network errors from the UI.  
**Recommendation:** Convert to `AsyncError` - throw the error and let Riverpod handle it. The UI should show an error state, not a default profile.  
**Rationale:** While the comment says "prevent app crash", Riverpod's `AsyncError` already handles errors gracefully. Users should know when profile fetch fails.  
**Effort:** Quick win (≤30 min) - change `return Profile(...)` to `throw e;`

---

## 3. Unbounded Query Patterns

### ❌ **CRITICAL** - Unbounded Dashboard Summary Query

#### Issue #8: `supabase_dashboard_remote_data_source.dart`
**File:** `lib/data/datasources/supabase_dashboard_remote_data_source.dart`  
**Lines:** 17-21  
**Pattern:** `.select(...)` without `.limit()`  
**Severity:** **CRITICAL**

**Code:**
```dart
final data = await _client
    .from('v_claims_list')
    .select('status, priority, sla_started_at, latest_contact_attempt_at')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value);
// NO LIMIT!
```

**Issue:** Unbounded query - fetches ALL active claims without limit. This could return thousands of rows.  
**Recommendation:** Add a hard limit (e.g., 10,000 max) with warning log if limit reached. This is a summary query, so a high limit is acceptable, but it must be bounded.  
**Effort:** Quick win (≤30 min) - add `.limit(10000)` and warning log

---

### ⚠️ **LOW** - Single-Claim Query (Acceptable)

#### Issue #9: `supabase_claim_remote_data_source.dart`
**File:** `lib/data/datasources/supabase_claim_remote_data_source.dart`  
**Lines:** 268-272  
**Pattern:** `.select(...)` without `.limit()`  
**Severity:** **LOW** (acceptable)

**Code:**
```dart
final data = await _client
    .from('contact_attempts')
    .select('id, tenant_id, claim_id, attempted_by, attempted_at, method, outcome, notes')
    .eq('claim_id', claimId)
    .order('attempted_at', ascending: false);
// NO LIMIT!
```

**Issue:** No limit on contact attempts query, but it's filtered by single `claim_id`.  
**Recommendation:** **ACCEPTABLE** - Single-claim queries are typically bounded by data volume (a claim won't have thousands of contact attempts). However, consider adding a safety limit (e.g., 100) for defense in depth.  
**Effort:** Optional (low priority) - add `.limit(100)` for safety

---

### ✅ **LOW** - Backward Compatibility Methods (Acceptable)

#### Issue #10: `supabase_reporting_remote_data_source.dart`
**File:** `lib/data/datasources/supabase_reporting_remote_data_source.dart`  
**Lines:** 1051, 1134  
**Pattern:** `.limit(1000)`  
**Severity:** **LOW** (acceptable)

**Code:**
```dart
// Line 1051: _fetchInsurerDamageCauseDirect()
.limit(1000);

// Line 1134: _fetchInsurerStatusDirect()
.limit(1000);
```

**Issue:** Hard limit of 1000 in backward compatibility methods.  
**Recommendation:** **ACCEPTABLE** - These are backward compatibility methods (not part of paginated interface), and 1000 is a reasonable limit for reference data.  
**Effort:** None (acceptable pattern)

---

## 4. Summary by Category

### Direct Supabase Usage
- **Critical:** 2 (agent_lookup_provider, profile_controller)
- **Medium:** 1 (current_user_provider)
- **Low:** 3 (auth_controller, app_router, app_shell - all acceptable)

### Silent Failures
- **Medium:** 1 (current_user_provider)

### Unbounded Queries
- **Critical:** 1 (dashboard summary)
- **Low:** 1 (contact attempts - acceptable), 2 (backward compatibility - acceptable)

---

## 5. Top 5 Highest-Risk Items

### 1. **CRITICAL:** Dashboard Summary Unbounded Query
**File:** `lib/data/datasources/supabase_dashboard_remote_data_source.dart:17-21`  
**Risk:** Could fetch thousands of rows, causing performance issues and potential timeouts.  
**Fix:** Add `.limit(10000)` with warning log.  
**Effort:** ≤30 min

### 2. **CRITICAL:** Agent Lookup Direct Supabase Call
**File:** `lib/features/claims/controller/agent_lookup_provider.dart:13-18`  
**Risk:** Violates clean architecture, makes testing difficult, bypasses business logic.  
**Fix:** Create `UserRepository.fetchUserById()` or `ProfileRepository.fetchProfileById()`.  
**Effort:** ≤30 min

### 3. **CRITICAL:** Profile Controller Direct Supabase Calls
**File:** `lib/features/profile/controller/profile_controller.dart:26-34, 54-64`  
**Risk:** Violates clean architecture, makes testing difficult, bypasses business logic.  
**Fix:** Create `ProfileRepository` with `fetchProfile()` and `updateProfile()`.  
**Effort:** 1-2 hours

### 4. **MEDIUM:** Current User Provider Direct Supabase Call
**File:** `lib/core/providers/current_user_provider.dart:51-73`  
**Risk:** Violates clean architecture, but is a core provider used throughout the app.  
**Fix:** Create `ProfileRepository.fetchProfileById()` and use it.  
**Effort:** 1-2 hours (requires careful testing)

### 5. **MEDIUM:** Current User Provider Silent Failure
**File:** `lib/core/providers/current_user_provider.dart:111-138`  
**Risk:** Hides errors from users, makes debugging difficult.  
**Fix:** Change `return Profile(...)` to `throw e;` to propagate error as `AsyncError`.  
**Effort:** ≤30 min

---

## 6. Quick Wins (≤30 Minutes)

### ✅ Quick Win #1: Fix Dashboard Summary Unbounded Query
**File:** `lib/data/datasources/supabase_dashboard_remote_data_source.dart`  
**Lines:** 17-21  
**Change:**
```dart
// Before:
final data = await _client
    .from('v_claims_list')
    .select('status, priority, sla_started_at, latest_contact_attempt_at')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value);

// After:
const maxLimit = 10000;
final data = await _client
    .from('v_claims_list')
    .select('status, priority, sla_started_at, latest_contact_attempt_at')
    .neq('status', ClaimStatus.closed.value)
    .neq('status', ClaimStatus.cancelled.value)
    .limit(maxLimit);

if ((data as List).length >= maxLimit) {
  AppLogger.warn(
    'fetchDashboardSummary() returned $maxLimit results (limit reached). Summary may be incomplete.',
    name: 'SupabaseDashboardRemoteDataSource',
  );
}
```

---

### ✅ Quick Win #2: Fix Agent Lookup Direct Supabase Call
**File:** `lib/features/claims/controller/agent_lookup_provider.dart`  
**Lines:** 13-18  
**Change:**
```dart
// Before:
final client = ref.watch(supabaseClientProvider);
final data = await client
    .from('profiles')
    .select('full_name')
    .eq('id', agentId)
    .maybeSingle();

// After:
final repository = ref.watch(userAdminRepositoryProvider);
final result = await repository.fetchUserById(agentId);
if (result.isErr) {
  return null;
}
return result.data.fullName;
```

**Note:** Requires `UserAdminRepository.fetchUserById()` method. If it doesn't exist, create it (adds ~15 min).

---

### ✅ Quick Win #3: Fix Current User Provider Silent Failure
**File:** `lib/core/providers/current_user_provider.dart`  
**Lines:** 111-138  
**Change:**
```dart
// Before:
} catch (e, stackTrace) {
  developer.log('Error fetching user profile: $e', ...);
  return Profile(...); // Silent failure
}

// After:
} catch (e, stackTrace) {
  developer.log('Error fetching user profile: $e', ...);
  rethrow; // Propagate error as AsyncError
}
```

---

## 7. Medium Items (1-2 Hours)

### ⚠️ Medium Item #1: Fix Profile Controller Direct Supabase Calls
**File:** `lib/features/profile/controller/profile_controller.dart`  
**Steps:**
1. Create `ProfileRepository` interface in `lib/domain/repositories/profile_repository.dart`
2. Create `ProfileRepositorySupabase` implementation in `lib/data/repositories/profile_repository_supabase.dart`
3. Create `ProfileRemoteDataSource` interface and implementation
4. Update `profile_controller.dart` to use repository
5. Test profile fetch and update flows

**Estimated Time:** 1-2 hours

---

### ⚠️ Medium Item #2: Fix Current User Provider Direct Supabase Call
**File:** `lib/core/providers/current_user_provider.dart`  
**Steps:**
1. Create `ProfileRepository.fetchProfileById()` (or reuse from Medium Item #1)
2. Update `current_user_provider.dart` to use repository
3. Test auth flows (login, logout, session expiration)
4. Test error states (network failure, profile missing)

**Estimated Time:** 1-2 hours (requires careful testing due to core provider usage)

---

## 8. Prioritized Checklist

### Phase 1: Critical Fixes (Do First)
- [ ] **CRITICAL:** Fix dashboard summary unbounded query (≤30 min)
- [ ] **CRITICAL:** Fix agent lookup direct Supabase call (≤30 min)
- [ ] **MEDIUM:** Fix current user provider silent failure (≤30 min)

### Phase 2: Architecture Compliance (Next Sprint)
- [ ] **CRITICAL:** Fix profile controller direct Supabase calls (1-2 hours)
- [ ] **MEDIUM:** Fix current user provider direct Supabase call (1-2 hours)

### Phase 3: Optional Improvements (Backlog)
- [ ] **LOW:** Add safety limit to contact attempts query (optional, ≤15 min)

### Phase 4: Verification
- [ ] Run `flutter analyze` (must pass)
- [ ] Test all affected flows:
  - [ ] Dashboard loads correctly
  - [ ] Agent lookup works in claim details
  - [ ] Profile fetch/update works
  - [ ] Current user provider handles errors correctly
- [ ] Verify no new direct Supabase calls introduced

---

## 9. Notes

### Acceptable Patterns
- **Auth operations:** Using `supabaseClientProvider.auth` is acceptable (auth_controller, app_router, app_shell)
- **Backward compatibility methods:** `.limit(1000)` in legacy methods is acceptable
- **Single-claim queries:** Unbounded queries filtered by single `claim_id` are generally acceptable (but consider safety limits)

### Architecture Exceptions
- **Core providers:** `current_user_provider` is a core provider, but should still follow clean architecture. The fix requires careful testing due to widespread usage.

### Testing Requirements
- All fixes must pass `flutter analyze`
- All affected flows must be manually tested
- Error states must be verified (network failures, missing data, etc.)

---

## Summary

**Total Issues:** 6 violations (2 critical, 2 medium, 2 low/acceptable)  
**Quick Wins:** 3 items (≤30 min each)  
**Medium Items:** 2 items (1-2 hours each)  
**Low Priority:** 1 item (optional)

**Recommended Action:** Fix Phase 1 items immediately (all ≤30 min), then tackle Phase 2 in next sprint.

