create table if not exists public.brands (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  name text not null,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create unique index if not exists brands_tenant_name_idx
  on public.brands (tenant_id, lower(name));

select public.enable_updated_at_trigger('public.brands');

alter table public.brands enable row level security;

drop policy if exists "brands service role access" on public.brands;
create policy "brands service role access" on public.brands
  for all
  using (auth.role() = 'service_role')
  with check (auth.role() = 'service_role');

drop policy if exists "brands tenant select" on public.brands;
create policy "brands tenant select" on public.brands
  for select
  using (
    public.profile_is_active()
    and public.profile_is_admin_or_agent()
    and tenant_id = public.current_tenant_id()
  );

drop policy if exists "brands admin mutate" on public.brands;
create policy "brands admin mutate" on public.brands
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


