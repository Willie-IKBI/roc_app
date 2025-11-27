-- Add damage_description column to claims table
alter table public.claims
  add column if not exists damage_description text;





