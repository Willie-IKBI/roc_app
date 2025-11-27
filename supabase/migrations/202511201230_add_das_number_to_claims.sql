alter table public.claims
  add column if not exists das_number text;

comment on column public.claims.das_number is 'DAS reference number for Digicall claims';

