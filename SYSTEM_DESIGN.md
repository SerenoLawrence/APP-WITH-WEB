# CIVILWATCH — System Design Document
> Geotagged Community Incident Reporting System | Digos City
> University of Mindanao — Digos Branch | BS Information Technology | 2026
> Proponents: Renz Justine Y. Borinaga, Jhon Carlo Mag-Usara, Lawrence Roy P. Sereno
> Adviser: Cyvil Dave Dasargo, MIT
> Last Updated: August 13, 2026

---

## Table of Contents

1. [System Architecture Design](#1-system-architecture-design)
2. [Entity Relationship Diagram (ERD)](#2-entity-relationship-diagram-erd)
3. [Data Flow Diagram (DFD)](#3-data-flow-diagram-dfd)
   - [Level 0 — Context Diagram](#level-0--context-diagram)
   - [Level 1 — System DFD](#level-1--system-dfd)
   - [Level 2 — Report Submission Sub-process](#level-2--report-submission-sub-process)
   - [Level 2 — Report Management Sub-process](#level-2--report-management-sub-process)
4. [Use Case Diagram](#4-use-case-diagram)
5. [Report Status State Diagram](#5-report-status-state-diagram)
6. [Report Categories](#6-report-categories)
7. [Technology Stack](#7-technology-stack)

---

## 1. System Architecture Design

CIVILWATCH follows a **3-Tier Client-Server Architecture** with two separate client surfaces (web admin + mobile app) sharing one Laravel backend.

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         PRESENTATION TIER                                │
│                                                                          │
│  ┌───────────────────────┐          ┌───────────────────────────────┐   │
│  │   Admin Web Portal    │          │   Citizen Mobile App          │   │
│  │   HTML5 + CSS3 + JS   │          │   Flutter / Dart              │   │
│  │                       │          │                               │   │
│  │  Super Admin (11 pg)  │          │  Android & iOS                │   │
│  │  CEO Portal   (8 pg)  │          │  18 screens                   │   │
│  │  CENRO Portal (8 pg)  │          │  flutter_map + OpenStreetMap  │   │
│  │                       │          │  Nominatim reverse geocoding  │   │
│  │  Leaflet.js maps       │          │  6-digit PIN authentication   │   │
│  │  Chart.js analytics    │          │  Report submission wizard     │   │
│  └──────────┬────────────┘          └───────────────┬───────────────┘   │
└─────────────┼──────────────────────────────────────┼────────────────────┘
              │  HTTPS / REST API                     │  HTTPS / REST API
              │  /api/* and /api/admin/*              │  /api/mobile/*
              │  (Sanctum — staff token)              │  (Sanctum — citizen token)
              └───────────────────┬───────────────────┘
                                  │
┌─────────────────────────────────┼────────────────────────────────────────┐
│                        APPLICATION TIER                                  │
│                                 │                                        │
│              ┌──────────────────▼──────────────────┐                    │
│              │         Laravel 12 Backend           │                    │
│              │         PHP + Sanctum                │                    │
│              │                                      │                    │
│              │  ┌──────────────────────────────┐   │                    │
│              │  │  Middleware Layer             │   │                    │
│              │  │  • auth:sanctum (admin)       │   │                    │
│              │  │  • auth:citizen (mobile)      │   │                    │
│              │  │  • CORS                       │   │                    │
│              │  └──────────────────────────────┘   │                    │
│              │                                      │                    │
│              │  ┌──────────────────────────────┐   │                    │
│              │  │  Route Groups                 │   │                    │
│              │  │  • /api/mobile/*  (citizens)  │   │                    │
│              │  │  • /api/admin/*   (staff)     │   │                    │
│              │  │  • /api/*         (legacy)    │   │                    │
│              │  │  • /admin/*       (Blade web) │   │                    │
│              │  └──────────────────────────────┘   │                    │
│              │                                      │                    │
│              │  ┌──────────────────────────────┐   │                    │
│              │  │  Controllers                  │   │                    │
│              │  │  Mobile: Auth, Report,        │   │                    │
│              │  │          Notification,        │   │                    │
│              │  │          Announcement         │   │                    │
│              │  │  Admin:  CitizenReport,       │   │                    │
│              │  │          Office,              │   │                    │
│              │  │          Announcement, Web    │   │                    │
│              │  │  Legacy: Auth, Report,        │   │                    │
│              │  │          Analytics, Users,    │   │                    │
│              │  │          Notifications        │   │                    │
│              │  └──────────────────────────────┘   │                    │
│              └──────────────────┬───────────────────┘                    │
└─────────────────────────────────┼────────────────────────────────────────┘
                                  │  Eloquent ORM
┌─────────────────────────────────┼────────────────────────────────────────┐
│                           DATA TIER                                      │
│                                 │                                        │
│         ┌───────────────────────▼──────────────────────┐                │
│         │               MySQL Database                  │                │
│         │               (Eloquent ORM)                  │                │
│         │                                               │                │
│         │  users                  — Admin staff         │                │
│         │  citizens               — Mobile app users    │                │
│         │  otp_codes              — OTP verification    │                │
│         │  government_offices     — CEO, CENRO, etc.    │                │
│         │  citizen_reports        — Reports from app    │                │
│         │  report_activities      — Status change log   │                │
│         │  citizen_notifications  — Per-citizen alerts  │                │
│         │  announcements          — City announcements  │                │
│         └───────────────────────────────────────────────┘                │
│                                                                          │
│         ┌───────────────────────────────────────────────┐                │
│         │  Laravel Storage (local disk / future S3)     │                │
│         │  • Before photos (citizen-submitted)          │                │
│         │  • After photos  (office-uploaded)            │                │
│         │  • Accessible via /storage/... public URL     │                │
│         └───────────────────────────────────────────────┘                │
└──────────────────────────────────────────────────────────────────────────┘
```

### Two Separate Auth Guards (Side by Side)

```
┌──────────────────────────────────────┐
│  STAFF / ADMIN                       │
│  Table: users                        │
│  Fields: email + password_hash       │
│  Guard:  auth:sanctum                │
│  Routes: /api/* and /admin/*         │
│  Login:  POST /api/login             │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│  CITIZENS (Flutter app users)        │
│  Table: citizens                     │
│  Fields: phone + pin_hash            │
│  Guard:  auth:citizen                │
│  Routes: /api/mobile/*               │
│  Login:  POST /api/mobile/auth/      │
│          send-otp → verify-otp       │
└──────────────────────────────────────┘
```

---

## 2. Entity Relationship Diagram (ERD)

> Notation: PK = Primary Key | FK = Foreign Key | UQ = Unique | NN = Not Null

```
┌──────────────────────────────────┐
│             USERS                │
├──────────────────────────────────┤
│ PK  id              BIGINT       │
│     name            VARCHAR(100) │
│ UQ  email           VARCHAR(100) │
│     password_hash   VARCHAR(255) │
│     role  ENUM(super_admin,      │
│                ceo, cenro)       │
│     office          VARCHAR(50)  │
│     is_active       BOOLEAN      │
│     created_at      TIMESTAMP    │
│     updated_at      TIMESTAMP    │
└────────────┬─────────────────────┘
             │ 1 (performs admin actions)
             │ N
             ▼
┌──────────────────────────────────┐
│           CITIZENS               │
├──────────────────────────────────┤
│ PK  id              BIGINT       │
│     full_name       VARCHAR(100) │
│ UQ  phone           VARCHAR(20)  │
│     email           VARCHAR(100) │
│     barangay        VARCHAR(100) │
│     pin_hash        VARCHAR(255) │
│     avatar_url      TEXT         │
│     created_at      TIMESTAMP    │
│     updated_at      TIMESTAMP    │
└────────────┬─────────────────────┘
             │ 1
             │ submits
             │ N
             ▼
┌──────────────────────────────────┐     ┌────────────────────────────────┐
│         CITIZEN_REPORTS          │     │       GOVERNMENT_OFFICES       │
├──────────────────────────────────┤     ├────────────────────────────────┤
│ PK  id              BIGINT       │     │ PK  id           BIGINT        │
│ UQ  reference_no    VARCHAR(20)  │     │     name         VARCHAR(100)  │
│     category        VARCHAR(50)  │     │     abbreviation VARCHAR(20)   │
│     issue           VARCHAR(100) │     │     handles_list JSON          │
│     description     TEXT         │     │     contact_number VARCHAR(20) │
│     address         TEXT         │     │     email        VARCHAR(100)  │
│     purok           VARCHAR(50)  │     │     address      TEXT          │
│     barangay        VARCHAR(100) │     │     is_active     BOOLEAN      │
│     city            VARCHAR(100) │     │     created_at   TIMESTAMP     │
│     province        VARCHAR(100) │     └───────────────┬────────────────┘
│     landmark        TEXT         │                     │ 1
│     lat             DECIMAL(10,8)│                     │ N
│     lng             DECIMAL(11,8)│                     │
│     severity        VARCHAR(20)  │◄────────────────────┘
│     status          VARCHAR(50)  │  assigned_office_id FK
│     photo_url       TEXT         │
│     is_validated    BOOLEAN      │
│ FK  citizen_id      BIGINT       │
│ FK  assigned_office_id BIGINT    │
│     assigned_at     TIMESTAMP    │
│     resolved_at     TIMESTAMP    │
│     resolution_note TEXT         │
│     rejection_note  TEXT         │
│     created_at      TIMESTAMP    │
│     updated_at      TIMESTAMP    │
└──────┬──────┬──────┬─────────────┘
       │      │      │
       │ 1    │ 1    │ 1
       │      │      │
       │ N    │ N    │ N
       ▼      ▼      ▼
┌──────────┐ ┌─────────────────────┐ ┌────────────────────────────────┐
│OTP_CODES │ │  REPORT_ACTIVITIES  │ │    CITIZEN_NOTIFICATIONS       │
├──────────┤ ├─────────────────────┤ ├────────────────────────────────┤
│PK id     │ │ PK  id    BIGINT    │ │ PK  id           BIGINT        │
│   phone  │ │ FK  report_id       │ │ FK  citizen_id   BIGINT        │
│   code   │ │     title   VARCHAR │ │ FK  report_id    BIGINT        │
│   used   │ │     description TEXT│ │     reference_no VARCHAR       │
│   expires│ │     status  VARCHAR │ │     title        VARCHAR       │
│   _at    │ │     created_at      │ │     message      TEXT          │
└──────────┘ └─────────────────────┘ │     status       VARCHAR       │
                                     │     is_read      BOOLEAN       │
┌────────────────────────────────┐   │     created_at   TIMESTAMP     │
│         ANNOUNCEMENTS          │   └────────────────────────────────┘
├────────────────────────────────┤
│ PK  id           BIGINT        │
│     title        VARCHAR(255)  │
│     body         TEXT          │
│     is_published BOOLEAN       │
│     created_at   TIMESTAMP     │
│     updated_at   TIMESTAMP     │
└────────────────────────────────┘
```

### ERD Relationships Summary

| Relationship | Cardinality | Description |
|---|---|---|
| CITIZENS → CITIZEN_REPORTS | 1 : N | One citizen submits many reports |
| GOVERNMENT_OFFICES → CITIZEN_REPORTS | 1 : N | One office handles many reports |
| CITIZEN_REPORTS → REPORT_ACTIVITIES | 1 : N | One report has many activity log entries |
| CITIZENS → CITIZEN_NOTIFICATIONS | 1 : N | One citizen receives many notifications |
| CITIZEN_REPORTS → CITIZEN_NOTIFICATIONS | 1 : N | One report triggers many notifications |
| CITIZENS → OTP_CODES | 1 : N (via phone) | One phone number can have multiple OTP attempts |

---

## 3. Data Flow Diagram (DFD)

### Level 0 — Context Diagram

```
                     ┌──────────────────┐
                     │     CITIZEN      │
                     │  (Flutter App)   │
                     └────────┬─────────┘
                              │  Report Submission
                              │  (category, concern, photo,
                              │   GPS coords, description, severity)
                              │
                              ▼
┌─────────────┐   Report status updates    ┌──────────────────────────────┐
│ SUPER ADMIN │ ─────────────────────────► │                              │
│             │ ◄── Reports, Analytics,    │        CIVILWATCH            │
│             │      Notifications         │                              │
│             │                            │  Geotagged Community         │
│    CEO      │ ──── Assigned Reports ───► │  Incident Reporting System   │
│             │ ◄── Progress Updates,      │                              │
│             │      Notifications         │  Laravel 12 + MySQL          │
│             │                            │                              │
│   CENRO     │ ──── Assigned Reports ───► │                              │
│             │ ◄── Progress Updates,      └──────────────┬───────────────┘
│             │      Notifications                        │
└─────────────┘                                           │  Store/Retrieve
                                                          │  Photos
                                                          ▼
                                               ┌────────────────────────┐
                                               │   Laravel Storage      │
                                               │   (local / future S3)  │
                                               └────────────────────────┘
```

### Level 1 — System DFD

```
CITIZEN ──── submit report + photo ──────────────► ┌──────────────────────────┐
                                                    │  P1: Report Submission   │
                             ◄── reference_no ──────┤  & Validation            │
                                                    └──────────┬───────────────┘
                                                               │ store report
                                                               ▼
                                                       ┌───────────────────┐
         ┌─────────────────────────────────────────── │  D1: CITIZEN_     │
         │                                             │      REPORTS      │
         ▼                                             └───────┬───────────┘
┌──────────────────────┐                                       │
│  P2: Admin Review    │ ◄── retrieve pending reports ─────────┘
│  & Assignment        │
│  (Super Admin)       │ ──── assign to office ──────────────► ┌───────────────────┐
└──────────┬───────────┘                                       │ D2: GOVERNMENT_   │
           │ update status                                     │     OFFICES       │
           ▼                                                   └───────────────────┘
   ┌───────────────────┐
   │  D1: CITIZEN_     │ (status: Assigned to Office)
   │      REPORTS      │
   └───────┬───────────┘
           │
           ▼
┌──────────────────────┐ ◄── retrieve assigned reports
│  P3: Office Report   │
│  Management          │ (CEO or CENRO)
│  (Update/Resolve)    │ ──── upload after photo ────────────► ┌───────────────────┐
└──────────┬───────────┘                                       │ D3: LARAVEL       │
           │ update status, log activity                       │     STORAGE       │
           ▼                                                   └───────────────────┘
   ┌───────────────────┐      ┌──────────────────────────┐
   │  D1: CITIZEN_     │ ──── │  D4: REPORT_ACTIVITIES   │
   │      REPORTS      │      └──────────────────────────┘
   └───────┬───────────┘
           │
           ▼
┌──────────────────────┐ ◄── retrieve all data
│  P4: Analytics &     │
│  Reporting           │ ──── stats/charts ──────────────────► SUPER ADMIN / CEO / CENRO
└──────────────────────┘ ──── map pins (lat/lng/status) ──────► ALL PORTALS (Leaflet / flutter_map)

┌──────────────────────┐ ◄── triggered by P2 / P3 status changes
│  P5: Notification    │
│  Engine              │ ──── citizen notifications ─────────► D5: CITIZEN_NOTIFICATIONS
│  (CitizenReport::    │                                        └──► Flutter app
│   transitionTo())    │
└──────────────────────┘

┌──────────────────────┐
│  P6: User            │ ◄── SUPER ADMIN manages staff
│  Management          │ ──── store/update ──────────────────► D6: USERS
└──────────────────────┘
```

### Level 2 — Report Submission Sub-process (P1 Exploded)

```
CITIZEN (Flutter App)
  │
  │  POST /api/mobile/reports
  │  category, issue, description, lat, lng,
  │  barangay, severity, photo (multipart)
  ▼
┌────────────────────────────────┐
│  P1.1: Validate Input Fields   │ ──── missing/invalid ──► return 422 validation error
└───────────────┬────────────────┘
                │ valid
                ▼
┌────────────────────────────────┐
│  P1.2: Upload Photo to         │ ──── image file ────────► Laravel Storage
│        Laravel Storage         │ ◄─── storage path
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P1.3: Generate Reference No.  │
│        CW-{YEAR}-{XXXXX}       │
│        (server-side, sequential│
│         per year, zero-padded) │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P1.4: Save to citizen_reports │ ──── INSERT ────────────► D1: CITIZEN_REPORTS
│        status = Pending        │      (status = 'Pending Validation')
│        Validation              │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P1.5: Create Activity Entry   │ ──── INSERT ────────────► D4: REPORT_ACTIVITIES
│        "Concern Submitted"     │      (title, description, status, timestamp)
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P1.6: Send Citizen            │ ──── INSERT ────────────► D5: CITIZEN_NOTIFICATIONS
│        Notification            │      ("Concern Submitted")
└───────────────┬────────────────┘
                │
                ▼
             Return reference_no + report data
             to Flutter app
```

### Level 2 — Report Management Sub-process (P3 Exploded)

```
CEO / CENRO (Admin Web or API)
  │
  │  Open assigned report
  ▼
┌────────────────────────────────┐
│  P3.1: Retrieve Report Details │ ◄──── READ ─────────── D1: CITIZEN_REPORTS
│        + Activities + Office   │ ◄──── READ ─────────── D4: REPORT_ACTIVITIES
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P3.2: Update Progress         │
│        (status + notes)        │
│        via transitionTo()      │ ──── UPDATE ────────── D1: CITIZEN_REPORTS
└───────────────┬────────────────┘ ──── INSERT ────────── D4: REPORT_ACTIVITIES
                │                  ──── INSERT ────────── D5: CITIZEN_NOTIFICATIONS
         [if resolving]
                │
                ▼
┌────────────────────────────────┐
│  P3.3: Upload After Photo      │ ──── image file ──────► Laravel Storage
│                                │ ◄─── storage path
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P3.4: Set Status = Resolved   │ ──── UPDATE ────────── D1: CITIZEN_REPORTS
│        resolution_note saved   │ ──── INSERT ────────── D4: REPORT_ACTIVITIES
└───────────────┬────────────────┘ ──── INSERT ────────── D5: CITIZEN_NOTIFICATIONS
                │                       (to citizen: "Your report is resolved")
                ▼
           Citizen sees "Resolved"
           in Flutter Track Report
```

---

## 4. Use Case Diagram

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                         CIVILWATCH SYSTEM BOUNDARY                          ║
║                                                                              ║
║  CITIZEN (Flutter Mobile App)                                                ║
║  ┌──────┐                                                                    ║
║  │  👤  │─────── (UC01) Register with Phone + 6-digit PIN ─────────────────  ║
║  │      │─────── (UC02) Login with Phone + OTP ────────────────────────────  ║
║  │      │─────── (UC03) Submit Incident Report (5-step wizard) ────────────  ║
║  │      │─────── (UC04) Upload Incident Photo ──────────────────────────────  ║
║  │      │─────── (UC05) Use GPS / Pick Location on Map ──────────────────── ║
║  │      │─────── (UC06) View My Reports ─────────────────────────────────── ║
║  │      │─────── (UC07) Track Report Status ─── «include» (UC15) ──────────  ║
║  │      │─────── (UC08) View Community Map ──────────────────────────────── ║
║  │      │─────── (UC09) Receive Notifications ───────────────────────────── ║
║  │      │─────── (UC10) View City Announcements ─────────────────────────── ║
║  └──────┘                                                                    ║
║                                                                              ║
║  SUPER ADMIN (Web Dashboard)                                                 ║
║  ┌──────┐                                                                    ║
║  │  👤  │─────── (UC11) Login (email + password) ───────────────────────── ║
║  │      │─────── (UC12) View Dashboard ──────────────────────────────────── ║
║  │      │─────── (UC13) View Pending Reports ────────────────────────────── ║
║  │      │─────── (UC14) Validate Report (Approve/Reject) ─────────────────  ║
║  │      │─────── (UC15) Assign Report to Office ─────────────────────────── ║
║  │      │─────── (UC16) Monitor All Reports ─────────────────────────────── ║
║  │      │─────── (UC17) View GIS Map ─────────── «include» (UC25) ─────────  ║
║  │      │─────── (UC18) View Analytics & Charts ─────────────────────────── ║
║  │      │─────── (UC19) Manage Staff Users ──────────────────────────────── ║
║  │      │─────── (UC20) Manage System Settings ──────────────────────────── ║
║  │      │─────── (UC21) Manage Announcements ────────────────────────────── ║
║  │      │─────── (UC22) Receive Notifications ───────────────────────────── ║
║  └──────┘                                                                    ║
║                                                                              ║
║  CEO (City Engineering Office — Web Dashboard)                               ║
║  ┌──────┐                                                                    ║
║  │  👤  │─────── (UC11) Login (email + password)                             ║
║  │      │─────── (UC23) View CEO Dashboard ─────────────────────────────── ║
║  │      │─────── (UC24) View Assigned Infrastructure Reports ──────────────  ║
║  │      │─────── (UC25) View Report on Leaflet Map ───────────────────────── ║
║  │      │─────── (UC26) Update Report Progress ──────────────────────────── ║
║  │      │─────── (UC27) Upload After/Resolution Photo ────────────────────  ║
║  │      │─────── (UC28) Resolve Report ───── «include» (UC27) ────────────  ║
║  │      │─────── (UC22) Receive Notifications ───────────────────────────── ║
║  └──────┘                                                                    ║
║                                                                              ║
║  CENRO (City Environment & Natural Resources Office — Web Dashboard)         ║
║  ┌──────┐  (Same use cases as CEO, scoped to environmental reports)          ║
║  │  👤  │─────── (UC11), (UC23)–(UC28), (UC22) ──────────────────────────── ║
║  └──────┘                                                                    ║
║                                                                              ║
║  SHARED / SYSTEM USE CASES                                                   ║
║  (UC25) Display Map with Geotagged Pins  — all portals (Leaflet / flutter_map)║
║  (UC29) Toggle Dark Mode                 — web admin all roles               ║
║  (UC30) Logout                           — all authenticated users           ║
║  (UC31) Export Reports (CSV)             — Super Admin (future)              ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

### Actors

| Actor | Type | Description |
|---|---|---|
| Citizen | External Primary | Submits geotagged incident reports via Flutter mobile app |
| Super Admin | Internal Primary | Validates reports, assigns offices, manages users and system |
| CEO | Internal Primary | Handles infrastructure reports assigned by Super Admin |
| CENRO | Internal Primary | Handles environmental reports assigned by Super Admin |
| Laravel Storage | Internal Secondary | Stores uploaded photos (before/after) |
| MySQL Database | Internal Secondary | Persists all system data via Eloquent |

---

## 5. Report Status State Diagram

```
                     ┌─────────────────┐
  Citizen submits    │                 │
  ─────────────────► │    PENDING      │
  (via Flutter app)  │   VALIDATION    │
                     └──────┬──────────┘
                            │
             ┌──────────────┼──────────────────┐
             │              │                  │
       Admin Rejects   Admin Validates          │
             │         & Assigns               │
             ▼              ▼                  │
      ┌──────────┐   ┌─────────────────┐       │
      │ REJECTED │   │  ASSIGNED TO    │       │
      └──────────┘   │    OFFICE       │       │
                     └────────┬────────┘       │
                              │                │
                     Office Starts Work        │
                              │                │
                              ▼                │
                       ┌─────────────┐         │
                       │ IN PROGRESS │         │
                       └──────┬──────┘         │
                              │                │
                    Office Uploads After Photo  │
                    + Adds Resolution Notes     │
                              │                │
                              ▼                │
                       ┌──────────┐            │
                       │ RESOLVED │ ◄──────────┘
                       └──────────┘   (Admin can also
                                       directly resolve)

Each transition via CitizenReport::transitionTo() automatically:
  1. Updates status column
  2. Creates a ReportActivity log entry
  3. Sends a CitizenNotification to the report owner

Status Colors:
  PENDING VALIDATION  → Amber   #F59E0B  (web) / #F59E0B  (app)
  ASSIGNED TO OFFICE  → Blue    #1A56DB  (web) / #2563EB  (app)
  IN PROGRESS         → Orange  #F97316  (web) / #EA580C  (app)
  RESOLVED            → Green   #10B981  (web) / #16A34A  (app)
  REJECTED            → Red     #EF4444  (web) / #DC2626  (app)
```

---

## 6. Report Categories

### Infrastructure — City Engineering Office (CEO)

| # | Category | Description |
|---|---|---|
| 1 | Road Repair | Potholes, damaged road surface needing repair, patching, or compaction |
| 2 | Road Graveling | Unpaved or gravel road needs re-graveling or new gravel application |
| 3 | Streetlight / Light Pole Concern | Broken, flickering, missing streetlight — repair or replacement |
| 4 | Blocked Canal | Canal clogged by debris or sediment, causing drainage issues |
| 5 | Others | Other infrastructure concerns not covered by the categories above |

### Environmental — CENRO

| # | Category | Description |
|---|---|---|
| 1 | Illegal Dumping | Large amounts of garbage illegally dumped in public or private space |
| 2 | Garbage Collection | Missed scheduled pickup or garbage collection request |

**Total: 7 categories** (5 Infrastructure + 2 Environmental)

---

## 7. Technology Stack

```
┌──────────────────────────────────────────────────────────────────┐
│                    CIVILWATCH TECH STACK                         │
├──────────────────────────┬───────────────────────────────────────┤
│ Layer                    │ Technology                            │
├──────────────────────────┼───────────────────────────────────────┤
│ Admin Web Frontend       │ HTML5, CSS3, Vanilla JavaScript       │
│ Admin Maps               │ Leaflet.js + OpenStreetMap tiles      │
│ Admin Charts             │ Chart.js                              │
│ Admin Icons              │ Material Symbols (Google)             │
├──────────────────────────┼───────────────────────────────────────┤
│ Citizen Mobile App       │ Flutter / Dart (SDK ^3.12.2)          │
│ App Maps                 │ flutter_map ^8.1.1 + OpenStreetMap    │
│ App Geocoding            │ Nominatim reverse geocoding (http)    │
│ App Fonts                │ Google Fonts — Inter + Roboto Mono    │
│ App State Management     │ Singleton ChangeNotifier (no Bloc)    │
├──────────────────────────┼───────────────────────────────────────┤
│ Backend Framework        │ Laravel 12                            │
│ Backend Language         │ PHP                                   │
│ Backend Auth             │ Laravel Sanctum (multi-guard)         │
│   Staff guard            │ auth:sanctum — email + password       │
│   Citizen guard          │ auth:citizen — phone + OTP + PIN      │
├──────────────────────────┼───────────────────────────────────────┤
│ Database                 │ MySQL 8.0                             │
│ ORM                      │ Eloquent (Laravel built-in)           │
├──────────────────────────┼───────────────────────────────────────┤
│ File Storage             │ Laravel Storage (local disk)          │
│                          │ Future: S3 or Cloudinary              │
├──────────────────────────┼───────────────────────────────────────┤
│ SMS / OTP                │ Dev: OTP returned in API response     │
│                          │ Future: Semaphore (PH SMS gateway)    │
├──────────────────────────┼───────────────────────────────────────┤
│ Dev Tools                │ Postman, TablePlus, Artisan CLI       │
│ Hosting (target)         │ Local dev → shared hosting / VPS      │
└──────────────────────────┴───────────────────────────────────────┘
```

### Why Laravel (Not Node.js)

| Consideration | Decision |
|---|---|
| Team experience | Team is learning PHP/Laravel — fits the capstone scope |
| ORM | Eloquent is simple and readable for beginners |
| Auth | Sanctum handles multi-guard (staff + citizens) out of the box |
| Blade views | Built-in templating for admin web panel — no extra frontend build step |
| Artisan CLI | `php artisan migrate`, `db:seed`, `serve` — minimal setup |
| SMS | Semaphore (Philippine provider) has a simple PHP SDK |

---

*CIVILWATCH — University of Mindanao Digos Branch | BS Information Technology Capstone 2026*
*Proponents: Renz Justine Y. Borinaga | Jhon Carlo Mag-Usara | Lawrence Roy P. Sereno*
*Adviser: Cyvil Dave Dasargo, MIT*
