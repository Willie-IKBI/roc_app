alter table public.sms_templates enable row level security;

drop policy if exists "sms templates tenant select" on public.sms_templates;
create policy "sms templates tenant select" on public.sms_templates
  for select
  using (
    public.profile_is_active()
    and tenant_id = public.current_tenant_id()
  );

drop policy if exists "sms templates admin manage" on public.sms_templates;
create policy "sms templates admin manage" on public.sms_templates
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


