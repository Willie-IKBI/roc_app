create table if not exists public.sms_templates (
  id uuid primary key default gen_random_uuid(),
  tenant_id uuid not null references public.tenants (id) on delete cascade,
  name text not null,
  description text,
  body text not null,
  is_active boolean not null default true,
  default_for_follow_up boolean not null default false,
  created_at timestamptz not null default timezone('utc', now()),
  updated_at timestamptz not null default timezone('utc', now()),
  constraint sms_templates_tenant_name_unique unique (tenant_id, name)
);

create unique index if not exists sms_templates_follow_up_unique
  on public.sms_templates (tenant_id)
  where default_for_follow_up;

select public.enable_updated_at_trigger('public.sms_templates');

alter table public.tenants
  add column if not exists sms_sender_name text,
  add column if not exists sms_sender_number text;


