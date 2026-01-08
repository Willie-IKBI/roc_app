# Claim Flow Alignment Analysis & Implementation Plan

**Status:** Analysis & Planning  
**Purpose:** Compare claim flow map requirements with current implementation and create alignment plan  
**Date:** 2025-01-XX

---

## Executive Summary

This document compares the business process flow defined in `CLAIM_FLOW_MAP.md` with the current application implementation. It identifies gaps, differences, and missing features, then provides a detailed plan to align the backend and frontend to meet the business requirements.

**Key Findings:**
- **Current State:** Basic claim creation, scheduling, and status management exists
- **Gaps:** Missing item-specific questions, travel distance validation, excess payment tracking, damage report submission workflow, repair authorization process
- **Alignment Required:** Significant enhancements needed across 7 stages of the claim flow

---

## Stage-by-Stage Comparison

### Stage 1: Claim Intake & Verification (Charné)

#### ✅ What's Currently Implemented

| Requirement | Current Implementation | Status |
|-------------|----------------------|--------|
| Client Full Name | `ClientInput.firstName`, `ClientInput.lastName` | ✅ Implemented |
| Client Phone Number | `ClientInput.primaryPhone`, `ClientInput.altPhone` | ✅ Implemented |
| Client Address | `AddressInput` with Google Maps integration | ✅ Implemented |
| Address Verification | Google Maps search, place selection, coordinates | ✅ Implemented |
| Claim Number | `ClaimDraft.claimNumber` | ✅ Implemented |
| Insurance Company | `ClaimDraft.insurerId` | ✅ Implemented |
| Item(s) Being Claimed | `ClaimItemDraft` with brand, color, warranty, serial/model | ✅ Implemented |
| Claimed Cause of Damage | `ClaimDraft.damageCause` (enum) | ✅ Implemented |
| Date Claim Received | ❌ **NOT CAPTURED** | ❌ Missing |
| Contact Attempts | `ContactAttempt` model exists | ✅ Implemented |

#### ❌ What's Missing

| Requirement | Gap Description | Impact |
|-------------|----------------|--------|
| **Date Claim Received** | No field to capture when claim was received | Cannot track claim age or SLA from receipt date |
| **Item-Specific Questions** | Missing TV, Inverter/Solar specific fields | Cannot capture required business information |
| **Travel Distance Check** | No validation for >100 km travel | Cannot enforce insurer approval requirement |
| **Travel Approval Tracking** | No field to track insurer approval for long travel | Cannot prevent booking without approval |
| **Client Verification Checklist** | No structured workflow for verification steps | Manual process, no system enforcement |
| **Address Pin Verification** | No explicit "address pins correctly" validation | May allow invalid addresses |
| **WhatsApp Pin Location** | No field to store WhatsApp pin location | Cannot handle addresses that don't pin |
| **Follow-up List** | No system for tracking unreachable clients | Manual tracking outside system |

#### 🔧 Required Changes

**Database Schema:**
- Add `date_received` column to `claims` table (date)
- Add `travel_distance_km` column to `claims` table (numeric, nullable)
- Add `travel_approval_required` boolean column to `claims` table
- Add `travel_approval_received` boolean column to `claims` table
- Add `travel_approval_date` timestamp column to `claims` table (nullable)
- Add `address_pins_correctly` boolean column to `addresses` table
- Add `whatsapp_pin_location` text column to `addresses` table (nullable)
- Add `item_type` enum column to `claim_items` table (TV, Inverter, Appliance, Building, Electrical, Other)
- Add `item_size` text column to `claim_items` table (nullable, for TV size)
- Add `item_mounting_type` enum column to `claim_items` table (nullable, WallMounted, FreeStanding)
- Add `inverter_installation_type` enum column to `claim_items` table (nullable, Fixed, Portable)
- Add `inverter_battery_count` integer column to `claim_items` table (nullable)
- Add `solar_system` boolean column to `claim_items` table
- Add `solar_panel_count` integer column to `claim_items` table (nullable)
- Add `solar_installation_year` integer column to `claim_items` table (nullable)
- Add `solar_panel_location` text column to `claim_items` table (nullable)

**Domain Models:**
- Update `Claim` model to include `dateReceived`, `travelDistanceKm`, `travelApprovalRequired`, `travelApprovalReceived`, `travelApprovalDate`
- Update `ClaimItem` model to include item-specific fields (type, size, mounting, inverter fields, solar fields)
- Create `ItemType` enum (TV, Inverter, Appliance, Building, Electrical, Other)
- Create `MountingType` enum (WallMounted, FreeStanding)
- Create `InverterInstallationType` enum (Fixed, Portable)

**UI Changes:**
- Add date picker for "Date Claim Received" in capture screen
- Add travel distance calculation and validation in capture screen
- Add travel approval workflow (request, track, block booking)
- Add item type selector in claim items form
- Add conditional fields based on item type (TV fields, Inverter fields, etc.)
- Add address pin verification checkbox/validation
- Add WhatsApp pin location field for addresses that don't pin
- Add client verification checklist UI (checkboxes for each verification step)

**Business Logic:**
- Implement travel distance calculation using `TravelTimeService` or Google Maps Distance Matrix API
- Implement >100 km validation that blocks appointment booking
- Implement travel approval request workflow
- Implement item-specific question logic (show/hide fields based on item type)

---

### Stage 2: Appointment Scheduling & Booking (Shae)

#### ✅ What's Currently Implemented

| Requirement | Current Implementation | Status |
|-------------|----------------------|--------|
| Technician Assignment | `ClaimDraft.technicianId` | ✅ Implemented |
| Appointment Date | `ClaimDraft.appointmentDate` | ✅ Implemented |
| Appointment Time | `ClaimDraft.appointmentTime` | ✅ Implemented |
| Scheduling Screen | `SchedulingScreen` with day view | ✅ Implemented |
| Technician Schedules | `TechnicianSchedule` model | ✅ Implemented |
| Travel Time Calculation | `TravelTimeService` exists | ✅ Implemented |
| Appointment Duration | `estimated_duration_minutes` column exists | ✅ Implemented |
| Travel Time Tracking | `travel_time_minutes` column exists | ✅ Implemented |

#### ❌ What's Missing

| Requirement | Gap Description | Impact |
|-------------|----------------|--------|
| **Time Allocation Rules** | No automatic time allocation based on job type | Manual time entry, prone to errors |
| **Job Type Classification** | No field to classify job type (Single Item, Appliance, Building, Electrical, etc.) | Cannot apply time allocation rules |
| **Small Units Collection** | No special handling for 30-minute collection appointments | Cannot differentiate collection vs assessment |
| **Collection Form Tracking** | No field to track if collection form signed | Missing business requirement |
| **Return Item Appointments** | No special appointment type for returning rejected items | Cannot track return appointments separately |
| **Return Letter Tracking** | No field to track return letter signature | Missing proof of return |
| **Client Time Preference** | No field to capture client's preferred time | Cannot optimize scheduling |
| **Client Unhappy Workflow** | No system for handling client time conflicts | Manual email process |
| **Delay Logging** | No structured delay tracking | Cannot report on delays |
| **Booking Confirmation** | No automated confirmation to client | Manual process |

#### 🔧 Required Changes

**Database Schema:**
- Add `job_type` enum column to `claims` table (SingleItem, Appliance, Building, Electrical, SmallUnitsCollection, ReturnItem)
- Add `is_collection` boolean column to `claims` table
- Add `collection_form_signed` boolean column to `claims` table
- Add `collection_form_signed_date` timestamp column to `claims` table (nullable)
- Add `is_return_appointment` boolean column to `claims` table
- Add `return_letter_signed` boolean column to `claims` table
- Add `return_letter_signed_date` timestamp column to `claims` table (nullable)
- Add `client_preferred_date` date column to `claims` table (nullable)
- Add `client_preferred_time` time column to `claims` table (nullable)
- Add `client_time_conflict` boolean column to `claims` table
- Add `delay_reason` text column to `claims` table (nullable)
- Add `delay_logged_at` timestamp column to `claims` table (nullable)
- Create `claim_delays` table for structured delay tracking:
  ```sql
  create table claim_delays (
    id uuid primary key,
    claim_id uuid references claims(id),
    delay_type text not null, -- 'client_unreachable', 'client_time_conflict', 'travel_approval', etc.
    reason text,
    logged_by uuid references profiles(id),
    logged_at timestamptz default now(),
    resolved_at timestamptz
  );
  ```

**Domain Models:**
- Create `JobType` enum (SingleItem, Appliance, Building, Electrical, SmallUnitsCollection, ReturnItem)
- Create `ClaimDelay` model
- Create `DelayType` enum
- Update `Claim` model with new scheduling fields

**UI Changes:**
- Add job type selector in scheduling/appointment booking
- Add automatic time allocation based on job type and item count
- Add collection form tracking UI
- Add return appointment type selector
- Add return letter tracking UI
- Add client time preference capture
- Add delay logging UI with reason selection
- Add booking confirmation workflow (email/SMS)

**Business Logic:**
- Implement time allocation rules:
  - Single Item: 1 hour
  - Appliances: 1 hour per item
  - Small Units Collection: 30 minutes (if entire claim is small units)
  - Building Work: 1 hour 30 minutes
  - Electrical (1-2 items): 1 hour 30 minutes to 2 hours
  - Electrical (>2 items): >2 hours
  - Return Item: 30 minutes
- Implement automatic duration calculation based on job type and item count
- Implement delay tracking and reporting
- Implement booking confirmation automation

---

### Stage 3: Day Before Scheduled Appointments

#### ✅ What's Currently Implemented

| Requirement | Current Implementation | Status |
|-------------|----------------------|--------|
| Appointment Lists | Scheduling screen shows appointments | ✅ Implemented |
| Technician Grouping | Appointments grouped by technician | ✅ Implemented |

#### ❌ What's Missing

| Requirement | Gap Description | Impact |
|-------------|----------------|--------|
| **WhatsApp Integration** | No automated WhatsApp message generation | Manual process, time-consuming |
| **Appointment Message Format** | No standardized message format | Inconsistent communication |
| **Manager Board** | No digital manager board view | Physical board only |
| **Job Card Sorting** | No automated sorting by date/technician | Manual sorting |
| **Job Card Placement** | No digital job card organization | Physical cards only |

#### 🔧 Required Changes

**Database Schema:**
- No schema changes required (data exists, need UI/workflow)

**UI Changes:**
- Add "Day Before" workflow screen
- Add appointment list export/generation for WhatsApp
- Add manager board view (digital visualization of appointments)
- Add job card sorting and organization UI
- Add WhatsApp message template with appointment details
- Add bulk WhatsApp sending capability (per technician)

**Business Logic:**
- Implement appointment message formatting:
  ```
  [Technician] appointments for [Date]
  
  [Time] – [End Time]
  [Client Name]
  [Phone Number]
  [Full Address]
  [Google Maps link]
  [Items] – [Details]
  [Cause of Damage]
  [Claim Number]
  [Insurance Company]
  ```
- Implement automated WhatsApp message generation
- Implement manager board visualization (calendar view, technician columns)
- Implement job card sorting algorithm (by date, technician, time)

**Integration:**
- WhatsApp API integration (or manual copy-paste workflow)
- Google Maps link generation for addresses

---

### Stage 4: Day of the Appointment

#### ✅ What's Currently Implemented

| Requirement | Current Implementation | Status |
|-------------|----------------------|--------|
| Appointment View | Scheduling screen shows day's appointments | ✅ Implemented |
| Technician Assignment | Can assign technicians to claims | ✅ Implemented |

#### ❌ What's Missing

| Requirement | Gap Description | Impact |
|-------------|----------------|--------|
| **Manager Review Workflow** | No digital manager board for review | Physical board only |
| **Schedule Adjustments** | No easy way to adjust appointments on day of | Manual process |
| **Morning Meeting View** | No consolidated view for morning briefing | Manual preparation |
| **Job Card Distribution** | No digital job card handoff | Physical cards only |
| **Technician Briefing** | No structured briefing information | Verbal only |

#### 🔧 Required Changes

**UI Changes:**
- Add "Day Of" workflow screen
- Add manager review board (read-only view of day's appointments)
- Add appointment adjustment UI (reassign, reschedule, cancel)
- Add morning meeting view (all technicians, all appointments, routes)
- Add job card digital view (all claim details in one screen)
- Add technician briefing screen (personalized view for each technician)

**Business Logic:**
- Implement appointment adjustment workflow (with validation)
- Implement route optimization visualization
- Implement technician briefing generation (personalized appointment list)

---

### Stage 5: Damage Report Submission (Technicians)

#### ✅ What's Currently Implemented

| Requirement | Current Implementation | Status |
|-------------|----------------------|--------|
| Claim Detail View | `ClaimDetailScreen` exists | ✅ Implemented |
| Notes | `Claim.notesPublic`, `Claim.notesInternal` | ✅ Implemented |

#### ❌ What's Missing

| Requirement | Gap Description | Impact |
|-------------|----------------|--------|
| **Damage Report Form** | No dedicated damage report submission form | External Google Form only |
| **Photo Upload** | No photo upload capability | WhatsApp only |
| **24-Hour Submission Tracking** | No tracking of submission deadline | Cannot enforce 24-hour rule |
| **Unit Assessment Tracking** | No per-unit assessment tracking | Cannot verify all units assessed |
| **Damage Documentation** | No structured damage documentation | Free-form notes only |
| **Photo Organization** | No photo organization by unit | Manual organization |

#### 🔧 Required Changes

**Database Schema:**
- Create `damage_reports` table:
  ```sql
  create table damage_reports (
    id uuid primary key,
    claim_id uuid references claims(id),
    submitted_by uuid references profiles(id),
    submitted_at timestamptz default now(),
    assessment_date date not null,
    client_seen boolean not null default false,
    all_units_assessed boolean not null default false,
    notes text,
    status text not null default 'draft' -- 'draft', 'submitted', 'verified'
  );
  ```
- Create `damage_report_units` table:
  ```sql
  create table damage_report_units (
    id uuid primary key,
    damage_report_id uuid references damage_reports(id),
    claim_item_id uuid references claim_items(id),
    damage_description text not null,
    assessment_notes text,
    created_at timestamptz default now()
  );
  ```
- Create `damage_report_photos` table:
  ```sql
  create table damage_report_photos (
    id uuid primary key,
    damage_report_id uuid references damage_reports(id),
    damage_report_unit_id uuid references damage_report_units(id),
    photo_url text not null, -- Supabase Storage URL
    photo_path text not null, -- Storage path
    uploaded_at timestamptz default now(),
    uploaded_by uuid references profiles(id)
  );
  ```
- Add `damage_report_submitted_at` timestamp column to `claims` table (nullable)
- Add `damage_report_submission_deadline` timestamp column to `claims` table (nullable)

**Domain Models:**
- Create `DamageReport` model
- Create `DamageReportUnit` model
- Create `DamageReportPhoto` model
- Create `DamageReportStatus` enum

**UI Changes:**
- Add damage report submission screen
- Add photo upload UI (multiple photos per unit)
- Add unit-by-unit assessment form
- Add 24-hour deadline countdown/tracking
- Add photo gallery view (organized by unit)
- Add damage report status tracking

**Business Logic:**
- Implement 24-hour deadline calculation (appointment date + 24 hours)
- Implement photo upload to Supabase Storage
- Implement damage report validation (all units assessed, photos uploaded)
- Implement submission tracking and reminders

**Storage:**
- Configure Supabase Storage bucket for damage report photos
- Implement photo organization: `damage-reports/{claim_id}/{unit_id}/{photo_filename}`

---

### Stage 6: Damage Report Processing (Damage Report Department)

#### ✅ What's Currently Implemented

| Requirement | Current Implementation | Status |
|-------------|----------------------|--------|
| Claim Viewing | Can view claims and details | ✅ Implemented |

#### ❌ What's Missing

| Requirement | Gap Description | Impact |
|-------------|----------------|--------|
| **Google Drive Integration** | No integration with Google Drive | Manual file management |
| **Client File Organization** | No digital file organization | Physical/Google Drive only |
| **Report Verification Workflow** | No structured verification process | Manual checking |
| **Quote/Invoice Generation** | No quote/invoice system | External system only |
| **Digicall Special Handling** | No special workflow for Digicall claims | Manual process |

#### 🔧 Required Changes

**Database Schema:**
- Add `quote_generated` boolean column to `claims` table
- Add `quote_generated_at` timestamp column to `claims` table (nullable)
- Add `invoice_generated` boolean column to `claims` table
- Add `invoice_generated_at` timestamp column to `claims` table (nullable)
- Add `is_digicall_claim` boolean column to `claims` table (derived from insurer)
- Add `digicall_processed` boolean column to `claims` table
- Add `digicall_processed_at` timestamp column to `claims` table (nullable)
- Create `quotes` table:
  ```sql
  create table quotes (
    id uuid primary key,
    claim_id uuid references claims(id),
    quote_number text not null,
    total_amount numeric not null,
    generated_by uuid references profiles(id),
    generated_at timestamptz default now(),
    status text not null default 'draft' -- 'draft', 'sent', 'approved', 'rejected'
  );
  ```
- Create `invoices` table:
  ```sql
  create table invoices (
    id uuid primary key,
    claim_id uuid references claims(id),
    invoice_number text not null,
    total_amount numeric not null,
    generated_by uuid references profiles(id),
    generated_at timestamptz default now(),
    status text not null default 'draft' -- 'draft', 'sent', 'paid', 'cancelled'
  );
  ```

**UI Changes:**
- Add damage report verification screen
- Add quote generation UI
- Add invoice generation UI
- Add Digicall workflow UI (separate process)
- Add file organization view (digital client files)

**Business Logic:**
- Implement quote generation workflow
- Implement invoice generation workflow
- Implement Digicall special handling (flag, separate process)
- Implement verification checklist (all units, photos, information)

**Integration:**
- Google Drive API integration (optional, for file sync)
- Or: Use Supabase Storage for digital file organization

---

### Stage 7: Repair Authorization Process

#### ✅ What's Currently Implemented

| Requirement | Current Implementation | Status |
|-------------|----------------------|--------|
| Claim Status Management | `ClaimStatus` enum and status changes | ✅ Implemented |
| Status History | `ClaimStatusChange` tracking | ✅ Implemented |

#### ❌ What's Missing

| Requirement | Gap Description | Impact |
|-------------|----------------|--------|
| **Repair Authorization Tracking** | No field to track authorization received | Cannot track authorization status |
| **Excess Payment Tracking** | No excess amount or payment tracking | Cannot enforce POP requirement |
| **POP Verification** | No proof of payment verification | Cannot track payment status |
| **Stock Management** | No stock ordering or arrival tracking | Cannot coordinate repair booking |
| **Repair Appointment Booking** | No separate workflow for repair appointments | Uses same as assessment |
| **Authorization Workflow** | No structured authorization process | Manual tracking |

#### 🔧 Required Changes

**Database Schema:**
- Add `repair_authorization_received` boolean column to `claims` table
- Add `repair_authorization_date` timestamp column to `claims` table (nullable)
- Add `repair_authorization_items` jsonb column to `claims` table (nullable, list of authorized items)
- Add `excess_amount` numeric column to `claims` table (nullable)
- Add `excess_invoice_sent` boolean column to `claims` table
- Add `excess_invoice_sent_at` timestamp column to `claims` table (nullable)
- Add `excess_payment_received` boolean column to `claims` table
- Add `excess_payment_received_at` timestamp column to `claims` table (nullable)
- Add `excess_pop_verified` boolean column to `claims` table
- Add `excess_pop_verified_at` timestamp column to `claims` table (nullable)
- Add `stock_ordered` boolean column to `claims` table
- Add `stock_ordered_at` timestamp column to `claims` table (nullable)
- Add `stock_arrived` boolean column to `claims` table
- Add `stock_arrived_at` timestamp column to `claims` table (nullable)
- Add `repair_appointment_date` date column to `claims` table (nullable)
- Add `repair_appointment_time` time column to `claims` table (nullable)
- Add `repair_technician_id` uuid column to `claims` table (nullable, references profiles)
- Create `stock_orders` table:
  ```sql
  create table stock_orders (
    id uuid primary key,
    claim_id uuid references claims(id),
    order_number text not null,
    ordered_by uuid references profiles(id),
    ordered_at timestamptz default now(),
    expected_arrival_date date,
    arrived_at timestamptz,
    status text not null default 'ordered' -- 'ordered', 'in_transit', 'arrived', 'cancelled'
  );
  ```
- Create `stock_order_items` table:
  ```sql
  create table stock_order_items (
    id uuid primary key,
    stock_order_id uuid references stock_orders(id),
    claim_item_id uuid references claim_items(id),
    part_number text,
    quantity integer not null default 1,
    unit_price numeric,
    total_price numeric
  );
  ```

**Domain Models:**
- Create `RepairAuthorization` model
- Create `ExcessPayment` model
- Create `StockOrder` model
- Create `StockOrderItem` model
- Update `Claim` model with repair authorization fields

**UI Changes:**
- Add repair authorization tracking screen
- Add excess payment workflow UI (amount, invoice, POP verification)
- Add stock ordering UI
- Add stock arrival tracking UI
- Add repair appointment booking UI (separate from assessment)
- Add authorization workflow visualization

**Business Logic:**
- Implement authorization received workflow
- Implement excess calculation and invoice generation
- Implement POP verification workflow
- Implement stock ordering workflow
- Implement stock arrival notification
- Implement repair appointment booking (reuse assessment booking logic)
- Implement blocking logic: cannot book repair until POP received and stock arrived

---

## Summary: What's the Same vs. What's Different

### ✅ What's Already Implemented (No Changes Needed)

1. **Basic Claim Creation:**
   - Client information capture
   - Address capture with Google Maps
   - Claim number, insurer, items, damage cause
   - Appointment scheduling basics

2. **Scheduling Infrastructure:**
   - Technician assignment
   - Appointment date/time
   - Travel time calculation service
   - Appointment duration tracking

3. **Status Management:**
   - Claim status enum and changes
   - Status history tracking
   - Contact attempts

4. **Data Models:**
   - Claim, ClaimItem, Client, Address models
   - Basic relationships and structure

### ❌ What's Missing or Different

1. **Stage 1 Gaps:**
   - Date claim received
   - Item-specific questions (TV, Inverter, Solar)
   - Travel distance validation (>100 km)
   - Travel approval workflow
   - Address pin verification
   - Client verification checklist

2. **Stage 2 Gaps:**
   - Automatic time allocation by job type
   - Job type classification
   - Collection form tracking
   - Return appointment handling
   - Delay logging
   - Booking confirmation automation

3. **Stage 3 Gaps:**
   - WhatsApp integration
   - Manager board digital view
   - Automated appointment message generation

4. **Stage 4 Gaps:**
   - Manager review workflow
   - Morning meeting view
   - Digital job card distribution

5. **Stage 5 Gaps:**
   - Damage report submission form
   - Photo upload capability
   - 24-hour submission tracking
   - Unit-by-unit assessment

6. **Stage 6 Gaps:**
   - Quote/invoice generation
   - Damage report verification workflow
   - Digicall special handling

7. **Stage 7 Gaps:**
   - Repair authorization tracking
   - Excess payment workflow
   - POP verification
   - Stock management
   - Repair appointment booking

---

## Implementation Plan

### Phase 1: Foundation & Critical Path (Weeks 1-2)

**Priority: High - Blocks core workflow**

1. **Database Schema Updates:**
   - Add `date_received` to claims
   - Add travel distance and approval fields
   - Add item-specific fields to claim_items
   - Create item type enums

2. **Item-Specific Questions:**
   - Add item type selector
   - Add conditional fields (TV, Inverter, Solar)
   - Update capture screen UI

3. **Travel Distance Validation:**
   - Implement distance calculation
   - Add >100 km validation
   - Add travel approval workflow
   - Block appointment booking if approval missing

### Phase 2: Scheduling Enhancements (Weeks 3-4)

**Priority: High - Improves scheduling accuracy**

1. **Job Type & Time Allocation:**
   - Add job type classification
   - Implement automatic time allocation rules
   - Update scheduling UI

2. **Collection & Return Appointments:**
   - Add collection form tracking
   - Add return appointment type
   - Add return letter tracking

3. **Delay Tracking:**
   - Create delay tracking system
   - Add delay logging UI
   - Add delay reporting

### Phase 3: Day Before & Day Of Workflows (Week 5)

**Priority: Medium - Improves daily operations**

1. **WhatsApp Integration:**
   - Add appointment message template
   - Add message generation
   - Add bulk sending capability

2. **Manager Board:**
   - Create digital manager board view
   - Add appointment visualization
   - Add adjustment capabilities

3. **Morning Meeting View:**
   - Create consolidated briefing view
   - Add technician-specific views
   - Add route visualization

### Phase 4: Damage Report Submission (Weeks 6-7)

**Priority: High - Critical for technicians**

1. **Damage Report Form:**
   - Create damage report submission screen
   - Add unit-by-unit assessment
   - Add photo upload capability

2. **Photo Management:**
   - Set up Supabase Storage
   - Implement photo organization
   - Add photo gallery view

3. **24-Hour Tracking:**
   - Add submission deadline tracking
   - Add reminders and notifications
   - Add submission status

### Phase 5: Damage Report Processing (Week 8)

**Priority: Medium - Internal workflow**

1. **Verification Workflow:**
   - Create verification screen
   - Add checklist UI
   - Add verification status tracking

2. **Quote/Invoice Generation:**
   - Create quote generation UI
   - Create invoice generation UI
   - Add Digicall special handling

### Phase 6: Repair Authorization (Weeks 9-10)

**Priority: High - Completes claim lifecycle**

1. **Authorization Tracking:**
   - Add authorization received workflow
   - Add authorized items tracking
   - Update claim status flow

2. **Excess Payment:**
   - Add excess amount capture
   - Add invoice generation
   - Add POP verification workflow
   - Block stock ordering until POP received

3. **Stock Management:**
   - Create stock ordering UI
   - Add stock arrival tracking
   - Add notifications

4. **Repair Booking:**
   - Create repair appointment booking workflow
   - Reuse assessment booking logic
   - Add repair-specific validation

---

## Detailed TODO List

### Database Migrations

- [ ] **Migration 1:** Add date_received, travel fields, item-specific fields
- [ ] **Migration 2:** Add job type, collection, return appointment fields
- [ ] **Migration 3:** Create claim_delays table
- [ ] **Migration 4:** Create damage_reports, damage_report_units, damage_report_photos tables
- [ ] **Migration 5:** Create quotes, invoices tables
- [ ] **Migration 6:** Add repair authorization, excess, stock fields
- [ ] **Migration 7:** Create stock_orders, stock_order_items tables

### Domain Models

- [ ] Create `ItemType` enum
- [ ] Create `MountingType` enum
- [ ] Create `InverterInstallationType` enum
- [ ] Create `JobType` enum
- [ ] Create `DelayType` enum
- [ ] Create `DamageReportStatus` enum
- [ ] Update `Claim` model with new fields
- [ ] Update `ClaimItem` model with item-specific fields
- [ ] Create `ClaimDelay` model
- [ ] Create `DamageReport` model
- [ ] Create `DamageReportUnit` model
- [ ] Create `DamageReportPhoto` model
- [ ] Create `Quote` model
- [ ] Create `Invoice` model
- [ ] Create `RepairAuthorization` model
- [ ] Create `ExcessPayment` model
- [ ] Create `StockOrder` model
- [ ] Create `StockOrderItem` model

### Repository Layer

- [ ] Add methods for travel distance calculation
- [ ] Add methods for travel approval tracking
- [ ] Add methods for delay logging
- [ ] Add methods for damage report CRUD
- [ ] Add methods for photo upload/download
- [ ] Add methods for quote/invoice generation
- [ ] Add methods for repair authorization tracking
- [ ] Add methods for excess payment tracking
- [ ] Add methods for stock order management

### UI Components

- [ ] **Capture Screen:**
  - [ ] Add date_received picker
  - [ ] Add item type selector
  - [ ] Add conditional item fields (TV, Inverter, Solar)
  - [ ] Add travel distance calculation and validation
  - [ ] Add travel approval workflow UI
  - [ ] Add address pin verification
  - [ ] Add client verification checklist

- [ ] **Scheduling Screen:**
  - [ ] Add job type selector
  - [ ] Add automatic time allocation
  - [ ] Add collection form tracking
  - [ ] Add return appointment type
  - [ ] Add delay logging UI

- [ ] **Day Before Screen:**
  - [ ] Add appointment list export
  - [ ] Add WhatsApp message generation
  - [ ] Add manager board view

- [ ] **Day Of Screen:**
  - [ ] Add manager review board
  - [ ] Add appointment adjustment UI
  - [ ] Add morning meeting view
  - [ ] Add technician briefing screen

- [ ] **Damage Report Screen:**
  - [ ] Create damage report submission form
  - [ ] Add unit-by-unit assessment
  - [ ] Add photo upload UI
  - [ ] Add 24-hour deadline tracking
  - [ ] Add photo gallery view

- [ ] **Damage Report Processing Screen:**
  - [ ] Add verification checklist
  - [ ] Add quote generation UI
  - [ ] Add invoice generation UI
  - [ ] Add Digicall workflow UI

- [ ] **Repair Authorization Screen:**
  - [ ] Add authorization tracking
  - [ ] Add excess payment workflow
  - [ ] Add POP verification UI
  - [ ] Add stock ordering UI
  - [ ] Add stock arrival tracking
  - [ ] Add repair appointment booking

### Business Logic

- [ ] Implement travel distance calculation
- [ ] Implement >100 km validation
- [ ] Implement travel approval workflow
- [ ] Implement time allocation rules
- [ ] Implement delay tracking
- [ ] Implement WhatsApp message formatting
- [ ] Implement damage report validation
- [ ] Implement photo upload to Supabase Storage
- [ ] Implement 24-hour deadline tracking
- [ ] Implement quote generation
- [ ] Implement invoice generation
- [ ] Implement authorization workflow
- [ ] Implement excess payment workflow
- [ ] Implement POP verification
- [ ] Implement stock ordering workflow
- [ ] Implement repair appointment booking

### Integration

- [ ] Set up Supabase Storage for photos
- [ ] Configure storage buckets and policies
- [ ] Implement photo upload/download
- [ ] WhatsApp API integration (or manual workflow)
- [ ] Google Maps link generation
- [ ] Email/SMS integration for confirmations

### Testing

- [ ] Unit tests for new domain models
- [ ] Unit tests for business logic
- [ ] Integration tests for repository methods
- [ ] UI tests for new screens
- [ ] End-to-end workflow tests
- [ ] Performance tests for photo uploads

---

## Technical Architecture Considerations

### Database Design

**New Tables:**
- `claim_delays` - Track delays with type and reason
- `damage_reports` - Damage report submissions
- `damage_report_units` - Per-unit assessments
- `damage_report_photos` - Photo storage references
- `quotes` - Quote generation and tracking
- `invoices` - Invoice generation and tracking
- `stock_orders` - Stock ordering and tracking
- `stock_order_items` - Items in stock orders

**New Columns:**
- Extensive additions to `claims` table (20+ new columns)
- Additions to `claim_items` table (10+ new columns)
- Additions to `addresses` table (2 new columns)

**Indexes:**
- Index on `claims.date_received`
- Index on `claims.repair_authorization_received`
- Index on `claims.excess_payment_received`
- Index on `damage_reports.claim_id`
- Index on `damage_reports.submitted_at`
- Index on `stock_orders.claim_id`

### Storage Architecture

**Supabase Storage:**
- Bucket: `damage-report-photos`
- Path structure: `{claim_id}/{unit_id}/{timestamp}_{filename}`
- RLS policies for photo access
- File size limits (e.g., 10MB per photo)
- Supported formats: JPG, PNG, HEIC

### API Considerations

**New Endpoints Needed:**
- Travel distance calculation endpoint
- Photo upload endpoint
- Quote generation endpoint
- Invoice generation endpoint
- WhatsApp message generation endpoint

**External Integrations:**
- Google Maps Distance Matrix API (already used)
- WhatsApp Business API (or manual workflow)
- Email service for confirmations
- SMS service for notifications

### Performance Considerations

**Optimizations:**
- Cache travel distance calculations
- Optimize photo upload (compression, resizing)
- Paginate damage report lists
- Index all new foreign keys
- Consider materialized views for reporting

**Scalability:**
- Photo storage: Use CDN for photo delivery
- Batch operations: Bulk WhatsApp sending
- Background jobs: 24-hour deadline reminders
- Queue system: For async operations (photo processing, email sending)

---

## Risk Assessment

### High Risk Items

1. **Photo Upload Performance:**
   - Risk: Large files, slow uploads
   - Mitigation: Compression, resizing, progress indicators

2. **Database Schema Changes:**
   - Risk: Breaking existing functionality
   - Mitigation: Careful migration planning, backward compatibility

3. **WhatsApp Integration:**
   - Risk: API limitations, costs
   - Mitigation: Manual workflow fallback, message templates

4. **Complex Workflows:**
   - Risk: User confusion, incomplete data
   - Mitigation: Clear UI, validation, help text

### Medium Risk Items

1. **Time Allocation Rules:**
   - Risk: Incorrect calculations
   - Mitigation: Extensive testing, manual override

2. **Travel Distance Calculation:**
   - Risk: API failures, inaccurate distances
   - Mitigation: Caching, fallback to manual entry

3. **Excess Payment Workflow:**
   - Risk: Payment tracking errors
   - Mitigation: Audit trail, verification steps

---

## Success Criteria

### Phase 1 Success:
- ✅ Date received captured for all new claims
- ✅ Item-specific questions available for TV, Inverter, Solar
- ✅ Travel distance validation blocks >100 km bookings without approval
- ✅ Travel approval workflow functional

### Phase 2 Success:
- ✅ Automatic time allocation based on job type
- ✅ Collection and return appointments tracked
- ✅ Delay logging functional

### Phase 3 Success:
- ✅ WhatsApp appointment messages generated automatically
- ✅ Manager board view available
- ✅ Morning meeting view functional

### Phase 4 Success:
- ✅ Damage reports submitted within 24 hours
- ✅ Photos uploaded and organized by unit
- ✅ Submission tracking and reminders working

### Phase 5 Success:
- ✅ Quotes and invoices generated
- ✅ Verification workflow functional

### Phase 6 Success:
- ✅ Repair authorization tracked
- ✅ Excess payment workflow complete
- ✅ Stock management functional
- ✅ Repair appointments booked successfully

---

## Next Steps

1. **Review and Approve Plan:**
   - Review this document with stakeholders
   - Prioritize phases based on business needs
   - Adjust timeline as needed

2. **Start Phase 1:**
   - Create database migration for Phase 1 fields
   - Update domain models
   - Begin UI implementation

3. **Iterative Development:**
   - Complete each phase before moving to next
   - Test thoroughly at each phase
   - Gather user feedback

4. **Documentation:**
   - Update user documentation as features are added
   - Create training materials
   - Document API changes

---

**Document Version:** 1.0  
**Last Updated:** 2025-01-XX  
**Owner:** Development Team  
**Review Frequency:** Weekly during implementation
