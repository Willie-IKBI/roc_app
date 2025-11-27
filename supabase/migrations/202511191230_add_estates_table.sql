-- Add estates table and link to addresses for reusable locations

create table if not exists public.estates (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  name text not null,
  suburb text,
  city text,
  province text,
  postal_code text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists estates_tenant_lower_name_idx
  on public.estates (tenant_id, lower(name));

select public.enable_updated_at_trigger('public.estates');

alter table public.estates enable row level security;

drop policy if exists "estates service role access" on public.estates;
create policy "estates service role access" on public.estates
  for all
  using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');

-- RLS: agents/admins can read, only admins mutate
drop policy if exists "estates tenant select" on public.estates;
create policy "estates tenant select" on public.estates
  for select
  using (
    public.profile_is_active()
    and public.profile_is_admin_or_agent()
    and tenant_id = public.current_tenant_id()
  );

drop policy if exists "estates admin mutate" on public.estates;
create policy "estates admin mutate" on public.estates
  for all
  using (
    public.profile_is_active()
    and public.profile_is_admin()
    and tenant_id = public.current_tenant_id()
  )
  with check (
    public.profile_is_active()
    and public.profile_is_admin()
    and tenant_id = public.current_tenant_id()
  );

-- Link addresses to estates
alter table public.addresses
  add column if not exists estate_id uuid references public.estates (id) on delete set null;

create index if not exists addresses_estate_idx on public.addresses (estate_id);

