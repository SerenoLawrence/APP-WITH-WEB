# CivilWatch Laravel Backend — Development Log

**Project:** CivilWatch — Community Infrastructure & Environmental Concern Reporting System  
**Location:** Digos City, Davao del Sur  
**Stack:** Laravel 12 + Sanctum + MySQL + Blade (admin panel)  
**Flutter App:** `../civ-main/` (reference — all API shapes match the Flutter models exactly)

---

## Latest Session Changes

### Overview
Built the complete Laravel backend and admin web panel to support the CivilWatch Flutter mobile app. The existing project already had an admin-side API (email/password login for staff). This session added the full **citizen mobile API** on top without breaking anything existing.

---

### Architecture

```
Two separate user systems running side by side:

┌─────────────────────────────────────────────────┐
│  STAFF / ADMIN                                  │
│  Table: users (email + password_hash)           │
│  Guard: sanctum (web session + API token)       │
│  Routes: /api/* and /admin/* (web panel)        │
└─────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────┐
│  CITIZENS (Flutter app users)                   │
│  Table: citizens (phone + pin_hash)             │
│  Guard: auth:citizen (Sanctum token)            │
│  Routes: /api/mobile/*                          │
└─────────────────────────────────────────────────┘
```

---

### New Database Migrations

| File | Table | Description |
|------|-------|-------------|
| `2026_01_01_000001_create_citizens_table` | `citizens` | Mobile app users — phone, PIN, barangay |
| `2026_01_01_000002_create_otp_codes_table` | `otp_codes` | OTP codes with 5-min expiry |
| `2026_01_01_000003_create_government_offices_table` | `government_offices` | CEO, CENRO, CPWD, CDRRMO, CVO |
| `2026_01_01_000004_create_citizen_reports_table` | `citizen_reports` | Reports from Flutter app |
| `2026_01_01_000005_create_report_activities_table` | `report_activities` | Activity/timeline log per report |
| `2026_01_01_000006_create_citizen_notifications_table` | `citizen_notifications` | Push-style notifications per citizen |
| `2026_01_01_000007_create_announcements_table` | `announcements` | City announcements shown in the app |

---

### New Eloquent Models

| Model | Table | Key Features |
|-------|-------|--------------|
| `Citizen` | `citizens` | `HasApiTokens`, pin_hash auth, `total_reports` / `resolved_reports` accessors |
| `OtpCode` | `otp_codes` | `issue()` static — creates OTP, invalidates old ones. `findValid()` — finds unexpired unused OTP |
| `GovernmentOffice` | `government_offices` | `toApiArray()` matches Flutter `GovernmentOffice` model. `handles_list` returns array |
| `CitizenReport` | `citizen_reports` | `transitionTo()` — handles status change + activity log + notification in one call. `generateReferenceNumber()` → `CW-YEAR-XXXXX` |
| `ReportActivity` | `report_activities` | `toApiArray()` matches Flutter `ActivityEntry` model |
| `CitizenNotification` | `citizen_notifications` | `send()` static helper. `toApiArray()` matches Flutter `AppNotification` model |
| `Announcement` | `announcements` | `published()` scope. `toApiArray()` matches Flutter `Announcement` model |

---

### Report Status Flow

```
Submitted → Pending Validation → Assigned to Office → In Progress → Resolved
```

Each transition via `CitizenReport::transitionTo()` automatically:
1. Updates the `status` column
2. Creates a `ReportActivity` entry (visible in Flutter activity log)
3. Sends a `CitizenNotification` to the report owner

---

### Mobile API Routes (`/api/mobile/...`)

#### Auth (public — no token needed)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/mobile/auth/send-otp` | Generates 6-digit OTP, stores it, returns it in response |
| POST | `/api/mobile/auth/verify-otp` | Validates OTP. Returns `{ token, isNewUser }` |
| POST | `/api/mobile/auth/register` | Creates citizen account, returns token |
| GET  | `/api/mobile/announcements` | Published announcements — no login needed |

#### Protected (requires `Authorization: Bearer {token}`)
| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/mobile/auth/logout` | Revokes current token |
| GET  | `/api/mobile/auth/me` | Citizen profile + report counts |
| GET  | `/api/mobile/reports` | Citizen's own reports. `?status=` filter |
| POST | `/api/mobile/reports` | Submit new report (multipart, photo optional) |
| GET  | `/api/mobile/reports/community` | All public reports for community map |
| GET  | `/api/mobile/reports/{id}` | Single report with full activity log |
| GET  | `/api/mobile/notifications` | Notifications list + unread count |
| POST | `/api/mobile/notifications/mark-all-read` | Mark all as read |
| POST | `/api/mobile/notifications/{id}/read` | Mark one as read |

---

### Admin API Routes (`/api/admin/...`)

All require a valid staff Sanctum token.

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET  | `/api/admin/citizen-reports` | Filtered list of citizen reports |
| GET  | `/api/admin/citizen-reports/{id}` | Full report detail |
| GET  | `/api/admin/citizen-reports/summary` | Dashboard stat counts |
| GET  | `/api/admin/citizen-reports/map` | All reports with lat/lng for map |
| POST | `/api/admin/citizen-reports/{id}/validate` | Validate report → makes it public on map |
| POST | `/api/admin/citizen-reports/{id}/assign` | Assign to a government office |
| POST | `/api/admin/citizen-reports/{id}/status` | Update status with optional note |
| GET  | `/api/admin/offices` | List active offices |
| POST | `/api/admin/offices` | Create office |
| PUT  | `/api/admin/offices/{id}` | Update office |
| DELETE | `/api/admin/offices/{id}` | Deactivate office |
| GET  | `/api/admin/announcements` | List all announcements |
| POST | `/api/admin/announcements` | Create announcement |
| PUT  | `/api/admin/announcements/{id}` | Update announcement |
| DELETE | `/api/admin/announcements/{id}` | Delete announcement |

---

### Admin Web Panel Routes (`/admin/...`)

| Route | View | Description |
|-------|------|-------------|
| GET `/admin/login` | `admin.login` | Login page |
| GET `/admin/dashboard` | `admin.dashboard` | Stats + recent reports + announcements |
| GET `/admin/citizen-reports` | `admin.citizen-reports.index` | Filterable report table |
| GET `/admin/citizen-reports/{id}` | `admin.citizen-reports.show` | Full detail + actions |
| POST `/admin/citizen-reports/{id}/validate` | — | Validate + publish to map |
| POST `/admin/citizen-reports/{id}/assign` | — | Assign to office |
| POST `/admin/citizen-reports/{id}/status` | — | Update status |
| GET `/admin/map` | `admin.map` | Leaflet map with color-coded pins |
| GET `/admin/offices` | `admin.offices.index` | Add/edit/deactivate offices |
| GET `/admin/announcements` | `admin.announcements.index` | Post/edit/delete announcements |

---

### New Controllers

| Controller | Namespace | Responsibility |
|------------|-----------|----------------|
| `MobileAuthController` | `Mobile` | OTP generate, verify, register, logout, me |
| `MobileReportController` | `Mobile` | Submit, list, community, show |
| `MobileNotificationController` | `Mobile` | List, mark read, mark all read |
| `MobileAnnouncementController` | `Mobile` | Public announcements list |
| `AdminCitizenReportController` | `Admin` | API: list, show, validate, assign, status, map, summary |
| `AdminOfficeController` | `Admin` | API: CRUD for government offices |
| `AdminAnnouncementController` | `Admin` | API: CRUD for announcements |
| `AdminWebController` | `Admin` | Web panel: auth, dashboard, all report/office/announcement actions |

---

### Blade Views Created

```
resources/views/admin/
├── layout.blade.php              — Sidebar + topbar shell
├── login.blade.php               — Admin login page
├── dashboard.blade.php           — Stats grid + recent reports + announcements
├── map.blade.php                 — Leaflet JS map (OpenStreetMap tiles)
├── citizen-reports/
│   ├── index.blade.php           — Filterable paginated table
│   └── show.blade.php            — Full detail + validate/assign/status actions + timeline
├── offices/
│   ├── index.blade.php           — Table + create/edit modals
│   └── _form.blade.php           — Shared form partial
├── announcements/
│   ├── index.blade.php           — Table + create/edit modals
│   └── _form.blade.php           — Shared form partial
└── partials/
    └── status-badge.blade.php    — Reusable colored status badge
```

---

### Config Changes

**`config/auth.php`**
- Added `citizen` guard (driver: `sanctum`, provider: `citizens`)
- Added `citizens` provider (model: `Citizen`)

**`config/services.php`**
- No third-party SMS config (Semaphore removed — see below)

**`app/Providers/AppServiceProvider.php`**
- Registers `Sanctum::usePersonalAccessTokenModel()` to support multi-guard tokens

---

### Seeders

| Seeder | What it creates |
|--------|----------------|
| `GovernmentOfficeSeeder` | CEO, CENRO, CPWD, CDRRMO, CVO with real Digos City details |
| `AnnouncementSeeder` | 2 sample announcements |
| `DatabaseSeeder` | Super admin account + calls both seeders above |

Default admin credentials (change after first login):
```
Email:    admin@civilwatch.ph
Password: Admin@2026!
```

---

### OTP Strategy

Semaphore SMS was removed. OTP now works like this:

1. `POST /api/mobile/auth/send-otp` — generates a random 6-digit code, stores it in `otp_codes` with a 5-minute expiry
2. The code is **returned in the response** for now — useful for development and testing
3. When you're ready to add real SMS, find the `TODO` comment in `MobileAuthController::sendOtp()` and plug in your provider there
4. The OTP verification, expiry, and invalidation logic is already complete and will work with any SMS provider

---

### Run Commands

```bash
# From prc/laravel/

php artisan migrate
php artisan db:seed
php artisan storage:link     # required for photo uploads to work
php artisan serve
```

Web panel: `http://localhost:8000/admin/login`  
API base:  `http://localhost:8000/api/mobile/`

---

### Flutter API Field Mapping

All API response shapes were built to match the Flutter models exactly:

| Flutter Model | Laravel Source | Key fields |
|---------------|---------------|------------|
| `AppUser` | `Citizen` | `id`, `fullName`, `phoneNumber`, `barangay`, `joinedDate`, `totalReports`, `resolvedReports` |
| `IncidentReport` | `CitizenReport` | `id`, `referenceNumber`, `category`, `issue`, `description`, `barangay`, `status`, `severity`, `submittedAt`, `resolvedAt`, `imageUrl`, `latitude`, `longitude`, `assignedOffice`, `activityLog` |
| `ActivityEntry` | `ReportActivity` | `title`, `description`, `timestamp`, `status` |
| `AppNotification` | `CitizenNotification` | `id`, `title`, `message`, `referenceNumber`, `status`, `timestamp`, `isRead` |
| `Announcement` | `Announcement` | `id`, `title`, `body`, `date` |
| `GovernmentOffice` | `GovernmentOffice` | `id`, `name`, `abbreviation`, `handles` (array), `contactNumber`, `email`, `address` |

---

### Reference Number Format

```
CW-{YEAR}-{5-digit-padded-sequence}
Example: CW-2026-00125
```

Generated by `CitizenReport::generateReferenceNumber()` — counts reports for the current year and zero-pads to 5 digits.

---

### 22 Barangays (Digos City, Davao del Sur)

Aplaya, Badiang, Balabag, Binaton, Cogon, Colorado, Dawis, Dulangan, Goma, Igpit, Kapatagan, Kiagdan, Matti, New Visayas, Rizal, San Jose, San Miguel, Soong, Tres de Mayo, Zone 1, Zone 2, Zone 3
