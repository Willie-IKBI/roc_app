# Supabase Database Snapshot

**Generated:** Current state from ROC production database  
**Schema:** `public`

---

## 1. Tables with Columns and Types

### `tenants`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `name` (text, unique, not null)
  - `sms_sender_name` (text, nullable)
  - `sms_sender_number` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)

### `profiles`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `id` → `auth.users.id` (ON DELETE CASCADE)
  - `tenant_id` → `tenants.id`
- **Columns:**
  - `id` (uuid, references `auth.users.id`)
  - `tenant_id` (uuid, not null)
  - `full_name` (text, nullable)
  - `phone` (text, nullable)
  - `email` (text, nullable)
  - `role` (role_type enum, default: `'claim_agent'::role_type`)
  - `is_active` (boolean, default: `true`)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `insurers`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `name` (text, not null)
  - `contact_phone` (text, nullable)
  - `contact_email` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `service_providers`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `company_name` (text, not null)
  - `contact_name` (text, nullable)
  - `contact_phone` (text, nullable)
  - `contact_email` (text, nullable)
  - `reference_number_format` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `clients`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `first_name` (text, not null)
  - `last_name` (text, not null)
  - `primary_phone` (text, not null)
  - `alt_phone` (text, nullable)
  - `email` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `addresses`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `client_id` → `clients.id` (ON DELETE CASCADE)
  - `estate_id` → `estates.id` (nullable)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `client_id` (uuid, not null)
  - `estate_id` (uuid, nullable)
  - `complex_or_estate` (text, nullable)
  - `unit_number` (text, nullable)
  - `street` (text, not null)
  - `suburb` (text, not null)
  - `postal_code` (text, not null)
  - `city` (text, nullable)
  - `province` (text, nullable)
  - `country` (text, default: `'South Africa'::text`)
  - `lat` (numeric(9,6), nullable)
  - `lng` (numeric(9,6), nullable)
  - `google_place_id` (text, nullable)
  - `is_primary` (boolean, default: `true`)
  - `notes` (text, nullable) - *Optional notes or comments about the address*
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `claims`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `insurer_id` → `insurers.id` (ON DELETE RESTRICT)
  - `client_id` → `clients.id` (ON DELETE RESTRICT)
  - `address_id` → `addresses.id` (ON DELETE RESTRICT)
  - `service_provider_id` → `service_providers.id` (nullable, ON DELETE SET NULL)
  - `agent_id` → `profiles.id` (nullable, ON DELETE SET NULL)
  - `technician_id` → `profiles.id` (nullable, ON DELETE SET NULL) - *Assigned technician (user with technician role)*
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `claim_number` (text, not null)
  - `insurer_id` (uuid, not null)
  - `client_id` (uuid, not null)
  - `address_id` (uuid, not null)
  - `service_provider_id` (uuid, nullable)
  - `agent_id` (uuid, nullable)
  - `technician_id` (uuid, nullable) - *Assigned technician (user with technician role)*
  - `status` (claim_status enum, default: `'new'::claim_status`)
  - `priority` (priority_level enum, default: `'normal'::priority_level`)
  - `damage_cause` (damage_cause enum, default: `'other'::damage_cause`)
  - `damage_description` (text, nullable)
  - `surge_protection_at_db` (boolean, default: `false`)
  - `surge_protection_at_plug` (boolean, default: `false`)
  - `das_number` (text, nullable) - *DAS reference number for Digicall claims*
  - `appointment_date` (date, nullable) - *Scheduled appointment date*
  - `appointment_time` (time, nullable) - *Scheduled appointment time*
  - `sla_started_at` (timestamptz, default: `timezone('utc', now())`)
  - `closed_at` (timestamptz, nullable)
  - `notes_public` (text, nullable)
  - `notes_internal` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `claim_items`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `claim_id` → `claims.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `claim_id` (uuid, not null)
  - `brand` (text, not null)
  - `color` (text, nullable)
  - `warranty` (warranty_status enum, default: `'unknown'::warranty_status`)
  - `serial_or_model` (text, nullable)
  - `notes` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `contact_attempts`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `claim_id` → `claims.id` (ON DELETE CASCADE)
  - `attempted_by` → `profiles.id` (ON DELETE RESTRICT)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `claim_id` (uuid, not null)
  - `attempted_by` (uuid, not null)
  - `attempted_at` (timestamptz, default: `timezone('utc', now())`)
  - `method` (text, not null)
  - `outcome` (contact_outcome enum, not null)
  - `notes` (text, nullable)

### `sms_messages`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `claim_id` → `claims.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `claim_id` (uuid, not null)
  - `to_phone` (text, not null)
  - `body` (text, not null)
  - `provider` (text, not null)
  - `provider_msg_id` (text, nullable)
  - `status` (text, not null)
  - `error_code` (text, nullable)
  - `sent_at` (timestamptz, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)

### `claim_status_history`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `claim_id` → `claims.id` (ON DELETE CASCADE)
  - `changed_by` → `profiles.id` (nullable, ON DELETE SET NULL)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `claim_id` (uuid, not null)
  - `from_status` (claim_status enum, not null)
  - `to_status` (claim_status enum, not null)
  - `changed_by` (uuid, nullable)
  - `changed_at` (timestamptz, default: `timezone('utc', now())`)
  - `reason` (text, nullable)

### `audit_log`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `actor_id` → `profiles.id` (nullable, ON DELETE SET NULL)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `actor_id` (uuid, nullable)
  - `entity` (text, not null)
  - `entity_id` (uuid, not null)
  - `action` (text, not null)
  - `diff_json` (jsonb, not null)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)

### `documents`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
  - `claim_id` → `claims.id` (ON DELETE CASCADE)
  - `uploaded_by` → `profiles.id` (nullable, ON DELETE SET NULL)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `claim_id` (uuid, not null)
  - `uploaded_by` (uuid, nullable)
  - `file_name` (text, not null)
  - `file_type` (text, not null)
  - `storage_path` (text, not null)
  - `public_url` (text, nullable)
  - `notes` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)

### `sla_rules`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE, UNIQUE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null, unique)
  - `time_to_first_contact_minutes` (integer, default: `240`)
  - `breach_highlight` (boolean, default: `true`)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `claim_queue_settings`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE, UNIQUE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null, unique)
  - `retry_limit` (integer, default: `3`)
  - `retry_interval_minutes` (integer, default: `120`)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `sms_templates`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `name` (text, not null)
  - `description` (text, nullable)
  - `body` (text, not null)
  - `is_active` (boolean, default: `true`)
  - `default_for_follow_up` (boolean, default: `false`)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `estates`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `name` (text, not null)
  - `suburb` (text, nullable)
  - `city` (text, nullable)
  - `province` (text, nullable)
  - `postal_code` (text, nullable)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

### `brands`
- **RLS Enabled:** ✅ Yes
- **Primary Key:** `id`
- **Foreign Keys:**
  - `tenant_id` → `tenants.id` (ON DELETE CASCADE)
- **Columns:**
  - `id` (uuid, default: `gen_random_uuid()`)
  - `tenant_id` (uuid, not null)
  - `name` (text, not null)
  - `created_at` (timestamptz, default: `timezone('utc', now())`)
  - `updated_at` (timestamptz, default: `timezone('utc', now())`)

---

## 2. Enums

### `claim_status`
- `new`
- `in_contact`
- `awaiting_client`
- `scheduled`
- `work_in_progress`
- `on_hold`
- `closed`
- `cancelled`

### `contact_outcome`
- `answered`
- `no_answer`
- `bad_number`
- `left_voicemail`
- `sms_sent`
- `call_back_requested`

### `damage_cause`
- `power_surge`
- `water_damage`
- `impact`
- `wear_and_tear`
- `manufacturing_fault`
- `other`
- `lightning_damage`
- `liquid_damage`
- `electrical_breakdown`
- `mechanical_breakdown`
- `theft`
- `fire`
- `accidental_impact_damage`
- `storm_damage`
- `old_age`
- `negligence`
- `resultant_damage`

### `priority_level`
- `low`
- `normal`
- `high`
- `urgent`

### `role_type`
- `admin`
- `claim_agent`
- `technician`

### `warranty_status`
- `in_warranty`
- `out_of_warranty`
- `unknown`

---

## 3. Foreign Key Relationships

### From `addresses`
- `addresses.client_id` → `clients.id` (ON DELETE CASCADE)
- `addresses.estate_id` → `estates.id` (nullable)
- `addresses.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `audit_log`
- `audit_log.actor_id` → `profiles.id` (nullable, ON DELETE SET NULL)
- `audit_log.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `brands`
- `brands.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `claim_items`
- `claim_items.claim_id` → `claims.id` (ON DELETE CASCADE)
- `claim_items.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `claim_queue_settings`
- `claim_queue_settings.tenant_id` → `tenants.id` (ON DELETE CASCADE, UNIQUE)

### From `claim_status_history`
- `claim_status_history.changed_by` → `profiles.id` (nullable, ON DELETE SET NULL)
- `claim_status_history.claim_id` → `claims.id` (ON DELETE CASCADE)
- `claim_status_history.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `claims`
- `claims.address_id` → `addresses.id` (ON DELETE RESTRICT)
- `claims.agent_id` → `profiles.id` (nullable, ON DELETE SET NULL)
- `claims.client_id` → `clients.id` (ON DELETE RESTRICT)
- `claims.insurer_id` → `insurers.id` (ON DELETE RESTRICT)
- `claims.service_provider_id` → `service_providers.id` (nullable, ON DELETE SET NULL)
- `claims.technician_id` → `profiles.id` (nullable, ON DELETE SET NULL)
- `claims.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `clients`
- `clients.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `contact_attempts`
- `contact_attempts.attempted_by` → `profiles.id` (ON DELETE RESTRICT)
- `contact_attempts.claim_id` → `claims.id` (ON DELETE CASCADE)
- `contact_attempts.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `documents`
- `documents.claim_id` → `claims.id` (ON DELETE CASCADE)
- `documents.tenant_id` → `tenants.id` (ON DELETE CASCADE)
- `documents.uploaded_by` → `profiles.id` (nullable, ON DELETE SET NULL)

### From `estates`
- `estates.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `insurers`
- `insurers.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `profiles`
- `profiles.id` → `auth.users.id` (ON DELETE CASCADE)
- `profiles.tenant_id` → `tenants.id` (ON DELETE RESTRICT)

### From `service_providers`
- `service_providers.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `sla_rules`
- `sla_rules.tenant_id` → `tenants.id` (ON DELETE CASCADE, UNIQUE)

### From `sms_messages`
- `sms_messages.claim_id` → `claims.id` (ON DELETE CASCADE)
- `sms_messages.tenant_id` → `tenants.id` (ON DELETE CASCADE)

### From `sms_templates`
- `sms_templates.tenant_id` → `tenants.id` (ON DELETE CASCADE)

---

## 4. Row Level Security (RLS) Policies

### `addresses`
- **RLS Enabled:** ✅
- **Policies:**
  - `addresses tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `addresses tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `addresses tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `addresses tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `audit_log`
- **RLS Enabled:** ✅
- **Policies:**
  - `audit_log admin select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `audit_log admin mutate` (ALL)
    - **USING:** `profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `brands`
- **RLS Enabled:** ✅
- **Policies:**
  - `brands tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `brands admin mutate` (ALL)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `brands service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `claim_items`
- **RLS Enabled:** ✅
- **Policies:**
  - `claim_items tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claim_items tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claim_items tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claim_items tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `claim_queue_settings`
- **RLS Enabled:** ✅
- **Policies:**
  - `claim_queue_settings tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claim_queue_settings admin mutate` (ALL)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `claim_status_history`
- **RLS Enabled:** ✅
- **Policies:**
  - `claim_status_history tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claim_status_history tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claim_status_history tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claim_status_history tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `claims`
- **RLS Enabled:** ✅
- **Policies:**
  - `claims tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claims tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claims tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `claims tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `clients`
- **RLS Enabled:** ✅
- **Policies:**
  - `clients tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `clients tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `clients tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `clients tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `contact_attempts`
- **RLS Enabled:** ✅
- **Policies:**
  - `contact_attempts tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `contact_attempts tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `contact_attempts tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `contact_attempts tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `documents`
- **RLS Enabled:** ✅
- **Policies:**
  - `documents tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `documents tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `documents tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `documents tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `estates`
- **RLS Enabled:** ✅
- **Policies:**
  - `estates tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `estates admin mutate` (ALL)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `estates service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `insurers`
- **RLS Enabled:** ✅
- **Policies:**
  - `insurers tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `insurers admin mutate` (ALL)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `profiles`
- **RLS Enabled:** ✅
- **Policies:**
  - `profiles tenant select` (SELECT)
    - **USING:** `profile_is_active() AND (tenant_id = current_tenant_id())`
  - `profiles self update` (UPDATE)
    - **USING:** `profile_is_active() AND ((id = auth.uid()) OR (profile_is_admin() AND (tenant_id = current_tenant_id())))`
    - **WITH CHECK:** `(tenant_id = current_tenant_id())`
  - `profiles admin insert` (INSERT)
    - **WITH CHECK:** `profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `profiles admin delete` (DELETE)
    - **USING:** `profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `service_providers`
- **RLS Enabled:** ✅
- **Policies:**
  - `service_providers tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `service_providers admin mutate` (ALL)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `sla_rules`
- **RLS Enabled:** ✅
- **Policies:**
  - `sla_rules tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `sla_rules admin mutate` (ALL)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `sms_messages`
- **RLS Enabled:** ✅
- **Policies:**
  - `sms_messages tenant select` (SELECT)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `sms_messages tenant insert` (INSERT)
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `sms_messages tenant update` (UPDATE)
    - **USING:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin_or_agent() AND (tenant_id = current_tenant_id())`
  - `sms_messages tenant delete` (DELETE)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

### `sms_templates`
- **RLS Enabled:** ✅
- **Policies:**
  - `sms templates tenant select` (SELECT)
    - **USING:** `profile_is_active() AND (tenant_id = current_tenant_id())`
  - `sms templates admin manage` (ALL)
    - **USING:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_active() AND profile_is_admin() AND (tenant_id = current_tenant_id())`

### `tenants`
- **RLS Enabled:** ✅
- **Policies:**
  - `tenants tenant select` (SELECT)
    - **USING:** `profile_is_active() AND (id = current_tenant_id())`
  - `tenants admin update` (UPDATE)
    - **USING:** `profile_is_admin() AND (id = current_tenant_id())`
    - **WITH CHECK:** `profile_is_admin() AND (id = current_tenant_id())`
  - `service role access` (ALL)
    - **USING:** `auth.role() = 'service_role'`
    - **WITH CHECK:** `auth.role() = 'service_role'`

---

## RLS Helper Functions

The following security definer functions are used in RLS policies:

- `current_tenant_id()` - Returns the tenant_id of the current user's profile
- `profile_is_active()` - Returns whether the current user's profile is active
- `profile_is_admin()` - Returns whether the current user has admin role
- `profile_is_claim_agent()` - Returns whether the current user has claim_agent role
- `profile_is_admin_or_agent()` - Returns whether the current user has admin or claim_agent role

---

## Notes

- All tables have RLS enabled
- All tenant-scoped tables include `tenant_id` column
- Service role bypass exists on all tables for backend operations
- DELETE operations generally require admin role
- Reference data tables (insurers, service_providers, brands, estates, sla_rules, claim_queue_settings) require admin for mutations
- `profiles` table allows self-updates for non-admin users
- `sms_templates` allows all active users to select (not just admin_or_agent)

