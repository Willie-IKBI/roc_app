-- ROC APP - RLS policies and helper functions (MVP v0.1)

-- Drop the placeholder deny-all policies before replacing them with real ones.
do $$
declare
  tbl text;
  tables text[] := array[
    'public.tenants',
    'public.profiles',
    'public.insurers',
    'public.service_providers',
    'public.clients',
    'public.addresses',
    'public.claims',
    'public.claim_items',
    'public.contact_attempts',
    'public.sms_messages',
    'public.claim_status_history',
    'public.audit_log',
    'public.documents',
    'public.sla_rules',
    'public.claim_queue_settings'
  ];
begin
  foreach tbl in array tables loop
    execute format('drop policy if exists "deny all by default" on %s;', tbl);
  end loop;
end $$;

-- Helper functions ----------------------------------------------------------

create or replace function public.current_profile()
returns public.profiles
language sql
stable
security definer
set search_path = public
as $$
  select p.*
  from public.profiles p
  where p.id = auth.uid()
  limit 1;
$$;

create or replace function public.current_tenant_id()
returns uuid
language sql
stable
security definer
set search_path = public
as $$
  select p.tenant_id
  from public.profiles p
  where p.id = auth.uid()
  limit 1;
$$;

create or replace function public.profile_role()
returns role_type
language sql
stable
security definer
set search_path = public
as $$
  select p.role
  from public.profiles p
  where p.id = auth.uid()
  limit 1;
$$;

create or replace function public.profile_is_active()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(p.is_active, false)
  from public.profiles p
  where p.id = auth.uid()
  limit 1;
$$;

create or replace function public.profile_is_admin()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.profile_role() = 'admin', false);
$$;

create or replace function public.profile_is_claim_agent()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select coalesce(public.profile_role() = 'claim_agent', false);
$$;

create or replace function public.profile_is_admin_or_agent()
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.profile_is_admin() or public.profile_is_claim_agent();
$$;

create or replace function public.profile_tenant_matches(target uuid)
returns boolean
language sql
stable
security definer
set search_path = public
as $$
  select public.current_tenant_id() is not null
     and target = public.current_tenant_id();
$$;

-- Service role bypass (full access for service key) ------------------------

do $$
declare
  tbl text;
  tables text[] := array[
    'public.tenants',
    'public.profiles',
    'public.insurers',
    'public.service_providers',
    'public.clients',
    'public.addresses',
    'public.claims',
    'public.claim_items',
    'public.contact_attempts',
    'public.sms_messages',
    'public.claim_status_history',
    'public.audit_log',
    'public.documents',
    'public.sla_rules',
    'public.claim_queue_settings'
  ];
begin
  foreach tbl in array tables loop
    execute format('drop policy if exists %I on %s;', 'service role access', tbl);
    execute format(
      'create policy %I on %s for all using (auth.role() = ''service_role'') with check (auth.role() = ''service_role'');',
      'service role access',
      tbl
    );
  end loop;
end $$;

-- Tenant-scoped read/write policies for member tables ----------------------

do $$
declare
  tbl text;
  readable_tables text[] := array[
    'public.clients',
    'public.addresses',
    'public.claims',
    'public.claim_items',
    'public.contact_attempts',
    'public.sms_messages',
    'public.claim_status_history',
    'public.documents'
  ];
  policy_select text;
  policy_insert text;
  policy_update text;
  policy_delete text;
begin
  foreach tbl in array readable_tables loop
    policy_select := replace(tbl, 'public.', '') || ' tenant select';
    policy_insert := replace(tbl, 'public.', '') || ' tenant insert';
    policy_update := replace(tbl, 'public.', '') || ' tenant update';
    policy_delete := replace(tbl, 'public.', '') || ' tenant delete';

    execute format('drop policy if exists %I on %s;', policy_select, tbl);
    execute format(
      'create policy %I on %s for select using (
         public.profile_is_active()
         and public.profile_is_admin_or_agent()
         and tenant_id = public.current_tenant_id()
       );',
      policy_select,
      tbl
    );

    execute format('drop policy if exists %I on %s;', policy_insert, tbl);
    execute format(
      'create policy %I on %s for insert with check (
         public.profile_is_active()
         and public.profile_is_admin_or_agent()
         and tenant_id = public.current_tenant_id()
       );',
      policy_insert,
      tbl
    );

    execute format('drop policy if exists %I on %s;', policy_update, tbl);
    execute format(
      'create policy %I on %s for update using (
         public.profile_is_active()
         and public.profile_is_admin_or_agent()
         and tenant_id = public.current_tenant_id()
       ) with check (
         public.profile_is_active()
         and public.profile_is_admin_or_agent()
         and tenant_id = public.current_tenant_id()
       );',
      policy_update,
      tbl
    );

    execute format('drop policy if exists %I on %s;', policy_delete, tbl);
    execute format(
      'create policy %I on %s for delete using (
         public.profile_is_active()
         and public.profile_is_admin()
         and tenant_id = public.current_tenant_id()
       );',
      policy_delete,
      tbl
    );
  end loop;
end $$;

-- Reference data: insurers, service providers, SLA config ------------------

do $$
declare
  tbl text;
  tables text[] := array[
    'public.insurers',
    'public.service_providers',
    'public.sla_rules',
    'public.claim_queue_settings'
  ];
  policy_select text;
  policy_mutate text;
begin
  foreach tbl in array tables loop
    policy_select := replace(tbl, 'public.', '') || ' tenant select';
    policy_mutate := replace(tbl, 'public.', '') || ' admin mutate';

    execute format('drop policy if exists %I on %s;', policy_select, tbl);
    execute format(
      'create policy %I on %s for select using (
         public.profile_is_active()
         and public.profile_is_admin_or_agent()
         and tenant_id = public.current_tenant_id()
       );',
      policy_select,
      tbl
    );

    execute format('drop policy if exists %I on %s;', policy_mutate, tbl);
    execute format(
      'create policy %I on %s for all using (
         public.profile_is_active()
         and public.profile_is_admin()
         and tenant_id = public.current_tenant_id()
       ) with check (
         public.profile_is_active()
         and public.profile_is_admin()
         and tenant_id = public.current_tenant_id()
       );',
      policy_mutate,
      tbl
    );
  end loop;
end $$;

-- Tenants table -------------------------------------------------------------

drop policy if exists "tenants tenant select" on public.tenants;
create policy "tenants tenant select" on public.tenants
  for select
  using (
    public.profile_is_active()
    and id = public.current_tenant_id()
  );

drop policy if exists "tenants admin update" on public.tenants;
create policy "tenants admin update" on public.tenants
  for update
  using (
    public.profile_is_admin()
    and id = public.current_tenant_id()
  )
  with check (
    public.profile_is_admin()
    and id = public.current_tenant_id()
  );

-- Profiles table ------------------------------------------------------------

drop policy if exists "profiles tenant select" on public.profiles;
create policy "profiles tenant select" on public.profiles
  for select
  using (
    public.profile_is_active()
    and tenant_id = public.current_tenant_id()
  );

drop policy if exists "profiles self update" on public.profiles;
create policy "profiles self update" on public.profiles
  for update
  using (
    public.profile_is_active()
    and (
      id = auth.uid()
      or (public.profile_is_admin() and tenant_id = public.current_tenant_id())
    )
  )
  with check (
    tenant_id = public.current_tenant_id()
  );

drop policy if exists "profiles admin insert" on public.profiles;
create policy "profiles admin insert" on public.profiles
  for insert
  with check (
    public.profile_is_admin()
    and tenant_id = public.current_tenant_id()
  );

drop policy if exists "profiles admin delete" on public.profiles;
create policy "profiles admin delete" on public.profiles
  for delete
  using (
    public.profile_is_admin()
    and tenant_id = public.current_tenant_id()
  );

-- Audit log: read-only for admins ------------------------------------------

drop policy if exists "audit_log admin select" on public.audit_log;
create policy "audit_log admin select" on public.audit_log
  for select
  using (
    public.profile_is_active()
    and public.profile_is_admin()
    and tenant_id = public.current_tenant_id()
  );

drop policy if exists "audit_log admin mutate" on public.audit_log;
create policy "audit_log admin mutate" on public.audit_log
  for all
  using (
    public.profile_is_admin()
    and tenant_id = public.current_tenant_id()
  )
  with check (
    public.profile_is_admin()
    and tenant_id = public.current_tenant_id()
  );


