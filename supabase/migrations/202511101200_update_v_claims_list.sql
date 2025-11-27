drop view if exists public.v_claims_list;

create view public.v_claims_list as
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
  coalesce(sr.time_to_first_contact_minutes, 240) as sla_target_minutes,
  latest_contact.attempted_at as latest_contact_attempt_at,
  latest_contact.outcome as latest_contact_outcome,
  coalesce(attempt_stats.retry_count, 0) as attempt_count,
  coalesce(cqs.retry_interval_minutes, 120) as retry_interval_minutes,
  case
    when latest_contact.attempted_at is null then null
    else latest_contact.attempted_at + (coalesce(cqs.retry_interval_minutes, 120) * interval '1 minute')
  end as next_retry_at,
  case
    when latest_contact.attempted_at is null then true
    else timezone('utc', now()) >= latest_contact.attempted_at + (coalesce(cqs.retry_interval_minutes, 120) * interval '1 minute')
  end as ready_for_retry,
  (addr.street || ', ' || addr.suburb) as address_short
from public.claims c
join public.clients cl on cl.id = c.client_id
join public.insurers i on i.id = c.insurer_id
join public.addresses addr on addr.id = c.address_id
left join public.sla_rules sr on sr.tenant_id = c.tenant_id
left join public.claim_queue_settings cqs on cqs.tenant_id = c.tenant_id
left join lateral (
  select count(*)::int as retry_count
  from public.contact_attempts ca
  where ca.claim_id = c.id
) as attempt_stats on true
left join lateral (
  select ca.attempted_at, ca.outcome
  from public.contact_attempts ca
  where ca.claim_id = c.id
  order by ca.attempted_at desc
  limit 1
) as latest_contact on true;


