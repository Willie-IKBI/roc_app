# Error Triage - ROC Codebase

**Date:** 2025-01-XX  
**Total Issues:** 144 (17 errors, 40 warnings, 87 info)

---

## 1. Categorized Errors by Type

### 🔴 **BLOCKERS (Runtime Errors - Prevent Compilation)**

#### A. Missing Import Path (1 error)
- **File:** `lib/data/datasources/claim_remote_data_source.dart:11`
- **Error:** `Target of URI doesn't exist: '../models/paginated_result.dart'`
- **Impact:** Prevents compilation of data source layer
- **Root Cause:** Wrong relative path - should be `../../domain/models/paginated_result.dart`

#### B. Missing Freezed Generated Code (2 errors)
- **File:** `lib/domain/models/paginated_result.dart:12`
- **Error:** `Missing concrete implementations of 'getter mixin _$PaginatedResult<T>...`
- **Impact:** PaginatedResult class cannot be instantiated
- **Root Cause:** Missing generated freezed code - need to run `flutter pub run build_runner build`

- **File:** `lib/features/claims/controller/queue_controller.dart:14`
- **Error:** `Missing concrete implementations of 'getter mixin _$ClaimsQueueState...`
- **Impact:** ClaimsQueueState cannot be used
- **Root Cause:** Missing generated freezed code - need to run `flutter pub run build_runner build`

#### C. Undefined Method/Getter (6 errors)
- **Files:**
  - `lib/features/claims/controller/queue_controller.dart:37,73,119` (3 errors)
- **Error:** `The getter 'valueOrNull' isn't defined for the type 'AsyncValue<ClaimsQueueState>'`
- **Impact:** Queue controller cannot access state values
- **Root Cause:** `valueOrNull` is not a standard Riverpod extension - should use `state.value` or `state.asData?.value`

#### D. JavaScript Interop Issues (11 errors)
- **Files:**
  - `lib/core/utils/places_web_service.dart:74,84,223,245,513,517,707,711,809,813` (10 errors)
  - `lib/core/widgets/interactive_map_widget.dart:184,288` (2 errors)
- **Error:** `The method/function 'allowInterop' isn't defined`
- **Impact:** Google Maps Places API integration broken, map widgets broken
- **Root Cause:** `allowInterop` should be `js.allowInterop` (from `dart:js`) or needs proper import

#### E. Type Assignment Errors (3 errors)
- **File:** `lib/data/datasources/supabase_claim_remote_data_source.dart:55,63,69`
- **Error:** `A value of type 'PostgrestTransformBuilder<PostgrestList>' can't be assigned to a variable of type 'PostgrestFilterBuilder<PostgrestList>'`
- **Impact:** Pagination query builder broken
- **Root Cause:** `.or()` method returns `PostgrestTransformBuilder` but variable expects `PostgrestFilterBuilder` - type mismatch in Supabase client usage

---

### 🟡 **NON-BLOCKERS (Warnings/Info - Don't Prevent Runtime)**

#### F. Deprecated API Usage (47 info)
- **Files:** Multiple (dart:html, dart:js, fetchQueue, rocTheme, etc.)
- **Impact:** Future compatibility issues, but code works now
- **Priority:** Low (can migrate gradually)

#### G. Unused Code (40 warnings)
- **Files:** Multiple (unused imports, variables, fields)
- **Impact:** Code bloat, minor performance
- **Priority:** Low (cleanup task)

#### H. Code Quality (57 info)
- **Files:** Multiple (prefer_interpolation, unnecessary_import, etc.)
- **Impact:** Code style, maintainability
- **Priority:** Very Low (style guide compliance)

---

## 2. Blocker vs Non-Blocking Classification

### 🔴 **BLOCKERS (17 errors)**
**Must fix to compile/run:**
- ✅ A. Missing import path (1)
- ✅ B. Missing freezed code (2) 
- ✅ C. Undefined valueOrNull (3)
- ✅ D. JavaScript interop (11)
- ✅ E. Type assignment (3)

### 🟡 **NON-BLOCKERS (127 issues)**
**Code compiles/runs but has warnings:**
- Deprecated API usage (47)
- Unused code (40)
- Code quality (40)

---

## 3. Quick Fixes (≤30 minutes)

### Fix #1: Correct Import Path (2 min)
**File:** `lib/data/datasources/claim_remote_data_source.dart:11`
```dart
// Change:
import '../models/paginated_result.dart';
// To:
import '../../domain/models/paginated_result.dart';
```

### Fix #2: Run Build Runner (5 min)
**Command:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
**Fixes:** PaginatedResult and ClaimsQueueState missing implementations

### Fix #3: Fix valueOrNull Usage (10 min)
**File:** `lib/features/claims/controller/queue_controller.dart`
**Lines:** 37, 73, 119

**Change:**
```dart
// From:
state.valueOrNull?.copyWith(...)
// To:
state.asData?.value.copyWith(...) ?? ClaimsQueueState(...)
```

**Or use pattern:**
```dart
final currentState = state.asData?.value ?? ClaimsQueueState();
state = AsyncValue.data(currentState.copyWith(...));
```

### Fix #4: Fix allowInterop Calls (10 min)
**Files:** 
- `lib/core/utils/places_web_service.dart` (10 calls) - has `import 'dart:js' as js;` but calls `allowInterop` without prefix
- `lib/core/widgets/interactive_map_widget.dart` (2 calls) - already correct (`js.allowInterop`)

**Change in places_web_service.dart:**
```dart
// From:
final onSuccess = allowInterop(() { ... });
// To:
final onSuccess = js.allowInterop(() { ... });
```

**Note:** File already has `import 'dart:js' as js;` - just need to add `js.` prefix to calls.

### Fix #5: Fix Postgrest Type Assignment (3 min)
**File:** `lib/data/datasources/supabase_claim_remote_data_source.dart`
**Lines:** 55, 63, 69

**Change:**
```dart
// From:
var query = _client.from('v_claims_list').select('*');
// ... filters ...
query = query.or(...).order(...);  // Type mismatch here

// To:
var query = _client.from('v_claims_list').select('*');
// ... filters ...
final orderedQuery = query.or(...).order(...);  // Don't reassign, use new variable
final data = await orderedQuery.limit(pageSize + 1);
```

**Or chain directly:**
```dart
final data = await query
    .or(...)
    .order('sla_started_at', ascending: true)
    .order('claim_id', ascending: true)
    .limit(pageSize + 1);
```

**Total Estimated Time:** ~30 minutes

---

## 4. Backlog Items (Prioritized)

### 🔴 **HIGH PRIORITY (Future Blockers)**

#### H1. Postgrest Type Safety
- **Issue:** Type mismatch in query builder (Fix #5 above)
- **Risk:** May break with Supabase client updates
- **Effort:** 3 min (included in quick fixes)
- **Status:** Fix now

#### H2. JavaScript Interop Migration
- **Issue:** `dart:js` deprecated, should migrate to `dart:js_interop`
- **Risk:** Will break in future Dart versions
- **Effort:** 2-4 hours (full migration)
- **Status:** Backlog - Medium priority

### 🟡 **MEDIUM PRIORITY (Technical Debt)**

#### M1. Migrate fetchQueue() Callers
- **Issue:** 47 deprecation warnings for `fetchQueue()`
- **Risk:** Method will be removed in future
- **Effort:** 4-6 hours (migrate all call sites to `fetchQueuePage()`)
- **Status:** Backlog - Medium priority

#### M2. Remove Unused Code
- **Issue:** 40 unused imports/variables
- **Risk:** Code bloat, confusion
- **Effort:** 1-2 hours (automated cleanup)
- **Status:** Backlog - Low priority

### 🟢 **LOW PRIORITY (Code Quality)**

#### L1. Deprecated dart:html Usage
- **Issue:** Multiple files use deprecated `dart:html`
- **Risk:** Future compatibility
- **Effort:** 4-8 hours (migrate to `package:web`)
- **Status:** Backlog - Low priority

#### L2. Code Style Fixes
- **Issue:** 40+ style/lint suggestions
- **Risk:** None (cosmetic)
- **Effort:** 2-3 hours (automated fixes)
- **Status:** Backlog - Very Low priority

---

## 5. Recommended Action Plan

### ✅ **Do Now (30 min)**
1. Fix import path (Fix #1)
2. Run build_runner (Fix #2)
3. Fix valueOrNull (Fix #3)
4. Fix allowInterop (Fix #4)
5. Fix Postgrest types (Fix #5)

### 📋 **Backlog (Prioritized)**
1. **High:** JavaScript interop migration (H2) - 2-4 hours
2. **Medium:** Migrate fetchQueue() callers (M1) - 4-6 hours
3. **Low:** Remove unused code (M2) - 1-2 hours
4. **Low:** Migrate dart:html (L1) - 4-8 hours
5. **Very Low:** Code style fixes (L2) - 2-3 hours

---

## 6. Verification Checklist

After quick fixes:
- [ ] `flutter analyze` shows 0 errors (warnings/info OK)
- [ ] `flutter build web` succeeds
- [ ] Map view loads without errors
- [ ] Claims queue loads without errors
- [ ] Places API works (if tested)

---

## Summary

**Total Blockers:** 17 errors  
**Quick Fix Time:** ~30 minutes  
**Remaining Issues:** 127 (non-blocking)

**Recommendation:** Fix the 5 quick fixes now to unblock development. Address backlog items during planned refactoring cycles.

