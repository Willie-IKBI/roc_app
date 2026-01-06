# Profile Controller Refactor Plan

**Target:** `lib/features/profile/controller/profile_controller.dart`  
**Goal:** Remove all direct Supabase calls while keeping public APIs stable  
**Status:** Plan Only (No Code)

---

## 1. Inventory

### Direct Supabase Calls Found

**Call #1: READ - Fetch Current User Profile**
- **Location:** `lib/features/profile/controller/profile_controller.dart:60-64`
- **Type:** READ
- **Table/View:** `profiles`
- **Query:**
  ```dart
  final data = await client
      .from('profiles')
      .select('id, full_name, phone, role, is_active, tenant_id')
      .eq('id', user.id)
      .maybeSingle();
  ```
- **Context:** `_fetchProfile()` method
- **Returns:** `Profile` (constructed from query result + `user.email` from auth)
- **Error Handling:** 
  - Throws `AuthException('not-authenticated')` if `user == null` (line 57)
  - Throws `AuthException('profile-missing')` if `data == null` (line 67)
- **Dependencies:** Requires `client.auth.currentUser` to get user ID

**Call #2: WRITE - Update Current User Profile**
- **Location:** `lib/features/profile/controller/profile_controller.dart:31-34`
- **Type:** WRITE
- **Table/View:** `profiles`
- **Query:**
  ```dart
  await client.from('profiles').update({
    'full_name': trimmedName,
    'phone': trimmedPhone,
  }).eq('id', previous.id);
  ```
- **Context:** `updateProfile()` method
- **Updates:** `full_name` and `phone` fields for current user
- **Error Handling:** 
  - Catches all errors, sets `AsyncError`, rethrows
  - No silent failures (good)
- **Dependencies:** Uses `previous.id` from current state

**Summary:**
- **Total calls:** 2 (1 READ, 1 WRITE)
- **Table:** `profiles`
- **Auth dependency:** Both require current user ID from `client.auth.currentUser.id`

---

## 2. Ownership Decision

### Repository Assignment

**Both operations → `UserAdminRepository`**

**Rationale:**
- `UserAdminRepository` already exists and handles profile operations
- Has `fetchUserById(String userId)` - perfect for READ operation
- Has `updateDetails({required String userId, required String fullName, String? phone})` - perfect for WRITE operation
- Both methods already return `Result<T>` with proper error handling
- No need to create a new `ProfileRepository` - `UserAdminRepository` is the appropriate owner

**Repository Location:**
- **Interface:** `lib/domain/repositories/user_admin_repository.dart`
- **Implementation:** `lib/data/repositories/user_admin_repository_supabase.dart`
- **Provider:** `userAdminRepositoryProvider` (already exists)

**Existing Methods to Use:**
1. `fetchUserById(String userId) -> Future<Result<Profile?>>`
   - Fetches profile by ID
   - Returns `null` if not found (handled as error in controller)
   - Returns `Profile` domain model
   - Already handles errors via `Result<T>`

2. `updateDetails({required String userId, required String fullName, String? phone}) -> Future<Result<void>>`
   - Updates profile details (full_name, phone)
   - Takes userId (controller will pass current user ID)
   - Returns `Result<void>` (success/error)
   - Already handles errors via `Result<T>`

**No new repository needed** - existing `UserAdminRepository` is appropriate.

---

## 3. Repository/API Shape

### Current Repository Methods (Already Exist)

**Method 1: `fetchUserById`**
```dart
/// Fetch a single user profile by ID
/// 
/// Returns the profile if found, null if not found.
/// Errors are propagated (no silent failures).
Future<Result<Profile?>> fetchUserById(String userId);
```

**Status:** ✅ Already exists, no changes needed

**Method 2: `updateDetails`**
```dart
Future<Result<void>> updateDetails({
  required String userId,
  required String fullName,
  String? phone,
});
```

**Status:** ✅ Already exists, no changes needed

**Verification:**
- Both methods enforce single-row queries (by `id`)
- Both use `Result<T>` for error handling
- Both propagate errors (no silent failures)
- `fetchUserById` uses `.maybeSingle()` (safe for single-row queries)
- `updateDetails` uses `.eq('id', userId)` (safe for single-row updates)

**No repository changes needed** - existing API is sufficient.

---

## 4. Controller Changes

### Current Controller Structure

**Public API (Must Remain Stable):**
- `profileControllerProvider` - `AsyncNotifierProvider<ProfileController, Profile>`
- `build()` - Returns `Future<Profile>` (initial load)
- `updateProfile({required String fullName, String? phone})` - Returns `Future<void>`
- `refresh()` - Returns `Future<void>`

**Current Implementation:**
- Uses `supabaseClientProvider` directly
- Gets current user ID from `client.auth.currentUser.id`
- Constructs `Profile` with email from `user.email`
- Throws `AuthException` for auth-related errors

### Proposed Changes

**1. Remove Direct Supabase Imports:**
- Remove: `import 'package:supabase_flutter/supabase_flutter.dart';` (line 2)
- Keep: `import '../../../data/clients/supabase_client.dart';` (needed for `client.auth.currentUser`)

**2. Add Repository Dependency:**
- Add: `import '../../../data/repositories/user_admin_repository_supabase.dart';`
- Use: `ref.watch(userAdminRepositoryProvider)` or `ref.read(userAdminRepositoryProvider)`

**3. Update `_fetchProfile()` Method:**

**Before:**
```dart
Future<Profile> _fetchProfile() async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) {
    throw const AuthException('not-authenticated');
  }

  final data = await client
      .from('profiles')
      .select('id, full_name, phone, role, is_active, tenant_id')
      .eq('id', user.id)
      .maybeSingle();

  if (data == null) {
    throw const AuthException('profile-missing');
  }

  final map = Map<String, dynamic>.from(data as Map);
  final isActive = (map['is_active'] as bool?) ?? true;
  return Profile(
    id: user.id,
    email: user.email ?? '',
    fullName: (map['full_name'] as String?)?.trim() ?? '',
    phone: (map['phone'] as String?)?.trim(),
    role: (map['role'] as String?) ?? 'agent',
    isActive: isActive,
    tenantId: (map['tenant_id'] as String?) ?? '',
  );
}
```

**After:**
```dart
Future<Profile> _fetchProfile() async {
  final client = ref.watch(supabaseClientProvider);
  final user = client.auth.currentUser;
  if (user == null) {
    throw const AuthException('not-authenticated');
  }

  final repository = ref.read(userAdminRepositoryProvider);
  final result = await repository.fetchUserById(user.id);

  if (result.isErr) {
    // Map repository errors to AuthException for consistency
    final error = result.error!;
    if (error is AuthError) {
      throw AuthException(error.code);
    }
    // For other errors, wrap in AuthException with generic message
    throw AuthException('profile-fetch-failed');
  }

  final profile = result.data;
  if (profile == null) {
    throw const AuthException('profile-missing');
  }

  // Ensure email is populated from auth user (same as current behavior)
  return Profile(
    id: profile.id,
    email: user.email ?? profile.email,
    fullName: profile.fullName,
    phone: profile.phone,
    role: profile.role,
    isActive: profile.isActive,
    tenantId: profile.tenantId,
  );
}
```

**4. Update `updateProfile()` Method:**

**Before:**
```dart
Future<void> updateProfile({
  required String fullName,
  String? phone,
}) async {
  final previous = state.maybeWhen(
    data: (profile) => profile,
    orElse: () => null,
  ) ??
      await future;
  state = const AsyncLoading();
  final client = ref.read(supabaseClientProvider);
  final trimmedName = fullName.trim();
  final trimmedPhone = phone?.trim().isEmpty ?? true ? null : phone!.trim();

  try {
    await client.from('profiles').update({
      'full_name': trimmedName,
      'phone': trimmedPhone,
    }).eq('id', previous.id);

    state = AsyncData(
      previous.copyWith(
        fullName: trimmedName,
        phone: trimmedPhone,
      ),
    );
  } catch (error, stackTrace) {
    state = AsyncError(error, stackTrace);
    rethrow;
  }
}
```

**After:**
```dart
Future<void> updateProfile({
  required String fullName,
  String? phone,
}) async {
  final previous = state.maybeWhen(
    data: (profile) => profile,
    orElse: () => null,
  ) ??
      await future;
  state = const AsyncLoading();
  
  final trimmedName = fullName.trim();
  final trimmedPhone = phone?.trim().isEmpty ?? true ? null : phone!.trim();

  final repository = ref.read(userAdminRepositoryProvider);
  final result = await repository.updateDetails(
    userId: previous.id,
    fullName: trimmedName,
    phone: trimmedPhone,
  );

  if (result.isErr) {
    // Map repository errors to exceptions (preserve current behavior)
    final error = result.error!;
    final exception = error is AuthError
        ? AuthException(error.code)
        : Exception(error.message);
    state = AsyncError(exception, StackTrace.current);
    throw exception;
  }

  // Update state with new values (same as current behavior)
  state = AsyncData(
    previous.copyWith(
      fullName: trimmedName,
      phone: trimmedPhone,
    ),
  );
}
```

### Error Handling Strategy

**Current Pattern:**
- Throws `AuthException` for auth-related errors
- Uses `AsyncError` for async errors
- No silent failures (good)

**New Pattern (Maintain Consistency):**
- Map `Result.err` to exceptions (preserve current behavior)
- Map `AuthError` → `AuthException` (preserve error types)
- Map other `DomainError` → `Exception` (generic exception)
- Use `AsyncError` for async state (preserve current pattern)
- No silent failures (maintain current behavior)

**Note:** The controller currently throws `AuthException` which is from `supabase_flutter`. We should check if this needs to be replaced with `AuthError` from domain, or if we keep `AuthException` for backward compatibility.

---

## 5. Migration Checklist

### Phase 1: Preparation (No Code Changes)

- [ ] **Verify repository methods exist:**
  - [ ] Confirm `UserAdminRepository.fetchUserById()` exists and works
  - [ ] Confirm `UserAdminRepository.updateDetails()` exists and works
  - [ ] Test both methods manually (if possible) to ensure they work correctly

- [ ] **Check AuthException usage:**
  - [ ] Verify if `AuthException` is from `supabase_flutter` or custom
  - [ ] Check if UI/other code depends on `AuthException` type
  - [ ] Decide: keep `AuthException` or migrate to `AuthError`?

- [ ] **Review current user access pattern:**
  - [ ] Verify `client.auth.currentUser` is the standard way to get current user ID
  - [ ] Check if there's a provider/helper for current user ID (like `currentUserProvider`)

### Phase 2: Update Controller (Small Commits)

**Commit 1: Add repository dependency**
- [ ] Add import for `userAdminRepositoryProvider`
- [ ] Remove unused Supabase import (if `AuthException` is not from supabase)
- [ ] Verify no compilation errors
- [ ] Run `flutter analyze` - should pass

**Commit 2: Refactor `_fetchProfile()` method**
- [ ] Replace direct Supabase query with `repository.fetchUserById(userId)`
- [ ] Map `Result<Profile?>` to `Profile` (handle null case)
- [ ] Map repository errors to `AuthException` (preserve error types)
- [ ] Preserve email population from `user.email`
- [ ] Test: Verify profile loads correctly
- [ ] Test: Verify error handling (not-authenticated, profile-missing)
- [ ] Run `flutter analyze` - should pass

**Commit 3: Refactor `updateProfile()` method**
- [ ] Replace direct Supabase update with `repository.updateDetails(...)`
- [ ] Map `Result<void>` to success/error
- [ ] Map repository errors to exceptions (preserve current behavior)
- [ ] Preserve state update logic (same as current)
- [ ] Test: Verify profile updates correctly
- [ ] Test: Verify error handling (network error, permission error)
- [ ] Run `flutter analyze` - should pass

**Commit 4: Cleanup**
- [ ] Remove any remaining unused Supabase imports
- [ ] Verify no direct Supabase calls remain (grep for `.from('profiles')`)
- [ ] Run `flutter analyze` - should pass
- [ ] Run `flutter test` (if tests exist for profile controller)

### Phase 3: Verification

**Functional Testing:**
- [ ] **Profile Load:**
  - [ ] Open profile screen - profile loads correctly
  - [ ] Verify all fields display correctly (name, phone, email, role, etc.)
  - [ ] Test with authenticated user
  - [ ] Test error case: sign out, try to load profile (should show error)

- [ ] **Profile Update:**
  - [ ] Update full name - changes persist
  - [ ] Update phone - changes persist
  - [ ] Update both - both changes persist
  - [ ] Clear phone (set to empty) - phone becomes null
  - [ ] Test error case: network error during update (should show error, state reverts)

- [ ] **Refresh:**
  - [ ] Call `refresh()` - profile reloads
  - [ ] Verify state updates correctly

**Code Quality:**
- [ ] `flutter analyze` passes with 0 errors
- [ ] No direct Supabase calls in `profile_controller.dart` (grep verification)
- [ ] All errors propagate (no silent failures)
- [ ] Public API unchanged (provider, methods, return types)

**Architecture Compliance:**
- [ ] ✅ No direct Supabase calls in controller
- [ ] ✅ All queries go through repository layer
- [ ] ✅ Error handling via `Result<T>` pattern
- [ ] ✅ Errors propagate to UI (no silent failures)

### Done Criteria

**Must Have:**
- ✅ Zero direct Supabase calls in `profile_controller.dart`
- ✅ All operations use `UserAdminRepository`
- ✅ `flutter analyze` passes with 0 errors
- ✅ Profile screen loads and updates work correctly
- ✅ Error handling works (auth errors, network errors)
- ✅ Public API unchanged (no breaking changes)

**Nice to Have:**
- ✅ All tests pass (if tests exist)
- ✅ No unused imports
- ✅ Code follows existing patterns (error mapping, state management)

---

## 6. Notes

### AuthException vs AuthError

**Current Code:**
- Uses `AuthException` from `supabase_flutter` (line 57, 67)
- Throws `AuthException('not-authenticated')` and `AuthException('profile-missing')`

**Repository:**
- Returns `Result<Profile?>` with `AuthError` (domain error)

**Decision:**
- **Option A:** Keep `AuthException` (backward compatibility, but depends on supabase_flutter)
- **Option B:** Migrate to `AuthError` (cleaner, but may require UI changes)

**Recommendation:** Start with Option A (map `AuthError` → `AuthException`) to maintain backward compatibility. Migrate to `AuthError` in a separate refactor if needed.

### Current User ID Access

**Current Pattern:**
```dart
final client = ref.watch(supabaseClientProvider);
final user = client.auth.currentUser;
if (user == null) {
  throw const AuthException('not-authenticated');
}
final userId = user.id;
```

**Alternative:**
- Could use `currentUserProvider` (already exists in `lib/core/providers/current_user_provider.dart`)
- But `currentUserProvider` returns `Future<Profile?>` (already fetched profile)
- Controller needs just the ID, so current pattern is fine

**Decision:** Keep current pattern (get user ID from `client.auth.currentUser.id`). This is acceptable since it's auth-only access, not a direct query.

### Email Population

**Current Behavior:**
- Profile controller gets email from `user.email` (auth user)
- Repository returns `Profile` with email from database
- Controller uses `user.email ?? profile.email` (auth email takes precedence)

**Repository Behavior:**
- `fetchUserById` returns `Profile` with email from database
- Email may be null/empty in database

**Decision:** Preserve current behavior - use `user.email ?? profile.email` to ensure email is always populated from auth user.

---

## 7. Risk Assessment

### Low Risk
- ✅ Repository methods already exist and are tested
- ✅ Error handling pattern is clear (Result<T> → exceptions)
- ✅ Public API unchanged (no breaking changes)

### Medium Risk
- ⚠️ Error type mapping (`AuthError` → `AuthException`) - need to verify UI handles both
- ⚠️ Email population logic - need to ensure email is always available

### Mitigation
- Test error cases thoroughly (auth errors, network errors)
- Verify email is always populated (test with/without email in database)
- Keep `AuthException` for backward compatibility (can migrate later)

---

## 8. Summary

**Changes Required:**
1. Replace 2 direct Supabase calls with repository calls
2. Map `Result<T>` to exceptions (preserve current error behavior)
3. Preserve email population from auth user

**Repository:**
- Use existing `UserAdminRepository` (no new repository needed)
- Use `fetchUserById()` for READ
- Use `updateDetails()` for WRITE

**Public API:**
- No changes (provider, methods, return types all unchanged)

**Estimated Effort:**
- 1-2 hours (small refactor, well-defined scope)



