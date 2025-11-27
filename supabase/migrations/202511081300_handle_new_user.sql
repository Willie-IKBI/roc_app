-- Auto-provision profiles for new auth users.

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  target_tenant uuid;
begin
  select id
    into target_tenant
  from public.tenants
  order by created_at
  limit 1;

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
    coalesce(new.raw_user_meta_data->>'full_name', new.email),
    new.email,
    coalesce(new.raw_user_meta_data->>'role', 'claim_agent')
  );

  return new;
end;
$$;

drop trigger if exists handle_new_user on auth.users;

create trigger handle_new_user
after insert on auth.users
for each row execute procedure public.handle_new_user();

