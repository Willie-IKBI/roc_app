-- Seed script for ROC APP demo environment (MVP sample data)

with tenant as (
  insert into public.tenants (name)
  values ('Demo Tenant')
  on conflict (name) do update set name = excluded.name
  returning id
),
insurer_rows as (
  insert into public.insurers (tenant_id, name, contact_phone, contact_email)
  select id, name, phone, email
  from tenant,
  lateral (values
    ('InsureCo', '+27115550001', 'support@insureco.example'),
    ('Shield Insurance', '+27115550002', 'claims@shield.example'),
    ('Guardian Mutual', '+27115550003', 'hello@guardian.example')
  ) as insurers(name, phone, email)
  on conflict (tenant_id, name) do update set
    contact_phone = excluded.contact_phone,
    contact_email = excluded.contact_email
  returning tenant_id, id, name
),
client_rows as (
  insert into public.clients (tenant_id, first_name, last_name, primary_phone, email)
  select id, 'Thandi', 'Nkosi', '+27721234567', 'thandi.nkosi@example.com'
  from tenant
  on conflict (tenant_id, primary_phone) do update set
    first_name = excluded.first_name,
    last_name = excluded.last_name,
    email = excluded.email
  returning tenant_id, id
),
address_rows as (
  insert into public.addresses (
    tenant_id,
    client_id,
    street,
    suburb,
    postal_code,
    city,
    province,
    country,
    is_primary
  )
  select c.tenant_id,
         c.id,
         '15 Sunset Road',
         'Bryanston',
         '2191',
         'Johannesburg',
         'Gauteng',
         'South Africa',
         true
  from client_rows c
  on conflict (client_id, is_primary) where is_primary is true do update set
    street = excluded.street,
    suburb = excluded.suburb,
    postal_code = excluded.postal_code,
    city = excluded.city,
    province = excluded.province
  returning tenant_id, id, client_id
),
claim_rows as (
  insert into public.claims (
    tenant_id,
    claim_number,
    insurer_id,
    client_id,
    address_id,
    status,
    priority,
    damage_cause,
    surge_protection_at_db,
    surge_protection_at_plug,
    notes_internal
  )
  select a.tenant_id,
         'ROC-DEMO-001',
         (select id from insurer_rows order by name limit 1),
         a.client_id,
         a.id,
         'in_contact',
         'high',
         'power_surge',
         false,
         false,
         'Demo claim seeded for UI smoke tests.'
  from address_rows a
  on conflict (tenant_id, insurer_id, claim_number) do update set
    status = excluded.status,
    priority = excluded.priority,
    damage_cause = excluded.damage_cause,
    notes_internal = excluded.notes_internal
  returning id, tenant_id
),
claim_item_rows as (
  insert into public.claim_items (
    tenant_id,
    claim_id,
    brand,
    color,
    warranty,
    serial_or_model,
    notes
  )
  select c.tenant_id,
         c.id,
         'Samsung',
         'Black',
         'in_warranty',
         'QA55Q70',
         '55" QLED TV damaged after suspected surge.'
  from claim_rows c
  on conflict (claim_id, brand, serial_or_model)
  where serial_or_model is not null do update set
    color = excluded.color,
    warranty = excluded.warranty,
    notes = excluded.notes
  returning tenant_id, claim_id
)
insert into public.contact_attempts (
  tenant_id,
  claim_id,
  attempted_by,
  method,
  outcome,
  notes
)
select c.tenant_id,
       c.claim_id,
       null::uuid,
       'phone',
       'answered',
       'Initial contact, scheduled assessment for tomorrow.'
from claim_item_rows c
on conflict do nothing;

-- SLA baseline ---------------------------------------------------------------
insert into public.sla_rules (tenant_id, time_to_first_contact_minutes, breach_highlight)
select id, 180, true
from tenant
on conflict (tenant_id) do update set
  time_to_first_contact_minutes = excluded.time_to_first_contact_minutes,
  breach_highlight = excluded.breach_highlight;


