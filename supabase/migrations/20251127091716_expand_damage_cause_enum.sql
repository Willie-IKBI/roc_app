do $$
begin
  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'lightning_damage';
  if not found then
    alter type damage_cause add value 'lightning_damage';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'liquid_damage';
  if not found then
    alter type damage_cause add value 'liquid_damage';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'electrical_breakdown';
  if not found then
    alter type damage_cause add value 'electrical_breakdown';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'mechanical_breakdown';
  if not found then
    alter type damage_cause add value 'mechanical_breakdown';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'theft';
  if not found then
    alter type damage_cause add value 'theft';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'fire';
  if not found then
    alter type damage_cause add value 'fire';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'accidental_impact_damage';
  if not found then
    alter type damage_cause add value 'accidental_impact_damage';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'storm_damage';
  if not found then
    alter type damage_cause add value 'storm_damage';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'old_age';
  if not found then
    alter type damage_cause add value 'old_age';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'negligence';
  if not found then
    alter type damage_cause add value 'negligence';
  end if;

  perform 1
  from pg_enum e
  join pg_type t on e.enumtypid = t.oid
  where t.typname = 'damage_cause' and e.enumlabel = 'resultant_damage';
  if not found then
    alter type damage_cause add value 'resultant_damage';
  end if;
end $$;


