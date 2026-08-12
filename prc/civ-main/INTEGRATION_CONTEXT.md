# CIVILWATCH — Citizen App Integration Context
> **For:** Kiro (Admin / Super Admin System)
> **From:** Kiro (Citizen Mobile App)
> **Project:** CIVILWATCH — Digos City
> **Purpose:** Complete technical context of the citizen app so both systems
> can be integrated into the same Supabase backend.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Authentication & Registration](#2-authentication--registration)
3. [All Screens](#3-all-screens)
4. [Report Submission](#4-report-submission)
5. [Report Tracking](#5-report-tracking)
6. [Notifications](#6-notifications)
7. [Design & UI](#7-design--ui)
8. [Integration Points & Field Mapping](#8-integration-points--field-mapping)
9. [Schema Changes Needed](#9-schema-changes-needed)
10. [Critical Mismatches to Resolve](#10-critical-mismatches-to-resolve)
11. [Not Yet Built — Planned Features](#11-not-yet-built--planned-features)
12. [Project Path & Structure](#12-project-path--structure)

---

## 1. Overview

### 1.1 App Name & Branding
Same branding as the admin system: **CIVILWATCH**.
Full description: *"A Geotagged Community Infrastructure and Environmental Incident
Reporting, Management, and Monitoring System for Digos City."*
No separate citizen sub-brand — it is just CIVILWATCH.

### 1.2 Tech Stack

| Layer | Technology |
|---|---|
| Framework | **Flutter** (Dart) — SDK `^3.12.2` |
| Platform | **Mobile app** (Android & iOS) — not web-based |
| State management | Singleton `ChangeNotifier` — no Bloc/Riverpod/Provider |
| Maps | `flutter_map ^8.1.1` + `latlong2 ^0.9.1` (OpenStreetMap tiles) |
| HTTP | `http ^1.2.2` — used only for Nominatim reverse geocoding |
| Fonts | `google_fonts ^6.2.1` — Inter + Roboto Mono |
| Date formatting | `intl ^0.19.0` |
| Backend | **None** — 100% prototype, all data in-memory |

### 1.3 Current Backend Status
**Zero backend connection.** No Supabase client, no API keys, no `.env` file.
The only real HTTP call is to `nominatim.openstreetmap.org` for reverse geocoding.
Everything else is fake data in `DummyData` and `AppState` (resets on restart).

---

## 2. Authentication & Registration

### 2.1 Registration — Fields Collected

| Field | Required | Validation |
|---|---|---|
| Mobile number | Yes | `+63` prefix, 10 digits, must start with `9` |
| Full name | Yes | First and last name both required |
| Email address | No (optional) | Validates format only if filled |
| Home Barangay | Yes | Dropdown — 22 hardcoded Digos City barangays |
| 6-digit PIN | Yes | Numeric, obscured, create + confirm must match |
| Terms & Privacy checkbox | Yes | Must be ticked to submit |

### 2.2 Login Method
Phone number → OTP (6-digit, simulated) → Home or Register.

- **New user path:** Phone → OTP → `/register` → `/home`
- **Existing user path:** Phone → OTP → `/home` directly

The 6-digit PIN is collected at registration but is **not verified on subsequent
logins** in the prototype — this is a gap that needs to be filled during integration.

### 2.3 OTP Details
- OTP is completely simulated (`Future.delayed`) — no real SMS is sent
- 60-second countdown resend timer
- `isNewUser: true/false` flag passed as argument to decide post-verify route

### 2.4 Guest / Anonymous Mode
**None.** Login is required before any screen beyond OTP is accessible.
No report can be submitted without authenticating.

### 2.5 Current Auth System
**Fake / local only.** No `supabase_flutter` in `pubspec.yaml`.
No tokens, no sessions, no persistence across restarts.

### 2.6 Citizen User Data Model (`AppUser`)

```dart
String id           // 'u-001' (fake local ID)
String fullName     // 'Lawrence Santos'
String phoneNumber  // '+63 912 345 6789'
String barangay     // 'Aplaya' (home barangay)
DateTime joinedDate
int totalReports
int resolvedReports
String? avatarUrl   // null — not implemented yet
```

> **Note:** Email is collected on the register screen but is **not saved**
> to `AppUser` — it only lives in the text controller and is discarded.
> This must be persisted when integrating with Supabase.

---
## 3. All Screens

### 3.1 Complete Screen Inventory

| Screen | File | What user does | Data shown / collected |
|---|---|---|---|
| Splash | `splash/splash_screen.dart` | Wait for animation | Logo, tagline, city name |
| Login | `auth/login_screen.dart` | Enter phone, tap Send OTP | Phone number |
| OTP | `auth/otp_screen.dart` | Enter 6-digit code, verify | Phone display, 60s resend timer |
| Register | `auth/register_screen.dart` | Fill form, create PIN | Full name, email (opt), barangay, PIN×2, terms |
| Home | `home/home_screen.dart` | Navigation hub | Greeting, CTA banner, 4 stat tiles, mini map, announcements |
| Report Category | `report/report_category.dart` | Choose category | Infrastructure or Environment |
| Report Concern | `report/report_concern.dart` | Choose concern type | One of 7 concern types (see Section 4) |
| Report Photo | `report/report_photo.dart` | Take or choose photo | `hasPhoto` boolean (simulated) |
| Report Location | `report/report_location.dart` | GPS or map tap, fill details | lat, lng, address, purok, barangay, city, province, landmark, details, severity |
| Report Review | `report/report_review.dart` | Read summary, confirm, submit | Confirmation checkbox |
| Report Submitted | `report/report_submitted.dart` | Copy ref number, navigate | Reference number, submitted timestamp |
| My Reports | `my_reports/my_reports_screen.dart` | Search, filter, tap report | Own reports list with status |
| Track Report | `track_report/track_report_screen.dart` | View detail, advance status (demo) | Full report + activity log |
| Status Update | `track_report/status_update_screen.dart` | View status history | Status timeline detail |
| Private Map | `map_preview/private_map_screen.dart` | View own report on map | OpenStreetMap centred on report coords |
| Community Map | `community_map/community_map_screen.dart` | Browse validated reports | All validated community pins |
| Notifications | `notifications/notification_screen.dart` | Read, mark read | Grouped notification list |
| Profile | `profile/profile_screen.dart` | View stats, menu, log out | User info, activity stats |

### 3.2 Landing Page Before Login
No dedicated landing/marketing page. Splash → Login immediately.

### 3.3 Bottom Navigation (5 tabs)
- **Home** — house icon
- **My Reports** — document icon
- **[FAB centre]** — location pin — launches Report Concern flow directly
- **Notifications** — bell icon with unread badge
- **Profile** — person icon

---

## 4. Report Submission

### 4.1 Current Concern Types (Final — as of latest update)

**Infrastructure (CEO):**

| Label | Icon | Hint |
|---|---|---|
| Road Repair | `add_road_rounded` | Potholes, damaged road surface needing repair |
| Road Graveling | `terrain_rounded` | Unpaved or gravel road needs improvement |
| Streetlight / Light Pole Concern | `light_rounded` | Broken, flickering, or missing streetlight |
| Blocked Canal | `water_damage_rounded` | Canal blocked by debris or sediment |
| Others | `more_horiz_rounded` | Other infrastructure concerns not listed above |

**Environmental (CENRO):**

| Label | Icon | Hint |
|---|---|---|
| Illegal Dumping | `delete_sweep_rounded` | Waste illegally dumped in public areas |
| Garbage Collection | `recycling_rounded` | Missed or irregular garbage collection schedule |

### 4.2 All Fields Collected During Submission

| Field | Map key | Required | Notes |
|---|---|---|---|
| Category | `category` | Yes | `'Infrastructure'` or `'Environment'` |
| Concern type | `concern` + `issue` | Yes | One of the 7 values above |
| Photo flag | `hasPhoto` | Yes | `true`/`false` — no real file yet |
| Latitude | `latitude` | Yes | `double` from GPS or map tap |
| Longitude | `longitude` | Yes | `double` from GPS or map tap |
| Street / Area | `address` | Auto-filled | From Nominatim reverse geocoding |
| Purok | `purok` | Optional | From Nominatim — editable |
| Barangay | `barangay` | Yes | From Nominatim — editable |
| City | `city` | Yes | Default `'Digos City'` |
| Province | `province` | Yes | Default `'Davao del Sur'` |
| Landmark | `landmark` | Optional | Free text, e.g. "Near Barangay Hall" |
| Additional details | `additionalDetails` + `description` | Optional | Max 300 characters |
| Severity | `severity` | Yes | `'Low'`, `'Medium'`, or `'High'` |
| Reference number | `referenceNumber` | Auto | Generated at submit: `CW-YYYY-#####` |
| Submitted at | `submittedAt` | Auto | `DateTime.now().toIso8601String()` |

### 4.3 Location Selection — Two Methods
1. **Use Current Location** — simulated GPS at `6.7498, 125.3572` (Digos City centre).
   In production requires `geolocator` package (not yet installed).
2. **Pick on Map** — inline `flutter_map`, tap anywhere to drop a red pin.
   Nominatim auto-fills address fields. All fields are editable if geocoding fails.

### 4.4 Photo Upload — Current Status
**Simulated only.** `hasPhoto` is a boolean flag — no real `File`, no bytes, no URL.
`image_picker` is **not** in `pubspec.yaml`.
The `photo_url` column in `reports` will always be `null` until this is built.

### 4.5 After Submitting
1. 1.5-second simulated loading spinner
2. Reference number generated client-side: `CW-{year}-{ms % 100000}`
3. Report saved to in-memory `AppState`
4. Two auto-notifications added: "Concern Submitted" + "Pending Validation"
5. Navigated to Submitted screen — shows ref number (copyable) + timestamp

### 4.6 Exact Data Object Created on Submit

```dart
IncidentReport(
  id:              'r-${DateTime.now().millisecondsSinceEpoch}',
  referenceNumber: 'CW-2026-#####',
  category:        'Infrastructure' | 'Environment',
  issue:           concern_string,        // → admin reports.issue
  description:     additionalDetails,     // → admin reports.description
  barangay:        barangay_string,       // → admin reports.barangay
  status:          'Pending Validation',  // → admin reports.status
  severity:        'Low'|'Medium'|'High', // → admin reports.priority
  submittedAt:     DateTime.now(),        // → admin reports.submitted_at
  imageUrl:        null,                  // → admin reports.photo_url (always null now)
  latitude:        double,               // → admin reports.lat
  longitude:       double,               // → admin reports.lng
  assignedOffice:  null,                 // set by admin, not citizen
)
```

**Fields collected but missing from `IncidentReport` model** (need adding):
- `address` (street/area text)
- `purok`
- `city`
- `province`
- `landmark`
- `submittedByName` (citizen full name)
- `submittedByPhone` (citizen phone number)

---

## 5. Report Tracking

### 5.1 Can Citizens Track Reports?
Yes — authenticated citizens can view all their submitted reports.

### 5.2 How They Find a Report
By logging in → My Reports list → tap any card.
There is **no anonymous lookup by reference number** outside the logged-in session.

### 5.3 Information Shown When Viewing a Report

| Data | Shown | Source when live |
|---|---|---|
| Reference number | ✅ | `reports.reference_no` |
| Category chip (colour-coded) | ✅ | `reports.category` |
| Concern type | ✅ | `reports.issue` |
| Severity chip (colour-coded) | ✅ | `reports.priority` |
| Current status badge | ✅ | `reports.status` |
| 5-step visual progress timeline | ✅ | Derived from `reports.status` |
| Activity log with timestamps | ✅ | `activity_log` table |
| Assigned government office | ✅ | `offices` table via FK |
| Report location / barangay | ✅ | `reports.barangay` |
| View on Map button | ✅ | `reports.lat` + `reports.lng` |
| Before photo | ⚠️ placeholder | `reports.photo_url` |
| After photo (resolved) | ❌ not built | `reports.after_photo_url` |
| Resolution notes | ❌ not built | `reports.resolution_note` |
| Rejection note | ❌ not built | `reports.rejection_note` |

### 5.4 My Reports Page — Card Info Shown
- Reference number
- Category badge + concern type
- Barangay
- Status chip (colour-coded)
- Severity chip
- Submitted date

Filter tabs: **All · Pending · In Progress · Resolved**
Full text search across reference number and concern type.

### 5.5 Report Status Flow (Citizen App Side)

```
Submitted → Pending Validation → Assigned to Office → In Progress → Resolved
```

The citizen app also has a **demo "Advance Status" button** in Track Report
that cycles through statuses locally — this is only for prototype testing
and must be removed before live integration.

---

## 6. Notifications

### 6.1 Notification System
**In-app only.** No push notifications (FCM), no SMS, no email.
Notifications are stored in `AppState` in memory.

### 6.2 Events That Trigger Notifications

| Event | Notification title | Generated by |
|---|---|---|
| Report submitted | "Concern Submitted" | Citizen app — auto on submit |
| Status → Pending Validation | "Pending Validation" | Citizen app — auto on submit |
| Any status change | Status name as title | Citizen app demo button (local only) |

In the real integration, all notifications after submission must come from
**Supabase Realtime** subscriptions listening to `reports.status` changes
made by the admin system.

### 6.3 Notification Data Model

```dart
AppNotification(
  id:              String,
  title:           String,   // status name or 'Concern Submitted'
  message:         String,   // human-readable description
  referenceNumber: String,   // e.g. 'CW-2026-00125'
  status:          String,   // status that triggered it
  timestamp:       DateTime,
  isRead:          bool,
)
```

Maps to admin `notifications` table. The `target_role` and `read_by` columns
in the admin schema are not used by the citizen app — citizen notifications
are citizen-specific and need a separate `citizen_notifications` table or
a `recipient_citizen_id` column added to the existing table.

---

## 7. Design & UI

### 7.1 Colour Palette

| Token | Hex | Usage |
|---|---|---|
| `primary` | `#1B5E20` | Deep green — buttons, active states, success |
| `navy` | `#0D2137` | Dark navy — app bar, CTA banner, headings |
| `background` | `#F8FAFC` | All screen backgrounds |
| `white` | `#FFFFFF` | Cards, inputs, bottom bars |
| `infrastructure` | `#F59E0B` | Amber — Infrastructure category |
| `environment` | `#16A34A` | Green — Environment category |
| `statusPending` | `#F59E0B` | Amber — Pending Validation |
| `statusInProgress` | `#EA580C` | Orange — In Progress |
| `statusResolved` | `#16A34A` | Green — Resolved |
| `statusAssigned` | `#2563EB` | Blue — Assigned to Office |
| `severityLow` | `#16A34A` | Green chip |
| `severityMedium` | `#F59E0B` | Orange chip |
| `severityHigh` | `#DC2626` | Red chip |

### 7.2 Typography
- **Inter** (Google Fonts) — all UI text, weights 400–900
- **Roboto Mono** (Google Fonts) — reference numbers only

### 7.3 Platform
Mobile-first exclusively. Designed for ~390px wide screens (standard Android/iPhone).
Not a web app — no CSS, no HTML. Pure Flutter widget tree.

### 7.4 Icons
Flutter Material Icons (`Icons.*` class). No FontAwesome, no SVGs, no external packs.

### 7.5 Map Library
`flutter_map ^8.1.1` with OpenStreetMap tile layer.
URL: `https://tile.openstreetmap.org/{z}/{x}/{y}.png`
Same geographic data as Leaflet.js — different rendering library but compatible coordinates.

### 7.6 Key Design Conventions
| Property | Value |
|---|---|
| Card border radius | 16–20px |
| Button height | 52–54px |
| Button border radius | 16px |
| Input border radius | 12–14px |
| Animations | `AnimatedContainer` 200ms, page slide 350ms, fade 300ms |

---

## 8. Integration Points & Field Mapping

### 8.1 Citizen App → Admin DB Column Mapping

| Citizen app key | Admin `reports` column | Type | Notes |
|---|---|---|---|
| `referenceNumber` | `reference_no` | `text` | Regenerate server-side — client generation is not collision-safe |
| `category` | `category` | `text` | See mismatch note in Section 10 |
| `concern` / `issue` | `issue` | `text` | One of the 7 concern labels |
| `additionalDetails` / `description` | `description` | `text` | Optional, max 300 chars |
| `barangay` | `barangay` | `text` | String name e.g. `'Aplaya'` |
| `severity` | `priority` | `text` | Citizen: Low/Medium/High — your column: `priority` |
| `latitude` | `lat` | `numeric` | `double` |
| `longitude` | `lng` | `numeric` | `double` |
| `status` (always `'Pending Validation'` on submit) | `status` | `text` | Matches admin value ✓ |
| `imageUrl` (always `null` now) | `photo_url` | `text` | Null until photo upload built |
| `submittedAt` | `submitted_at` | `timestamptz` | ISO 8601 string → timestamptz |
| citizen full name (from auth session) | `submitted_by` | `text` | Not yet passed through the report flow |
| citizen phone (from auth session) | `phone` | `text` | Not yet passed through the report flow |
| `address` | **missing column** | `text` | See Section 9 |
| `purok` | **missing column** | `text` | See Section 9 |
| `city` | **missing column** | `text` | See Section 9 |
| `province` | **missing column** | `text` | See Section 9 |
| `landmark` | **missing column** | `text` | See Section 9 |

### 8.2 Data the Citizen App Needs to READ from Admin System

| Data | Currently | After Integration |
|---|---|---|
| Barangay list (dropdown) | 22 hardcoded strings | Query `barangays` table |
| Report status | Local in-memory | Subscribe `reports` via Supabase Realtime |
| Activity log | Fake local entries | Read `activity_log` table |
| Assigned office name | Fake local offices | Read `offices` table via `assigned_office` FK |
| Resolution notes | Not built | Read `reports.resolution_note` |
| After photo | Not built | Read `reports.after_photo_url` |
| Rejection note | Not built | Read `reports.rejection_note` |
| Announcements | Hardcoded in `DummyData` | New `announcements` table (see Section 9) |

### 8.3 Auth Separation Strategy

Admin accounts and citizen accounts must live in **separate tables** even though
both use `auth.users`. Recommended approach:

```
auth.users
  ├── profiles table  → admin users (superadmin, ceo, cenro roles)  [already exists]
  └── citizens table  → citizen users (new table needed)             [see Section 9]
```

The citizen app will use `supabase_flutter` with Phone OTP auth
(`supabase.auth.signInWithOtp(phone: ...)`).
Admin system uses email+password auth.
They share the same `auth.users` but query different profile tables — no conflict,
as long as RLS policies check `profiles` vs `citizens` appropriately.

---

## 9. Schema Changes Needed

These are additions required in the **admin Supabase project** before
the citizen app can be integrated.

### 9.1 New `citizens` Table

```sql
create table public.citizens (
  id          uuid primary key references auth.users(id) on delete cascade,
  full_name   text not null,
  phone       text not null unique,
  email       text,
  barangay    text not null,
  pin_hash    text not null,       -- bcrypt hash of the 6-digit PIN
  avatar_url  text,
  created_at  timestamptz not null default now(),
  updated_at  timestamptz not null default now()
);

-- RLS: citizens can only read/update their own row
alter table public.citizens enable row level security;

create policy "Citizens: own row only"
  on public.citizens
  using (auth.uid() = id);
```

### 9.2 New Columns on `reports` Table

```sql
alter table public.reports
  add column if not exists address       text,
  add column if not exists purok         text,
  add column if not exists city          text default 'Digos City',
  add column if not exists province      text default 'Davao del Sur',
  add column if not exists landmark      text,
  add column if not exists citizen_id    uuid references public.citizens(id);
```

> `citizen_id` links a report to its submitting citizen — needed so the
> citizen app can query `reports where citizen_id = auth.uid()` for My Reports.

### 9.3 New `citizen_notifications` Table
The existing admin `notifications` table uses `target_role` and `read_by[]`
for admin-to-admin messages — not suitable for citizen notifications.

```sql
create table public.citizen_notifications (
  id               uuid primary key default gen_random_uuid(),
  citizen_id       uuid not null references public.citizens(id) on delete cascade,
  report_id        uuid references public.reports(id) on delete cascade,
  reference_no     text not null,
  title            text not null,
  message          text not null,
  status           text not null,
  is_read          boolean not null default false,
  created_at       timestamptz not null default now()
);

alter table public.citizen_notifications enable row level security;

create policy "Citizens: own notifications only"
  on public.citizen_notifications
  using (auth.uid() = citizen_id);
```

### 9.4 Optional: `announcements` Table
Currently hardcoded in the citizen app. If admin needs to push announcements:

```sql
create table public.announcements (
  id         uuid primary key default gen_random_uuid(),
  title      text not null,
  body       text not null,
  created_at timestamptz not null default now()
);
```

### 9.5 RLS Policy for `reports` — Citizen Access

```sql
-- Citizens can INSERT their own reports
create policy "Citizens: insert own reports"
  on public.reports for insert
  with check (auth.uid() = citizen_id);

-- Citizens can SELECT only their own reports
create policy "Citizens: select own reports"
  on public.reports for select
  using (auth.uid() = citizen_id);

-- Citizens cannot UPDATE or DELETE reports
-- (only admins can update status, assigned_office, etc.)
```

---

## 10. Critical Mismatches to Resolve

These **must be agreed on and fixed** before any data flows between
the two systems. One side needs to change to match the other.

### 10.1 Category Spelling

| Citizen app | Admin DB | Action needed |
|---|---|---|
| `'Environment'` | `'Environmental'` (likely) | **Align both to the same string.** Recommend `'Environment'` (shorter, consistent with infrastructure naming). Update admin DB constraint and any admin-side filters. |

### 10.2 Severity vs Priority Column Name

| Citizen app field name | Admin DB column | Values | Action needed |
|---|---|---|---|
| `severity` | `priority` | Both use Low / Medium / High | **Pick one name.** Recommend keeping `priority` on the DB side (already exists). Update citizen app to write to `priority` — a 1-line change. |

### 10.3 Status: "Assigned to Office" vs "Assigned"

| Citizen app | Admin DB | Action needed |
|---|---|---|
| `'Assigned to Office'` (used in 6+ places) | `'Assigned'` | **Align to `'Assigned to Office'`** — the citizen app has this string deeply embedded in the timeline widget, activity log, and status helpers. It is easier to update one DB constraint than 6+ Flutter files. |

### 10.4 Reference Number Generation

| Citizen app | Admin DB | Action needed |
|---|---|---|
| Generated client-side: `CW-{year}-{ms % 100000}` | Generated server-side (presumed) | **Always generate server-side.** Add a Supabase trigger or sequence. The citizen app should use the `reference_no` returned by the INSERT response, not pre-generate it. |

### 10.5 `submitted_by` / `phone` Not Yet Wired

The citizen app collects the user's name and phone during registration
but does **not** pass them through the 5-step report flow to the final
submission object. After Supabase auth is integrated, these should be
read from the authenticated citizen's profile and added automatically
on INSERT — the citizen should not need to re-enter them.

---

## 11. Not Yet Built — Planned Features

These features have UI placeholders or are known gaps. The DB schema
should account for them now to avoid migrations later.

| Feature | Status | DB column exists? |
|---|---|---|
| Real photo capture (`image_picker`) | ❌ Not built | `photo_url` ✓ |
| Real GPS (`geolocator` + `permission_handler`) | ❌ Not built | `lat` / `lng` ✓ |
| After photo display for resolved reports | ❌ Not built | `after_photo_url` ✓ |
| Resolution notes visible to citizen | ❌ Not built | `resolution_note` ✓ |
| Rejection screen + note visible to citizen | ❌ Not built | `rejection_note` ✓ |
| PIN verification on login (not just registration) | ❌ Not built | `citizens.pin_hash` needed |
| Push notifications via FCM | ❌ Not built | Add `fcm_token text` to `citizens` |
| Change PIN screen (menu item exists, screen missing) | ❌ Not built | `citizens.pin_hash` needed |
| Supabase Realtime status updates in citizen app | ❌ Not built | `reports` table + Realtime enabled |
| Announcements from admin → citizen app | ⚠️ Hardcoded | `announcements` table (see Section 9.4) |
| Community Map from live validated reports | ⚠️ Fake data | `reports where status != 'Pending Validation'` |
| Anonymous report lookup by reference number | ❌ Not built | No schema change needed |

---
