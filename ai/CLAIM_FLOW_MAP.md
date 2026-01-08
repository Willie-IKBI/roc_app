# Claim Processing Flow Map

**Status:** Business Process Documentation  
**Purpose:** Complete end-to-end claim processing workflow from intake to repair authorization  
**Scope:** All stages of claim handling, scheduling, assessment, and repair booking

---

## Overview

This document maps the complete claim processing workflow from initial claim receipt through to repair authorization and booking. The process involves multiple roles (Charné - Intake, Shae - Scheduling, Technicians, Managers, Damage Report Department) and spans several days.

**Key Stages:**
1. Claim Intake & Verification (Charné)
2. Appointment Scheduling & Booking (Shae)
3. Day Before Appointments (Preparation)
4. Day of Appointment (Execution)
5. Damage Report Submission (Technicians)
6. Damage Report Processing (Damage Report Department)
7. Repair Authorization Process

---

## Stage 1: Claim Intake & Verification (Charné)

**Role:** Charné - Claims Intake & Verification  
**Duration:** Same day as claim receipt  
**Outcome:** Complete job card ready for scheduling

### Step 1.1: Claim Received
- **Trigger:** Claim received via email or insurer portal
- **Action:** Begin job card creation process

### Step 1.2: Create Job Card
**Required Information to Capture:**

| Field | Details | Validation |
|-------|---------|------------|
| Client Full Name | Full legal name | Required |
| Client Phone Number | Primary contact number | Required |
| Client Address | Full address with verification | See Address Process below |
| Claim Number | Insurance claim reference | Required |
| Insurance Company | Insurer name | Required |
| Item(s) Being Claimed | List of all items | Required |
| Claimed Cause of Damage | Primary cause | Required |
| Date Claim Received | Date claim was received | Required |

**Address Verification Process:**
1. Enter address into Google Maps
2. Confirm address pins correctly on map
3. Copy address exactly as shown on Google Maps
4. If address doesn't pin:
   - Request WhatsApp pin location while on call with client
   - Update address with verified location

### Step 1.3: Call Client to Confirm Details

**Contact Method:** Phone call to client

**Verification Checklist:**

#### Address & Location
- [ ] Confirm address is correct
- [ ] Verify address pins on Google Maps
- [ ] If address doesn't pin:
  - [ ] Request WhatsApp pin location during call
  - [ ] Update address with verified location

#### Travel Distance Check
- [ ] Check distance to client location
- [ ] Calculate total travel (to and from)
- [ ] If total travel > 100 km:
  - [ ] Request travel approval from insurer
  - [ ] **DO NOT** book appointment until approval received
  - [ ] Log approval request in system

#### Items Claimed
- [ ] Confirm all items being claimed
- [ ] Confirm brand of each item
- [ ] Confirm warranty status (under warranty or not)

#### TV-Specific Questions
- [ ] TV size
- [ ] TV brand
- [ ] Mounting type: Wall-mounted or free-standing?

#### Cause of Damage
- [ ] Confirm claimed cause:
  - Lightning
  - Power surge
  - Accidental damage
  - Other (specify)

#### Inverter / Solar-Specific Questions
- [ ] Inverter brand
- [ ] Installation type: Fixed (installed) or portable?
- [ ] If fixed:
  - [ ] Number of batteries
- [ ] Is it part of a solar system?
  - [ ] If yes:
    - [ ] Number of panels
    - [ ] Year of installation
    - [ ] Location of panels

### Step 1.4: Client Not Reachable

**If client does not answer:**

1. **Send WhatsApp Message**
   - Inform client of attempted call
   - Request callback or preferred contact time

2. **Log Delay**
   - Log delay in system
   - Notify insurer via email (if required)

3. **Follow-up**
   - Move claim to follow-up list
   - Attempt contact again next working day

### Step 1.5: Handoff to Scheduling

**Completion Criteria:**
- [ ] All job card fields completed
- [ ] Client details verified
- [ ] Address confirmed and pinned
- [ ] Travel distance approved (if > 100 km)
- [ ] All item-specific questions answered

**Action:** Hand completed job card to Shae for booking

---

## Stage 2: Appointment Scheduling & Booking (Shae)

**Role:** Shae - Scheduling  
**Duration:** Same day or next day after job card completion  
**Outcome:** Confirmed appointment with client

### Step 2.1: Organise Job Cards

**Grouping Strategy:**
- Group by insurance company
- Group by area/location
- Prioritize by claim date received

### Step 2.2: Check Technician Availability

**Resources:**
- Review appointment sheet (Google Sheets)
- Check available technicians
- Check available time slots

**Considerations:**
- Technician skill set for claim type
- Technician location/route
- Current workload

### Step 2.3: Check Travel & Routing

**Travel Analysis:**
- Check travel time from technician's previous appointment
- Check travel time to next available appointment
- Ensure travel time is realistic and manageable
- Account for traffic patterns
- Consider distance between appointments

**Decision Point:**
- If travel time is unrealistic → Adjust schedule or reassign

### Step 2.4: Contact the Client

**Contact Method:** Phone call

**Purpose:**
- Confirm client availability
- Agree on appointment date and time
- Confirm address is still correct

**Information to Confirm:**
- Preferred date
- Preferred time window
- Alternative dates/times if needed

### Step 2.5: Allocate Time per Job

**Time Allocation Guidelines:**

| Job Type | Time Allocation | Notes |
|----------|----------------|-------|
| Single Item | 1 hour | Depending on item type |
| Appliances (microwave, TV, fridge, etc.) | 1 hour per item | Items may be collected and assessed at warehouse |
| Small Units Collection | 30 minutes | If entire claim is small units (laptop, cell phone) |
| Building Work | 1 hour 30 minutes | Walls, roofs, ceilings - depends on extent of damage |
| Electrical Work (CCTV, electric fence, alarms) | 1 hour 30 minutes to 2 hours | Depends on level of damage and number of items |
| Multiple Electrical Items (>2 items) | >2 hours | Allocate additional time |

**Special Cases:**

**Small Units Collection:**
- **Condition:** Entire claim consists of small units (laptop, cell phone)
- **Time:** 30 minutes
- **Requirement:** Collection form must be filled in by client and signed

**Item Collection:**
- Small units may be collected and assessed at warehouse
- Collection applies to small, portable items

### Step 2.6: Client Not Happy with Time

**If client requests different time:**

1. **Re-check Schedule**
   - Review appointment schedule
   - Check if adjustments can be made
   - Look for alternative time slots

2. **If Time Cannot Be Changed:**
   - Send email to insurance company explaining situation
   - Request insurer to appoint another service provider who can assist sooner
   - Log delay in system
   - Document reason for delay

### Step 2.7: Return Item Appointments

**Trigger:** Item needs to be returned to client (claim rejected)

**Pre-Booking Checks:**
- [ ] Re-verify address
- [ ] Re-check travel distance
- [ ] Confirm item location and condition

**Time Allocation:**
- 30 minutes for technician to return item

**Requirements:**
- Item must be returned in same condition as received
- Client must sign return letter as proof of return
- Document return in system

### Step 2.8: Finalise Booking

**Once appointment is confirmed:**

**Capture on Appointment Sheet:**
- [ ] Time allocated
- [ ] Client name
- [ ] Claim number
- [ ] Area/location

**Client Communication:**
- [ ] Send booking confirmation to client
- [ ] Include appointment date, time, and address

**System Updates:**
- [ ] Update delays (if any)
- [ ] Add notes
- [ ] Send email notification to insurance company (if required)

---

## Stage 3: Day Before Scheduled Appointments

**Role:** Scheduling Team / Managers  
**Duration:** Day before appointment  
**Outcome:** Technicians prepared with full appointment details

### Step 3.1: Sort Job Cards

**Action:**
- Sort all job cards according to booking date
- Focus on next day's appointments
- Organize by technician (if pre-assigned)

### Step 3.2: Send Technician Appointment Lists

**Timing:** Day before appointment

**Method:** Send full appointment list on work WhatsApp group

**Format:** Appointments must be sent per technician, clearly grouped

**Required Information per Appointment:**
- [ ] Time allocated
- [ ] Client name
- [ ] Client phone number
- [ ] Full address
- [ ] Google Maps pin / link
- [ ] Item(s) claimed for
- [ ] Cause of damage
- [ ] Claim number
- [ ] Insurance company

### Step 3.3: Appointment Message Format

**Standard Format Example:**

```
Simone appointments for 1 January 2026

11:00 – 12:00
Charne Shekyls
064 146 1330
6 Crocker Road, Wadeville, Germiston
Crocker Industrial Village – Unit 18
[Google Maps link]
TV – Mounted – 58" – Samsung
Electrical Breakdown
CKP123141235
King Price
```

**Formatting Rules:**
- One technician per message
- All appointments grouped together
- Do not mix technicians in same message
- Include all required fields
- Use consistent formatting

### Step 3.4: Update Manager Visibility

**Action:**
- Write all appointments on manager's board

**Purpose:**
- Check technician workloads
- Identify conflicts or gaps
- Make adjustments if urgent matters arise
- Visual overview of next day's schedule

### Step 3.5: Job Card Placement

**Action:**
- Place all job cards for next day on boardroom table

**Purpose:**
- Ensure managers have access during meetings
- Easy reference for morning briefing
- Physical backup of appointment details

---

## Stage 4: Day of the Appointment

**Role:** Managers & Technicians  
**Duration:** Morning of appointment day  
**Outcome:** Technicians briefed and dispatched with job cards

### Step 4.1: Manager Review

**Action:**
- Managers review appointments on manager's board

**Adjustments Made If:**
- Technician has urgent reassignment
- Timing needs to be changed
- Additional priorities arise
- Technician unavailable (sick, emergency)

### Step 4.2: Sort Job Cards

**Action:**
- Managers sort job cards according to:
  - Final appointment times
  - Technician allocation

**Purpose:**
- Ensure correct job cards go to correct technicians
- Maintain appointment order
- Prevent missed appointments

### Step 4.3: Morning Meeting

**Participants:** Managers, Technicians

**Process:**
1. Job cards handed out to technicians
2. Each technician briefed on:
   - Their appointments for the day
   - Locations and routes
   - Special notes or instructions
   - Priority items
   - Any changes from original schedule

**Outcome:**
- All technicians start day fully informed
- All technicians properly scheduled
- All job cards distributed
- Any issues addressed before dispatch

---

## Stage 5: Damage Report Submission (Technicians)

**Role:** Technicians  
**Duration:** Within 24 hours of appointment  
**Outcome:** Damage report and photos submitted

### Step 5.1: Complete Assessment

**During Appointment:**
- [ ] Conduct full assessment of all units
- [ ] Confirm client was seen
- [ ] Review all units claimed
- [ ] Document findings
- [ ] Take photos of damage

### Step 5.2: Submit Damage Report

**Timing:** Within 24 hours of appointment

**Method:** Use official damage report link
- **Link:** Damage Report Form

**Required:**
- [ ] All units assessed
- [ ] All damage documented
- [ ] Report submitted within 24 hours

### Step 5.3: Send Unit Photos via WhatsApp

**Timing:** After submitting damage report

**Message Format:**
1. **Client Name**
2. **Claim Number**
3. **Unit Name / Type**
4. **Photos** (send after above information)

**Photo Requirements:**
- [ ] All photos are clear
- [ ] Photos accurately represent assessed units
- [ ] All claimed items photographed
- [ ] Damage clearly visible

### Step 5.4: Verification

**Process:**
- Damage Report Department checks Google Drive for submitted reports
- If report missing or incomplete:
  - Technician contacted immediately
  - Required information requested
  - Follow-up until complete

---

## Stage 6: Damage Report Processing (Damage Report Department)

**Role:** Damage Report Department  
**Duration:** After report submission  
**Outcome:** Verified damage report, quote and invoice created

### Step 6.1: Check Google Drive

**Action:**
- Search for client's name to locate damage report
- Verify report has been submitted

**If Report Missing:**
- Contact technician immediately
- Request submission

### Step 6.2: Create Client File

**Action:**
- Create new folder with client's full name
- **Format:** First Name + Surname
- **Location:** Google Drive

### Step 6.3: Create Unit Folders

**Action:**
- Inside client folder, create separate folders for each unit
- **One folder per claimed item**
- Organize by unit type/name

### Step 6.4: Download & Save Damage Report

**Action:**
- Download submitted damage report from Google Drive
- Place damage report in corresponding unit folder
- Ensure proper file naming

### Step 6.5: Verify Information

**Verification Checklist:**
- [ ] All necessary information included in damage report
- [ ] Technician has proof (photos, notes) for everything stated
- [ ] Photos match reported damage
- [ ] All claimed items assessed
- [ ] Damage cause documented
- [ ] Client information correct

**If Information Missing or Unverified:**
- Contact technician immediately
- Request required proof
- Follow up until complete

### Step 6.6: Create Quote & Invoice

**Action:**
- Generate quote for the claim
- Generate invoice for the claim

**Special Case – Digicall Claims:**

**Process:**
1. Digicall claims processed in separate system
2. Load costing in Digicall's system
3. Invoice generated by Digicall
4. Once Digicall confirms claim handled:
   - Invoice claim in Digicall system as instructed
   - Follow Digicall-specific procedures

**Standard Claims:**
- Create quote using standard process
- Create invoice using standard process
- Submit to insurance company

---

## Stage 7: Repair Authorization Process

**Role:** Claims Processing Team  
**Duration:** After insurance approval  
**Outcome:** Repair appointment booked, stock ordered (if needed)

### Step 7.1: Repair Authorization Received

**Trigger:** Insurance approves claim and repair/replacement authorization received

**Action:**
- Process continues to next step
- Update claim status in system

### Step 7.2: Check for Excess

**Action:**
- Check whether claim has excess payable

**If Excess Exists:**
1. **Call Client**
   - Inform client repair/replacement authorization received
   - Advise client of excess amount payable
   - Explain payment requirement

2. **Document Excess**
   - Record excess amount in system
   - Generate excess invoice

### Step 7.3: Send WhatsApp Confirmation

**Message Must Include:**
- [ ] Confirmation of items authorized for repair or replacement
- [ ] Invoice for excess (if applicable)
- [ ] Excess amount payable
- [ ] Message advising Proof of Payment (POP) required

**Clear Instructions to Client:**
- Stock will only be ordered once POP is received
- Repairs can only be booked after payment and stock have been received
- Provide payment instructions
- Provide POP submission method

### Step 7.4: Await Proof of Payment

**If Excess Required:**
- [ ] Wait for POP from client
- [ ] Verify payment received
- [ ] Confirm payment in system

**Once POP Received:**
- [ ] Confirm payment
- [ ] Proceed to order required stock
- [ ] Update claim status

**If No Excess:**
- Proceed directly to stock ordering (if needed)

### Step 7.5: Stock Arrival

**When Stock Received:**
- [ ] Verify stock matches order
- [ ] Check stock condition
- [ ] Update system with stock received

**Client Notification:**
- [ ] Notify client that stock has arrived
- [ ] Inform client repair can now be booked
- [ ] Provide next steps

### Step 7.6: Book Repair

**Process:** Follow same booking procedure as assessment appointments

**Steps:**
1. **Check Technician Availability**
   - Review technician schedules
   - Identify available time slots

2. **Confirm Travel and Timing**
   - Check travel time from previous appointment
   - Check travel time to next appointment
   - Ensure realistic scheduling

3. **Contact Client**
   - Phone client to confirm availability
   - Agree on repair appointment date and time
   - Confirm address is still correct

4. **Finalize Booking**
   - Capture appointment details
   - Send confirmation to client
   - Update system
   - Notify insurance company (if required)

**Time Allocation:**
- Follow same time allocation guidelines as assessment appointments
- Consider repair complexity
- Account for parts installation time

---

## Flow Diagram Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLAIM PROCESSING FLOW                         │
└─────────────────────────────────────────────────────────────────┘

[Claim Received]
       │
       ▼
[Create Job Card] ──► [Call Client] ──► [Client Reachable?]
       │                    │                      │
       │                    │                      │
       │                    │              ┌───────┴───────┐
       │                    │              │               │
       │                    │         [Yes]           [No]
       │                    │              │               │
       │                    │              │        [WhatsApp + Follow-up]
       │                    │              │               │
       │                    │              ▼               │
       │                    │    [Verify All Details]     │
       │                    │              │               │
       │                    │              │               │
       │                    └──────────────┘               │
       │                                                    │
       ▼                                                    │
[Hand to Shae] ────────────────────────────────────────────┘
       │
       ▼
[Organise Job Cards] ──► [Check Availability] ──► [Check Travel]
       │
       ▼
[Contact Client] ──► [Allocate Time] ──► [Client Happy?]
       │                                      │
       │                              ┌──────┴──────┐
       │                              │             │
       │                            [Yes]         [No]
       │                              │             │
       │                              │      [Email Insurer]
       │                              │             │
       │                              │             │
       ▼                              ▼             ▼
[Finalise Booking] ────────────────────────────────────────┘
       │
       ▼
[Day Before] ──► [Sort Cards] ──► [Send WhatsApp] ──► [Update Board]
       │
       ▼
[Day Of] ──► [Manager Review] ──► [Sort Cards] ──► [Morning Meeting]
       │
       ▼
[Technician Dispatch] ──► [Assessment] ──► [Submit Report]
       │
       ▼
[Process Report] ──► [Verify Info] ──► [Create Quote/Invoice]
       │
       ▼
[Authorization Received] ──► [Check Excess] ──► [Excess?]
       │                                          │
       │                                  ┌──────┴──────┐
       │                                  │             │
       │                                [Yes]         [No]
       │                                  │             │
       │                            [Request POP]       │
       │                                  │             │
       │                                  ▼             │
       │                            [Await POP]         │
       │                                  │             │
       │                                  ▼             │
       └──────────────────────────────────┘             │
                                                        │
                                                        ▼
[Stock Arrival] ──► [Notify Client] ──► [Book Repair] ──► [Complete]
```

---

## Key Decision Points

### Decision Point 1: Address Doesn't Pin
- **Condition:** Address doesn't pin on Google Maps
- **Action:** Request WhatsApp pin location during call
- **Outcome:** Update address with verified location

### Decision Point 2: Travel Distance > 100 km
- **Condition:** Total travel (to and from) > 100 km
- **Action:** Request travel approval from insurer
- **Outcome:** Do not book until approval received

### Decision Point 3: Client Not Reachable
- **Condition:** Client doesn't answer phone
- **Action:** Send WhatsApp, log delay, move to follow-up
- **Outcome:** Attempt contact next working day

### Decision Point 4: Client Not Happy with Time
- **Condition:** Client requests different appointment time
- **Action:** Re-check schedule, attempt adjustment
- **Outcome:** If cannot change, email insurer, log delay

### Decision Point 5: Excess Payable
- **Condition:** Claim has excess amount
- **Action:** Call client, send invoice, request POP
- **Outcome:** Wait for POP before ordering stock

### Decision Point 6: Digicall Claim
- **Condition:** Claim is from Digicall
- **Action:** Process in Digicall system
- **Outcome:** Follow Digicall-specific procedures

---

## Time Allocations Reference

| Job Type | Time | Notes |
|----------|------|-------|
| Single Item | 1 hour | Depending on item |
| Appliances (per item) | 1 hour | May be collected for warehouse assessment |
| Small Units Collection | 30 minutes | Entire claim is small units (laptop, cell phone) |
| Building Work | 1 hour 30 minutes | Depends on extent of damage |
| Electrical Work (1-2 items) | 1 hour 30 minutes to 2 hours | Depends on damage level |
| Electrical Work (>2 items) | >2 hours | Allocate additional time |
| Return Item | 30 minutes | When claim rejected |

---

## Roles & Responsibilities

| Role | Primary Responsibilities |
|------|-------------------------|
| **Charné** | Claim intake, job card creation, client verification, address confirmation |
| **Shae** | Appointment scheduling, technician allocation, travel planning, client booking |
| **Managers** | Schedule review, adjustments, morning briefing, technician dispatch |
| **Technicians** | Assessment execution, damage report submission, photo documentation |
| **Damage Report Department** | Report verification, quote/invoice creation, file organization |
| **Claims Processing Team** | Authorization processing, excess management, stock coordination, repair booking |

---

## Critical Success Factors

1. **Complete Job Cards:** All required information captured accurately
2. **Address Verification:** All addresses must pin correctly on Google Maps
3. **Travel Approval:** >100 km travel requires insurer approval before booking
4. **24-Hour Reporting:** Damage reports must be submitted within 24 hours
5. **Photo Documentation:** Clear photos required for all assessed units
6. **Excess Payment:** POP required before stock ordering and repair booking
7. **Communication:** Clear, timely communication with clients and insurers
8. **System Updates:** All delays, notes, and status changes logged in system

---

## Escalation Paths

### Travel Distance > 100 km
- **Escalate To:** Insurer
- **Action:** Request approval
- **Blocking:** Cannot book appointment until approved

### Client Not Reachable
- **Escalate To:** Insurer (via email)
- **Action:** Log delay, notify insurer
- **Follow-up:** Next working day

### Client Unhappy with Time
- **Escalate To:** Insurer
- **Action:** Email explaining situation, request alternative provider
- **Documentation:** Log delay in system

### Missing/Incomplete Damage Report
- **Escalate To:** Technician
- **Action:** Immediate contact, request required information
- **Follow-up:** Until complete

### Excess Payment Delayed
- **Escalate To:** Client
- **Action:** Follow-up calls, reminders
- **Blocking:** Cannot order stock or book repair until POP received

---

## System Integration Points

1. **Job Card Creation:** System must capture all required fields
2. **Appointment Scheduling:** Integration with Google Sheets/appointment system
3. **WhatsApp Integration:** Automated appointment list sending
4. **Google Drive:** Damage report storage and retrieval
5. **Damage Report Form:** Online submission system
6. **Quote/Invoice System:** Generation and tracking
7. **Digicall System:** Separate processing for Digicall claims
8. **Payment Tracking:** POP verification and confirmation
9. **Stock Management:** Order tracking and arrival notifications
10. **Communication Logs:** All client and insurer communications logged

---

## Quality Checkpoints

### Job Card Quality
- [ ] All required fields completed
- [ ] Address verified and pinned
- [ ] Client details confirmed
- [ ] Travel distance checked and approved (if >100 km)

### Appointment Quality
- [ ] Time allocation appropriate for job type
- [ ] Travel time realistic
- [ ] Client confirmed availability
- [ ] All details captured in system

### Damage Report Quality
- [ ] Submitted within 24 hours
- [ ] All units assessed
- [ ] Photos clear and accurate
- [ ] All required information included

### Repair Booking Quality
- [ ] Excess paid (if applicable)
- [ ] Stock received (if needed)
- [ ] Client notified
- [ ] Appointment confirmed
- [ ] System updated

---

**Document Version:** 1.0  
**Last Updated:** [Current Date]  
**Owner:** Operations Team  
**Review Frequency:** Quarterly
