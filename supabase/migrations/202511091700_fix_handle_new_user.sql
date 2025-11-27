-- Fix handle_new_user trigger to cast role metadata to role_type safely
-- and guard against missing tenant configuration.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target_tenant uuid;
  desired_role role_type;
begin
  select id
    into target_tenant
  from public.tenants
  order by created_at
  limit 1;

  if target_tenant is null then
    raise exception 'No tenant configured. Insert at least one row into public.tenants.';
  end if;

  desired_role := coalesce(
    nullif(new.raw_user_meta_data->>'role', '')::role_type,
    'claim_agent'::role_type
  );

  insert into public.profiles (
    id,
    tenant_id,
    full_name,
    email,
    role
  )
  values (
    new.id,
    target_tenant,
    coalesce(nullif(new.raw_user_meta_data->>'full_name', ''), new.email),
    new.email,
    desired_role
  );

  return new;
end;
$$;

