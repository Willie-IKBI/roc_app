# ROC Web Console

Flutter + Supabase web console for Repair On Call.

## Local setup

1. Install Flutter 3.22+ and Supabase CLI.
2. Copy the environment templates and populate them with your secrets (never commit the filled files):
   ```
   cp env/dev.example.json env/dev.json
   cp env/prod.example.json env/prod.json
   ```
3. Run the dev server:
   ```
   flutter run -d chrome --dart-define-from-file=env/dev.json
   ```

## Deploy

Build for production with environment variables and correct base href:

```bash
flutter clean
flutter build web --release --dart-define-from-file=env/prod.json --base-href=/
firebase deploy --only hosting
```

**Important:** 
- Always use `--base-href=/` for Firebase hosting
- Use `--release` flag for production builds
- Ensure `env/prod.json` contains all required environment variables
- Test the build locally before deploying: `flutter run -d chrome --release --dart-define-from-file=env/prod.json`

### Verify Build

After building, verify that environment variables are embedded in the build:

**Windows (PowerShell):**
```powershell
.\scripts\verify_build.ps1
```

**Linux/Mac:**
```bash
chmod +x scripts/verify_build.sh
./scripts/verify_build.sh
```

This script checks if the compiled JavaScript contains the environment variables. If variables are missing, the build command may not have included `--dart-define-from-file=env/prod.json`.

### Troubleshooting Deployment Issues

If the app works locally but fails on Firebase:

1. **Check browser console (F12)** - Look for `[Env]` and `[AppInit]` log messages
2. **Verify build command** - Ensure you used: `flutter build web --release --dart-define-from-file=env/prod.json --base-href=/`
3. **Run verification script** - Use the scripts above to verify env vars are embedded
4. **Check env/prod.json** - Ensure the file exists and contains all required variables:
   - `SUPABASE_URL`
   - `SUPABASE_ANON_KEY`
   - `GOOGLE_MAPS_API_KEY` (optional but recommended)
5. **Verify Google Maps API key restrictions** - Ensure Firebase domains are whitelisted in Google Cloud Console

Supabase migrations live in `supabase/migrations/`. Use `supabase db push` to apply them. Secret scanning will flag committed keys, so keep your real `env/*.json` out of git (see `.gitignore`).
