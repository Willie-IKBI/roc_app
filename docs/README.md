# Repair on Call Docs

Placeholder for PRD, manuals, quick start, and runbooks.

## Supabase Setup (MVP schema v0.1)

1. Install the Supabase CLI (`npm install -g supabase`) and authenticate against the target project (`supabase login`).
2. Point the CLI at this repo root and link to your project: `supabase link --project-ref <project-ref>`.
3. Bootstrap the database with the new schema:
   - `supabase db push --file supabase/migrations/202511071100_init_schema.sql`
4. Optional: load the demo dataset for local smoke-testing:
   - `supabase db push --file supabase/seeds/202511071110_demo_seed.sql`
5. Add real users via the Supabase dashboard/Auth API, then update `profiles.tenant_id` to match the seeded tenant or create additional tenants as needed.

> The migration enables blanket-deny RLS policies. Add role-specific policies immediately after linking a tenant user to avoid locked-out sessions.

