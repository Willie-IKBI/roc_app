-- Add scheduling-related fields to claims table
-- This migration adds fields for appointment duration estimation and travel time tracking

-- Add estimated_duration_minutes column (default: 60 minutes = 1 hour)
alter table public.claims 
add column if not exists estimated_duration_minutes integer default 60;

-- Add travel_time_minutes column (calculated from previous appointment)
alter table public.claims 
add column if not exists travel_time_minutes integer;

-- Add appointment_date and appointment_time columns if they don't exist
-- (These may already exist, but we'll add them if missing)
alter table public.claims 
add column if not exists appointment_date date;

alter table public.claims 
add column if not exists appointment_time time;

-- Add technician_id column if it doesn't exist
alter table public.claims 
add column if not exists technician_id uuid references public.profiles (id) on delete set null;

-- Add indexes for efficient scheduling queries
create index if not exists claims_technician_appointment_idx 
on public.claims (technician_id, appointment_date, appointment_time) 
where technician_id is not null and appointment_date is not null;

create index if not exists claims_appointment_date_time_idx 
on public.claims (appointment_date, appointment_time) 
where appointment_date is not null and appointment_time is not null;

create index if not exists claims_appointment_date_idx 
on public.claims (appointment_date) 
where appointment_date is not null;

-- Add comment for documentation
comment on column public.claims.estimated_duration_minutes is 'Estimated duration of the appointment in minutes (default: 60)';
comment on column public.claims.travel_time_minutes is 'Travel time in minutes from the previous appointment (calculated)';
comment on column public.claims.appointment_date is 'Date of the scheduled appointment';
comment on column public.claims.appointment_time is 'Time of the scheduled appointment';

