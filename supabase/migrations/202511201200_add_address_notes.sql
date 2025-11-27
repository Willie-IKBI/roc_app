-- Add notes field to addresses table
alter table public.addresses
  add column if not exists notes text;

comment on column public.addresses.notes is 'Optional notes or comments about the address, such as delivery instructions, access codes, or other relevant information.';

