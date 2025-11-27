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

```
flutter build web --dart-define-from-file=env/prod.json
firebase deploy --only hosting
```

Supabase migrations live in `supabase/migrations/`. Use `supabase db push` to apply them. Secret scanning will flag committed keys, so keep your real `env/*.json` out of git (see `.gitignore`).
