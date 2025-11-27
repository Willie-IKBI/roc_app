create or replace view public.v_claims_reporting as
with first_contact as (
  select
    ca.claim_id,
    min(ca.attempted_at) as first_contact_at
  from public.contact_attempts ca
  group by ca.claim_id
)
select
  c.tenant_id,
  date_trunc('day', c.created_at)::date as claim_date,
  count(*)::int as claims_captured,
  avg(
    case
      when fc.first_contact_at is not null
      then extract(epoch from (fc.first_contact_at - c.sla_started_at)) / 60
      else null
    end
  ) as avg_minutes_to_first_contact,
  sum(
    case
      when fc.first_contact_at is not null
        and fc.first_contact_at <= c.sla_started_at
          + (coalesce(sr.time_to_first_contact_minutes, 240) * interval '1 minute')
      then 1
      else 0
    end
  )::int as compliant_claims,
  sum(
    case
      when fc.first_contact_at is not null then 1 else 0
    end
  )::int as contacted_claims
from public.claims c
left join first_contact fc on fc.claim_id = c.id
left join public.sla_rules sr on sr.tenant_id = c.tenant_id
group by 1, 2
order by claim_date desc;


