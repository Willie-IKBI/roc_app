# Deployment Troubleshooting Guide

## Problem: App Works Locally But Fails on Firebase

If your app works perfectly when running locally with `flutter run` but fails when deployed to Firebase, the most common cause is **environment variables not being embedded in the production build**.

## Root Cause

Flutter's `String.fromEnvironment()` only works at **compile time**. If you don't include `--dart-define-from-file=env/prod.json` in your build command, the environment variables will be empty strings in the compiled JavaScript.

### Why It Works Locally

When you run `flutter run -d chrome --dart-define-from-file=env/dev.json`, Flutter embeds the environment variables from `env/dev.json` into the development build.

### Why It Fails on Firebase

If you build without `--dart-define-from-file=env/prod.json`, the production build will have empty environment variables, causing:
- Supabase initialization to fail
- Google Maps API to fail
- Authentication to fail
- Any feature that depends on environment variables

## Solution

### Step 1: Verify Your Build Command

**Correct build command:**
```bash
flutter clean
flutter build web --release --dart-define-from-file=env/prod.json --base-href=/
firebase deploy --only hosting
```

**Common mistakes:**
- ❌ `flutter build web --release` (missing `--dart-define-from-file`)
- ❌ `flutter build web --dart-define-from-file=env/prod.json` (missing `--release`)
- ❌ `flutter build web --release --dart-define-from-file=env/dev.json` (using dev instead of prod)

### Step 2: Verify env/prod.json Exists

Ensure `env/prod.json` exists and contains all required variables:

```json
{
  "SUPABASE_URL": "https://your-project.supabase.co",
  "SUPABASE_ANON_KEY": "eyJ...",
  "GOOGLE_MAPS_API_KEY": "AIza..."
}
```

### Step 3: Run Build Verification Script

After building, verify that environment variables are embedded:

**Windows (PowerShell):**
```powershell
.\scripts\verify_build.ps1
```

**Linux/Mac:**
```bash
chmod +x scripts/verify_build.sh
./scripts/verify_build.sh
```

The script will check if the compiled JavaScript contains your environment variables.

### Step 4: Check Browser Console

After deploying, open your Firebase URL and check the browser console (F12):

1. Look for `[EnvDiagnostic]` messages - these run before Flutter loads
2. Look for `[Env]` messages - these show environment variable status
3. Look for `[AppInit]` messages - these show initialization progress

**Expected console output (success):**
```
[EnvDiagnostic] Starting environment variable diagnostic...
[EnvDiagnostic] Firebase hosting: true
[AppInit] Starting application initialization...
[Env] Environment Variables Status:
[Env] SUPABASE_URL: ✓ Set (45 chars)
[Env] SUPABASE_ANON_KEY: ✓ Set (200 chars)
[Env] GOOGLE_MAPS_API_KEY: ✓ Set (39 chars)
```

**If variables are missing:**
```
[Env] SUPABASE_URL: ✗ Missing
[Env] SUPABASE_ANON_KEY: ✗ Missing
[AppInit] Required environment variables are missing: SUPABASE_URL, SUPABASE_ANON_KEY
```

### Step 5: Verify Google Maps API Key Restrictions

Even if environment variables are embedded, Google Maps may fail if the API key has domain restrictions.

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services > Credentials**
3. Select your API key
4. Under **Application restrictions**, verify these domains are whitelisted:
   - `https://roc-app-149db.web.app/*`
   - `https://roc-app-149db.firebaseapp.com/*`
   - `http://localhost/*` (for local development)
5. Under **API restrictions**, verify these APIs are enabled:
   - Maps JavaScript API
   - Places API (New)
   - Places API (legacy fallback)
   - Static Maps API
   - Geocoding API (for reverse geocoding)

## Diagnostic Checklist

When troubleshooting deployment issues, check:

- [ ] Build command includes `--dart-define-from-file=env/prod.json`
- [ ] Build command includes `--release` flag
- [ ] Build command includes `--base-href=/`
- [ ] `env/prod.json` file exists
- [ ] `env/prod.json` contains all required variables
- [ ] Build verification script passes
- [ ] Browser console shows environment variables as "✓ Set"
- [ ] Google Maps API key restrictions allow Firebase domains
- [ ] Google Maps API restrictions include all required APIs

## Common Error Messages

### "Environment variables missing: SUPABASE_URL, SUPABASE_ANON_KEY"

**Cause:** Build did not include `--dart-define-from-file=env/prod.json`

**Fix:** Rebuild with the correct command:
```bash
flutter clean
flutter build web --release --dart-define-from-file=env/prod.json --base-href=/
firebase deploy --only hosting
```

### "Google Maps API key is not configured"

**Cause:** `GOOGLE_MAPS_API_KEY` is missing or empty

**Fix:** Add `GOOGLE_MAPS_API_KEY` to `env/prod.json` and rebuild

### "Invalid Google Maps API key"

**Cause:** API key restrictions don't allow Firebase domain, or API restrictions don't include required APIs

**Fix:** Update Google Cloud Console API key restrictions (see Step 5 above)

### "Failed to initialize the application"

**Cause:** Usually environment variables missing or Supabase initialization failed

**Fix:** Check browser console for specific error, then follow the diagnostic steps above

## Testing Locally Before Deploying

Before deploying to Firebase, test the production build locally:

```bash
flutter build web --release --dart-define-from-file=env/prod.json --base-href=/
cd build/web
python -m http.server 8000
# Or: npx serve -s .
```

Then open `http://localhost:8000` and verify:
- App loads without errors
- Browser console shows environment variables as "✓ Set"
- Sign in works
- Map loads
- Claim creation works

If everything works locally, it should work on Firebase too.

## Still Having Issues?

If you've followed all steps and the app still fails:

1. **Check Firebase Hosting logs** - Look for any server-side errors
2. **Verify Firebase project settings** - Ensure hosting is configured correctly
3. **Check network tab** - Look for failed API requests
4. **Compare local vs production** - Use the same build command locally and on Firebase
5. **Review recent changes** - Check if any code changes might have broken the build

## Additional Resources

- [Flutter Web Deployment](https://docs.flutter.dev/deployment/web)
- [Environment Variables in Flutter](https://docs.flutter.dev/tools/build-variables)
- [Firebase Hosting Documentation](https://firebase.google.com/docs/hosting)
- [Google Maps API Key Security](docs/SECURITY.md)

