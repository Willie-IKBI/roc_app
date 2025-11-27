-- ROC APP - Supabase schema bootstrap (MVP v0.1)
-- Generated 2025-11-07

-- Enable required extensions -------------------------------------------------
create extension if not exists "uuid-ossp";
create extension if not exists pgcrypto;

-- Utility helper to maintain updated_at -------------------------------------
create or replace function public.set_updated_at()
returns trigger as $$
begin
  new.updated_at = timezone('utc', now());
  return new;
end;
$$ language plpgsql;

-- Enum definitions -----------------------------------------------------------
do $$
begin
  if not exists (select 1 from pg_type where typname = 'claim_status') then
    create type claim_status as enum (
      'new',
      'in_contact',
      'awaiting_client',
      'scheduled',
      'work_in_progress',
      'on_hold',
      'closed',
      'cancelled'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'contact_outcome') then
    create type contact_outcome as enum (
      'answered',
      'no_answer',
      'bad_number',
      'left_voicemail',
      'sms_sent',
      'call_back_requested'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'damage_cause') then
    create type damage_cause as enum (
      'power_surge',
      'lightning_damage',
      'liquid_damage',
      'electrical_breakdown',
      'mechanical_breakdown',
      'theft',
      'fire',
      'accidental_impact_damage',
      'storm_damage',
      'wear_and_tear',
      'old_age',
      'negligence',
      'resultant_damage',
      'other'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'warranty_status') then
    create type warranty_status as enum (
      'in_warranty',
      'out_of_warranty',
      'unknown'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'role_type') then
    create type role_type as enum (
      'admin',
      'claim_agent'
    );
  end if;

  if not exists (select 1 from pg_type where typname = 'priority_level') then
    create type priority_level as enum (
      'low',
      'normal',
      'high',
      'urgent'
    );
  end if;
end $$;

-- Core tables ----------------------------------------------------------------

create table if not exists public.tenants (
  id uuid primary key default gen_random_uuid(),
  name text not null unique,
  created_at timestamptz not null default timezone('utc', now())
);

create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  tenant_id uuid not null references public.tenants (id) on delete restrict,
  full_name text,
  phone text,
  email text,
  role role_type not null default 'claim_agent',
  is_active boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists profiles_tenant_idx on public.profiles (tenant_id);
create index if not exists profiles_role_idx on public.profiles (role);

create table if not exists public.insurers (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  name text not null,
  contact_phone text,
  contact_email text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint insurers_tenant_name_unique unique (tenant_id, name)
);

create index if not exists insurers_tenant_idx on public.insurers (tenant_id);

create table if not exists public.service_providers (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  company_name text not null,
  contact_name text,
  contact_phone text,
  contact_email text,
  reference_number_format text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint service_providers_tenant_company_unique unique (tenant_id, company_name)
);

create index if not exists service_providers_tenant_idx on public.service_providers (tenant_id);
create index if not exists service_providers_company_idx on public.service_providers (tenant_id, company_name);

create table if not exists public.clients (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  first_name text not null,
  last_name text not null,
  primary_phone text not null,
  alt_phone text,
  email text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists clients_tenant_name_idx on public.clients (tenant_id, last_name, first_name);
create index if not exists clients_phone_idx on public.clients (tenant_id, primary_phone);

create table if not exists public.addresses (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  client_id uuid not null references public.clients (id) on delete cascade,
  complex_or_estate text,
  unit_number text,
  street text not null,
  suburb text not null,
  postal_code text not null,
  city text,
  province text,
  country text not null default 'South Africa',
  lat numeric(9,6),
  lng numeric(9,6),
  google_place_id text,
  is_primary boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists addresses_client_idx on public.addresses (client_id);
create index if not exists addresses_geo_idx on public.addresses (tenant_id, lat, lng);

create table if not exists public.claims (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  claim_number text not null,
  insurer_id uuid not null references public.insurers (id) on delete restrict,
  client_id uuid not null references public.clients (id) on delete restrict,
  address_id uuid not null references public.addresses (id) on delete restrict,
  service_provider_id uuid references public.service_providers (id) on delete set null,
  status claim_status not null default 'new',
  priority priority_level not null default 'normal',
  damage_cause damage_cause not null default 'other',
  surge_protection_at_db boolean not null default false,
  surge_protection_at_plug boolean not null default false,
  agent_id uuid references public.profiles (id) on delete set null,
  sla_started_at timestamptz not null default timezone('utc', now()),
  closed_at timestamptz,
  notes_public text,
  notes_internal text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint claims_tenant_claim_number_unique unique (tenant_id, insurer_id, claim_number)
);

create index if not exists claims_tenant_status_idx on public.claims (tenant_id, status);
create index if not exists claims_agent_idx on public.claims (tenant_id, agent_id);
create index if not exists claims_sla_idx on public.claims (tenant_id, sla_started_at);
create index if not exists claims_client_idx on public.claims (tenant_id, client_id);

create table if not exists public.claim_items (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  claim_id uuid not null references public.claims (id) on delete cascade,
  brand text not null,
  color text,
  warranty warranty_status not null default 'unknown',
  serial_or_model text,
  notes text,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now())
);

create index if not exists claim_items_claim_idx on public.claim_items (claim_id);

create table if not exists public.contact_attempts (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  claim_id uuid not null references public.claims (id) on delete cascade,
  attempted_by uuid not null references public.profiles (id) on delete restrict,
  attempted_at timestamptz not null default timezone('utc', now()),
  method text not null,
  outcome contact_outcome not null,
  notes text
);

create index if not exists contact_attempts_claim_idx on public.contact_attempts (claim_id);
create index if not exists contact_attempts_time_idx on public.contact_attempts (attempted_at desc);

create table if not exists public.sms_messages (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  claim_id uuid not null references public.claims (id) on delete cascade,
  to_phone text not null,
  body text not null,
  provider text not null,
  provider_msg_id text,
  status text not null,
  error_code text,
  sent_at timestamptz,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists sms_claim_idx on public.sms_messages (claim_id);
create index if not exists sms_status_idx on public.sms_messages (status);

create table if not exists public.claim_status_history (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  claim_id uuid not null references public.claims (id) on delete cascade,
  from_status claim_status not null,
  to_status claim_status not null,
  changed_by uuid references public.profiles (id) on delete set null,
  changed_at timestamptz not null default timezone('utc', now()),
  reason text
);

create index if not exists claim_status_history_claim_idx on public.claim_status_history (claim_id, changed_at desc);

create table if not exists public.audit_log (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  actor_id uuid references public.profiles (id) on delete set null,
  entity text not null,
  entity_id uuid not null,
  action text not null,
  diff_json jsonb not null,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists audit_entity_idx on public.audit_log (tenant_id, entity, entity_id);
create index if not exists audit_time_idx on public.audit_log (created_at desc);

create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  claim_id uuid not null references public.claims (id) on delete cascade,
  uploaded_by uuid references public.profiles (id) on delete set null,
  file_name text not null,
  file_type text not null,
  storage_path text not null,
  public_url text,
  notes text,
  created_at timestamptz not null default timezone('utc', now())
);

create index if not exists documents_claim_idx on public.documents (claim_id);

create table if not exists public.sla_rules (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  time_to_first_contact_minutes integer not null default 240,
  breach_highlight boolean not null default true,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint sla_rules_tenant_unique unique (tenant_id)
);

create table if not exists public.claim_queue_settings (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  retry_limit integer not null default 3,
  retry_interval_minutes integer not null default 120,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint claim_queue_settings_tenant_unique unique (tenant_id)
);

-- Views ---------------------------------------------------------------------

create or replace view public.v_claims_list as
select
  c.id as claim_id,
  c.claim_number,
  (cl.first_name || ' ' || cl.last_name) as client_full_name,
  cl.primary_phone,
  i.name as insurer_name,
  c.status,
  c.priority,
  c.sla_started_at,
  extract(epoch from (timezone('utc', now()) - c.sla_started_at)) / 60 as elapsed_minutes,
  latest_contact.attempted_at as latest_contact_attempt_at,
  latest_contact.outcome as latest_contact_outcome,
  (addr.street || ', ' || addr.suburb) as address_short
from public.claims c
join public.clients cl on cl.id = c.client_id
join public.insurers i on i.id = c.insurer_id
join public.addresses addr on addr.id = c.address_id
left join lateral (
  select ca.attempted_at, ca.outcome
  from public.contact_attempts ca
  where ca.claim_id = c.id
  order by ca.attempted_at desc
  limit 1
) as latest_contact on true;

create or replace view public.v_claims_sla as
select
  c.id as claim_id,
  c.status,
  extract(epoch from (timezone('utc', now()) - c.sla_started_at)) / 60 as elapsed_minutes,
  coalesce(sr.time_to_first_contact_minutes, 240) as target_minutes,
  (extract(epoch from (timezone('utc', now()) - c.sla_started_at)) / 60) > coalesce(sr.time_to_first_contact_minutes, 240) as is_breached
from public.claims c
join public.sla_rules sr on sr.tenant_id = c.tenant_id;

-- Triggers ------------------------------------------------------------------

create or replace function public.enable_updated_at_trigger(target_table regclass) returns void as $$
declare
  trigger_name text := target_table::text || '_set_updated_at';
begin
  execute format('create trigger %I before update on %s for each row execute procedure public.set_updated_at();', trigger_name, target_table);
exception when duplicate_object then
  -- ignore if trigger already exists
  null;
end;
$$ language plpgsql;

select public.enable_updated_at_trigger('public.profiles');
select public.enable_updated_at_trigger('public.insurers');
select public.enable_updated_at_trigger('public.service_providers');
select public.enable_updated_at_trigger('public.clients');
select public.enable_updated_at_trigger('public.addresses');
select public.enable_updated_at_trigger('public.claims');
select public.enable_updated_at_trigger('public.claim_items');
select public.enable_updated_at_trigger('public.sla_rules');
select public.enable_updated_at_trigger('public.claim_queue_settings');

-- Initial RLS scaffold -------------------------------------------------------

alter table public.tenants enable row level security;
alter table public.profiles enable row level security;
alter table public.insurers enable row level security;
alter table public.service_providers enable row level security;
alter table public.clients enable row level security;
alter table public.addresses enable row level security;
alter table public.claims enable row level security;
alter table public.claim_items enable row level security;
alter table public.contact_attempts enable row level security;
alter table public.sms_messages enable row level security;
alter table public.claim_status_history enable row level security;
alter table public.audit_log enable row level security;
alter table public.documents enable row level security;
alter table public.sla_rules enable row level security;
alter table public.claim_queue_settings enable row level security;

-- Default deny-all policies; granular policies to be added separately --------
do $$
declare
  tbl text;
  tbls text[] := array[
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
  foreach tbl in array tbls loop
    execute format('drop policy if exists "allow read" on %s;', tbl);
    execute format('drop policy if exists "allow write" on %s;', tbl);
    execute format('create policy "deny all by default" on %s for all using (false);', tbl);
  end loop;
end $$;


