# CIVILWATCH — System Design Document
> Geotagged Community Incident Reporting System | Digos City
> University of Mindanao — Digos Branch | BS Information Technology | 2026
> Proponents: Renz Justine Y. Borinaga, Jhon Carlo Mag-Usara, Lawrence Roy P. Sereno
> Adviser: Cyvil Dave Dasargo, MIT

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
   - [Actors](#actors)
   - [Use Case Descriptions](#use-case-descriptions)
5. [Report Status State Diagram](#5-report-status-state-diagram)

---

---

## 1. System Architecture Design

CIVILWATCH follows a **3-Tier Client-Server Architecture** with an external cloud storage layer.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                          PRESENTATION TIER                              │
│                                                                         │
│   ┌──────────────────┐   ┌──────────────────┐   ┌──────────────────┐  │
│   │   Super Admin    │   │   CEO Portal     │   │  CENRO Portal    │  │
│   │   Web Portal     │   │  (Blue Theme)    │   │  (Green Theme)   │  │
│   │  (11 Pages)      │   │  (8 Pages)       │   │  (8 Pages)       │  │
│   └────────┬─────────┘   └────────┬─────────┘   └────────┬─────────┘  │
│            │                      │                       │            │
│      HTML5 + CSS3 + Vanilla JS + Leaflet.js + Chart.js                 │
└────────────┼──────────────────────┼───────────────────────┼────────────┘
             │         HTTPS / REST API / WebSocket          │
             │                      │                       │
┌────────────┼──────────────────────┼───────────────────────┼────────────┐
│            │         APPLICATION TIER                      │            │
│            └──────────────────────┴───────────────────────┘            │
│                                   │                                     │
│                    ┌──────────────▼──────────────┐                     │
│                    │   Node.js + Express.js       │                     │
│                    │   REST API Server            │                     │
│                    │                              │                     │
│                    │  ┌─────────────────────────┐ │                     │
│                    │  │  Middleware Layer        │ │                     │
│                    │  │  • JWT Auth Guard        │ │                     │
│                    │  │  • Role Check (RBAC)     │ │                     │
│                    │  │  • Multer Upload         │ │                     │
│                    │  │  • CORS / Helmet         │ │                     │
│                    │  └─────────────────────────┘ │                     │
│                    │                              │                     │
│                    │  ┌──────────────────────────┐│                     │
│                    │  │  Route Controllers        ││                     │
│                    │  │  • /api/auth              ││                     │
│                    │  │  • /api/reports           ││                     │
│                    │  │  • /api/users             ││                     │
│                    │  │  • /api/analytics         ││                     │
│                    │  │  • /api/notifications     ││                     │
│                    │  │  • /api/map/pins          ││                     │
│                    │  └──────────────────────────┘│                     │
│                    │                              │                     │
│                    │  Socket.io (real-time)       │                     │
│                    └──────────────┬───────────────┘                     │
└───────────────────────────────────┼─────────────────────────────────────┘
                                    │
┌───────────────────────────────────┼─────────────────────────────────────┐
│                          DATA TIER │                                     │
│                                   │                                      │
│        ┌──────────────────────────▼──────────────────┐                  │
│        │              MySQL Database                  │                  │
│        │  (Sequelize ORM)                             │                  │
│        │                                              │                  │
│        │  Tables: users, reports, report_photos,      │                  │
│        │          report_timeline, notifications,     │                  │
│        │          report_assignments, categories,     │                  │
│        │          barangays                           │                  │
│        └──────────────────────────────────────────────┘                  │
│                                                                           │
│        ┌──────────────────────────────────────────────┐                  │
│        │           Cloudinary CDN                     │                  │
│        │  • Before photos (citizen-submitted)         │                  │
│        │  • After photos (office-uploaded)            │                  │
│        │  • Stores: public_id + secure_url in MySQL   │                  │
│        └──────────────────────────────────────────────┘                  │
└───────────────────────────────────────────────────────────────────────────┘

EXTERNAL ACTORS
  ┌──────────────────┐        ┌──────────────────┐
  │  Citizen         │        │  Mobile App      │
  │  (Mobile/Web)    │        │  (React Native / │
  │  Submits reports │        │   Flutter - TBD) │
  └──────────────────┘        └──────────────────┘
       Both hit POST /api/reports (unauthenticated)
```

---

---

## 2. Entity Relationship Diagram (ERD)

> Notation: PK = Primary Key | FK = Foreign Key | UQ = Unique | NN = Not Null

```
┌─────────────────────────────────┐
│            USERS                │
├─────────────────────────────────┤
│ PK  id              INT         │
│     name            VARCHAR(100)│
│ UQ  email           VARCHAR(100)│
│     password_hash   VARCHAR(255)│
│     role    ENUM(super_admin,   │
│                    ceo, cenro)  │
│     office          VARCHAR(50) │
│     avatar_url      TEXT        │
│     is_active       BOOLEAN     │
│     created_at      DATETIME    │
│     updated_at      DATETIME    │
└────────────┬────────────────────┘
             │ 1
             │ creates / performs
             │ N
┌────────────▼────────────────────┐          ┌──────────────────────────────┐
│            REPORTS              │          │          CATEGORIES          │
├─────────────────────────────────┤          ├──────────────────────────────┤
│ PK  id              INT         │          │ PK  id          INT          │
│ UQ  reference_no    VARCHAR(20) │          │     name        VARCHAR(100) │
│     title           VARCHAR(255)│          │     type  ENUM(infrastructure│
│     description     TEXT        │          │               ,environmental)│
│ FK  category_id     INT ────────┼──────────►     icon        VARCHAR(50)  │
│     status  ENUM(pending,       │          │     color       VARCHAR(20)  │
│              assigned,          │          └──────────────────────────────┘
│              in_progress,       │
│              for_resolution,    │          ┌──────────────────────────────┐
│              resolved)          │          │          BARANGAYS           │
│     priority ENUM(low,medium,   │          ├──────────────────────────────┤
│                   high,urgent)  │          │ PK  id          INT          │
│ FK  barangay_id     INT ────────┼──────────►     name        VARCHAR(100) │
│     lat             DECIMAL(10,8)│         │     lat         DECIMAL(10,8)│
│     lng             DECIMAL(11,8)│         │     lng         DECIMAL(11,8)│
│ FK  submitted_by    INT         │          │     district    VARCHAR(50)  │
│ FK  assigned_to_office  INT     │          └──────────────────────────────┘
│     created_at      DATETIME    │
│     updated_at      DATETIME    │
└──┬──────┬──────┬────────────────┘
   │      │      │
   │ 1    │ 1    │ 1
   │      │      │
   │ N    │ N    │ N
   │      │      │
┌──▼──────┴┐  ┌──▼─────────────────┐   ┌────────────────────────────────┐
│REPORT_   │  │  REPORT_TIMELINE   │   │       REPORT_ASSIGNMENTS       │
│PHOTOS    │  ├────────────────────┤   ├────────────────────────────────┤
├──────────┤  │ PK  id     INT     │   │ PK  id              INT        │
│PK id INT │  │ FK  report_id INT  │   │ FK  report_id       INT        │
│FK report_│  │     action VARCHAR │   │ FK  assigned_to     INT        │
│   _id INT│  │     note   TEXT    │   │ FK  assigned_by     INT        │
│   type   │  │ FK  performed_by   │   │     priority        ENUM       │
│   ENUM   │  │         INT        │   │     notes           TEXT       │
│(before/  │  │     created_at     │   │     assigned_at     DATETIME   │
│  after)  │  │         DATETIME   │   └────────────────────────────────┘
│cloudinary│  └────────────────────┘
│_url TEXT │
│cloudinary│   ┌───────────────────────────────┐
│_public_id│   │         NOTIFICATIONS         │
│    TEXT  │   ├───────────────────────────────┤
│FK upload-│   │ PK  id          INT           │
│  _by INT │   │ FK  user_id     INT           │
│created_at│   │     message     TEXT          │
│ DATETIME │   │     type  ENUM(report,        │
└──────────┘   │           assignment,         │
               │           status,system)      │
               │     is_read     BOOLEAN       │
               │ FK  report_id   INT (nullable)│
               │     created_at  DATETIME      │
               └───────────────────────────────┘
```

### ERD Relationships Summary

| Relationship | Cardinality | Description |
|---|---|---|
| USERS → REPORTS (submitted_by) | 1 : N | One citizen submits many reports |
| USERS → REPORTS (assigned_to_office) | 1 : N | One office user handles many reports |
| REPORTS → REPORT_PHOTOS | 1 : N | One report has before + after photos |
| REPORTS → REPORT_TIMELINE | 1 : N | One report has many timeline events |
| REPORTS → REPORT_ASSIGNMENTS | 1 : N | One report can be reassigned |
| REPORTS → NOTIFICATIONS | 1 : N | One report triggers many notifications |
| USERS → NOTIFICATIONS | 1 : N | One user receives many notifications |
| CATEGORIES → REPORTS | 1 : N | One category classifies many reports |
| BARANGAYS → REPORTS | 1 : N | One barangay has many reports |

---

---

## 3. Data Flow Diagram (DFD)

---

### Level 0 — Context Diagram

> Shows CIVILWATCH as a single process and all external entities that interact with it.

```
                        ┌──────────────────┐
                        │     CITIZEN      │
                        │  (Mobile/Web)    │
                        └────────┬─────────┘
                                 │  Report Submission (title, description,
                                 │  photo, GPS coordinates, category)
                                 │
                                 ▼
┌─────────────┐     Report Status Updates      ┌─────────────────────────────┐
│ SUPER ADMIN │ ──────────────────────────────► │                             │
│             │ ◄── Reports, Analytics,         │        CIVILWATCH           │
│             │      User Data, Notifications   │                             │
│             │                                 │  Geotagged Community        │
│    CEO      │ ──── Assigned Reports ────────► │  Incident Reporting System  │
│             │ ◄── Progress Updates,           │                             │
│             │      Notifications              │                             │
│             │                                 │                             │
│   CENRO     │ ──── Assigned Reports ────────► │                             │
│             │ ◄── Progress Updates,           └──────────────┬──────────────┘
│             │      Notifications                             │
└─────────────┘                                                │
                                                               │  Store/Retrieve
                                                               │  Images
                                                               ▼
                                                  ┌────────────────────────┐
                                                  │   CLOUDINARY CDN       │
                                                  │  (External Storage)    │
                                                  └────────────────────────┘
```

---

### Level 1 — System DFD

> Expands CIVILWATCH into its major processes.

```
CITIZEN ──── submit report + photo ───────────► ┌─────────────────────────┐
                                                 │  P1: Report Submission  │
                                ◄─ reference_no ─┤  & Validation           │
                                                 └──────────┬──────────────┘
                                                            │ store report data
                                                            ▼
                                                    ┌───────────────┐
            ┌────────────────────────────────────── │  D1: REPORTS  │
            │                                       └───────┬───────┘
            ▼                                               │
 ┌──────────────────────┐                                   │
 │  P2: Admin Review    │ ◄── retrieve pending reports ─────┘
 │  & Assignment        │
 │  (Super Admin)       │ ──── assign to office ────────────► ┌──────────────────┐
 └──────────┬───────────┘                                     │ D2: ASSIGNMENTS  │
            │ update status                                   └──────────────────┘
            ▼
    ┌───────────────┐
    │  D1: REPORTS  │ (status: assigned)
    └───────┬───────┘
            │
            ▼
 ┌──────────────────────┐ ◄── retrieve assigned reports
 │  P3: Office Report   │
 │  Management          │ (CEO or CENRO)
 │  (Update/Resolve)    │ ──── upload after photo ──────────► ┌──────────────────┐
 └──────────┬───────────┘                                     │ D3: CLOUDINARY   │
            │ update status, insert timeline                  └──────────────────┘
            ▼
    ┌───────────────┐       ┌─────────────────────┐
    │  D1: REPORTS  │ ───── │ D4: REPORT_TIMELINE │
    └───────┬───────┘       └─────────────────────┘
            │
            ▼
 ┌──────────────────────┐ ◄── retrieve all data
 │  P4: Analytics &     │
 │  Reporting           │ ──── analytics charts ──────────── ► SUPER ADMIN / CEO / CENRO
 └──────────────────────┘ ──── map pins (lat/lng/status) ──── ► ALL PORTALS (Leaflet)


 ┌──────────────────────┐ ◄── triggered by P2 / P3 status changes
 │  P5: Notification    │
 │  Engine              │ ──── push notifications ───────────► D5: NOTIFICATIONS
 └──────────────────────┘                                      └──► SUPER ADMIN / OFFICES


 ┌──────────────────────┐
 │  P6: User            │ ◄── SUPER ADMIN manages users
 │  Management          │ ──── store/update ─────────────────► D6: USERS
 └──────────────────────┘
```

**Data Stores Summary**

| ID | Store | Contents |
|----|-------|---------|
| D1 | REPORTS | All incident report records |
| D2 | ASSIGNMENTS | Office assignment records |
| D3 | CLOUDINARY | Before/after photo URLs |
| D4 | REPORT_TIMELINE | Status change audit trail |
| D5 | NOTIFICATIONS | User notification queue |
| D6 | USERS | System user accounts |

---

### Level 2 — Report Submission Sub-process (P1 Exploded)

```
CITIZEN
  │
  │  title, description, category,
  │  barangay, lat, lng, photo file
  ▼
┌────────────────────────────────┐
│  P1.1: Validate Input Fields   │ ──── missing fields ────► return validation error
└───────────────┬────────────────┘
                │ valid data
                ▼
┌────────────────────────────────┐
│  P1.2: Upload Photo to         │ ──── image binary ──────► CLOUDINARY
│        Cloudinary              │ ◄─── secure_url,
└───────────────┬────────────────┘       public_id
                │
                ▼
┌────────────────────────────────┐
│  P1.3: Generate Reference No.  │
│        (CW-YYYY-XXXXX)         │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P1.4: Save Report to DB       │ ──── write ─────────────► D1: REPORTS
│        (status = pending)      │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P1.5: Save Photo Record       │ ──── write ─────────────► D3: REPORT_PHOTOS
│        (type = before)         │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P1.6: Insert Timeline Entry   │ ──── write ─────────────► D4: REPORT_TIMELINE
│        (action = submitted)    │
└───────────────┬────────────────┘
                │
                ▼
             Reference No.
             returned to CITIZEN
```

---

### Level 2 — Report Management Sub-process (P3 Exploded)

```
CEO / CENRO
  │
  │  Open assigned report
  ▼
┌────────────────────────────────┐
│  P3.1: Retrieve Report Details │ ◄──── read ─────────────── D1: REPORTS
│        + Timeline + Photos     │ ◄──── read ─────────────── D4: REPORT_TIMELINE
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P3.2: Update Progress         │
│        (add notes, set status) │ ──── update ────────────► D1: REPORTS
└───────────────┬────────────────┘ ──── insert ────────────► D4: REPORT_TIMELINE
                │
         [if resolving]
                │
                ▼
┌────────────────────────────────┐
│  P3.3: Upload After Photo      │ ──── image binary ──────► CLOUDINARY
│                                │ ◄─── secure_url
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P3.4: Save After Photo Record │ ──── write ─────────────► D3: REPORT_PHOTOS
│        (type = after)          │
└───────────────┬────────────────┘
                │
                ▼
┌────────────────────────────────┐
│  P3.5: Set Status = Resolved   │ ──── update ────────────► D1: REPORTS
└───────────────┬────────────────┘ ──── insert ────────────► D4: REPORT_TIMELINE
                │
                ▼
┌────────────────────────────────┐
│  P3.6: Trigger Notification    │ ──── insert ────────────► D5: NOTIFICATIONS
│        to Super Admin          │        (for super_admin user)
└────────────────────────────────┘
```

---

---

## 4. Use Case Diagram

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                         CIVILWATCH SYSTEM BOUNDARY                          ║
║                                                                              ║
║  CITIZEN                                                                     ║
║  ┌──────┐                                                                    ║
║  │  👤  │─────────────── (UC01) Submit Incident Report ────────────────────  ║
║  │      │─────────────── (UC02) Upload Incident Photo ─────────────────────  ║
║  │      │─────────────── (UC03) View Report Status ────────────────────────  ║
║  └──────┘                                                                    ║
║                                                                              ║
║  SUPER ADMIN                                                                 ║
║  ┌──────┐                                                                    ║
║  │  👤  │─────────────── (UC04) Login to System ──────────────────────────  ║
║  │      │─────────────── (UC05) View Dashboard ────────────────────────────  ║
║  │      │─────────────── (UC06) View Pending Reports ───────────────────────  ║
║  │      │─────────────── (UC07) Validate Report (Approve/Reject) ──────────  ║
║  │      │─────────────── (UC08) Assign Report to Office ────────────────────  ║
║  │      │─────────────── (UC09) Monitor All Reports ────────────────────────  ║
║  │      │─────────────── (UC10) View GIS Map ─────────── «include» (UC23)    ║
║  │      │─────────────── (UC11) View Analytics & Charts ─────────────────── ║
║  │      │─────────────── (UC12) Manage Users ───────────────────────────────  ║
║  │      │─────────────── (UC13) Manage System Settings ──────────────────── ║
║  │      │─────────────── (UC14) Receive Notifications ───────────────────── ║
║  └──────┘                                                                    ║
║                                                                              ║
║  CEO (City Engineering Office)                                               ║
║  ┌──────┐                                                                    ║
║  │  👤  │─────────────── (UC04) Login to System                              ║
║  │      │─────────────── (UC15) View CEO Dashboard ─────────────────────── ║
║  │      │─────────────── (UC16) View Assigned Reports ───────────────────── ║
║  │      │─────────────── (UC17) View Report Details ─────────────────────── ║
║  │      │─────────────── (UC18) Update Report Progress ──────────────────── ║
║  │      │─────────────── (UC19) Upload After/Resolution Photo ──────────── ║
║  │      │─────────────── (UC20) Resolve Report ─────── «include» (UC19)     ║
║  │      │─────────────── (UC21) View CEO Map ──────────«include» (UC23)     ║
║  │      │─────────────── (UC22) View CEO Analytics ──────────────────────── ║
║  │      │─────────────── (UC14) Receive Notifications ───────────────────── ║
║  └──────┘                                                                    ║
║                                                                              ║
║  CENRO                                                                       ║
║  ┌──────┐                                                                    ║
║  │  👤  │─────────────── (UC04) Login to System                              ║
║  │      │─────────────── (UC15) View CENRO Dashboard ─────────────────────  ║
║  │      │─────────────── (UC16) View Assigned Reports ───────────────────── ║
║  │      │─────────────── (UC17) View Report Details ─────────────────────── ║
║  │      │─────────────── (UC18) Update Report Progress ──────────────────── ║
║  │      │─────────────── (UC19) Upload After/Resolution Photo ──────────── ║
║  │      │─────────────── (UC20) Resolve Report ─────── «include» (UC19)     ║
║  │      │─────────────── (UC21) View CENRO Map ────────«include» (UC23)     ║
║  │      │─────────────── (UC22) View CENRO Analytics ──────────────────────  ║
║  │      │─────────────── (UC14) Receive Notifications ───────────────────── ║
║  └──────┘                                                                    ║
║                                                                              ║
║  SHARED USE CASES (system-level)                                             ║
║  (UC23) Display Leaflet Map with Geotagged Pins                              ║
║  (UC24) Export Reports (CSV / PDF)                        «extend» of list  ║
║  (UC25) Toggle Dark Mode                                  all portal users  ║
║  (UC26) Logout                                            all logged-in     ║
║                                                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

---

### Actors

| Actor | Type | Description |
|---|---|---|
| Citizen | External Primary | Submits geotagged incident reports via mobile/web |
| Super Admin | Internal Primary | Validates reports, assigns offices, manages users and system |
| CEO | Internal Primary | Handles infrastructure reports assigned by Super Admin |
| CENRO | Internal Primary | Handles environmental reports assigned by Super Admin |
| Cloudinary | External Secondary | Stores uploaded photos and serves CDN URLs |
| MySQL Database | Internal Secondary | Persists all system data |

---

### Use Case Descriptions

#### UC01 — Submit Incident Report

| Field | Detail |
|---|---|
| Actor | Citizen |
| Precondition | Citizen has internet access and GPS enabled |
| Main Flow | 1. Citizen opens app → 2. Fills form (title, description, category, barangay) → 3. GPS auto-captures coordinates → 4. Uploads photo → 5. Submits → 6. System returns reference number |
| Alternate Flow | If GPS unavailable → Citizen manually pins location on map |
| Postcondition | Report saved with status = **Pending**, notification sent to Super Admin |

#### UC07 — Validate Report

| Field | Detail |
|---|---|
| Actor | Super Admin |
| Precondition | Report exists with status = Pending |
| Main Flow | 1. Admin opens Pending Reports → 2. Views report details + photo + map → 3. Clicks Approve or Reject → 4. Adds notes → 5. Confirms |
| Alternate Flow | Reject: report status set to Rejected, citizen notified |
| Postcondition | Status = **Assigned** (if approved), timeline updated |

#### UC08 — Assign Report to Office

| Field | Detail |
|---|---|
| Actor | Super Admin |
| Precondition | Report status = Pending or Approved |
| Main Flow | 1. Admin selects office (CEO/CENRO) → 2. Sets priority → 3. Adds notes → 4. Confirms assignment |
| Postcondition | Report status = **Assigned**, office notified, assignment record created |

#### UC20 — Resolve Report

| Field | Detail |
|---|---|
| Actor | CEO / CENRO |
| Precondition | Report status = In Progress or For Resolution |
| Main Flow | 1. Office opens report → 2. Uploads after photo (UC19) → 3. Adds resolution notes → 4. Clicks Resolve → 5. Confirms |
| Postcondition | Status = **Resolved**, Super Admin notified, timeline updated |

---

---

## 5. Report Status State Diagram

```
                        ┌───────────────┐
     Citizen submits    │               │
     ─────────────────► │    PENDING    │
                        │               │
                        └──────┬────────┘
                               │
              ┌────────────────┼──────────────────┐
              │                │                  │
        Admin Rejects    Admin Approves            │
              │           & Assigns                │
              ▼                ▼                   │
       ┌──────────┐     ┌────────────┐             │
       │ REJECTED │     │  ASSIGNED  │             │
       └──────────┘     └─────┬──────┘             │
                              │                    │
                     Office Starts Work             │
                              │                    │
                              ▼                    │
                       ┌────────────┐              │
                       │ IN PROGRESS│              │
                       └─────┬──────┘              │
                             │                     │
                    Office Marks For Review         │
                             │                     │
                             ▼                     │
                    ┌─────────────────┐            │
                    │ FOR RESOLUTION  │            │
                    └────────┬────────┘            │
                             │                     │
                    Office Resolves + After Photo   │
                             │                     │
                             ▼                     │
                       ┌──────────┐                │
                       │ RESOLVED │ ◄──────────────┘
                       └──────────┘    (Admin can also
                                        directly resolve)

Status Colors:
  PENDING        → Amber    #F59E0B
  ASSIGNED       → Blue     #1A56DB
  IN PROGRESS    → Orange   #F97316
  FOR RESOLUTION → Yellow   #EAB308
  RESOLVED       → Green    #10B981
  REJECTED       → Red      #EF4444
```

---

## 6. Report Categories

### Infrastructure — handled by City Engineering Office (CEO)

| # | Category | Description |
|---|---|---|
| 1 | Road Repair | Road needs repair, patching, compaction, shouldering, or surface work. Citizen describes specifics. |
| 2 | Road Graveling | Gravel road needs re-graveling or new gravel application. |
| 3 | Streetlight / Light Pole Concern | Streetlight or light pole needs repair, replacement, or is a new installation request. Citizen describes specifics. |
| 4 | Blocked Canal | Canal is clogged or blocked, causing drainage or flooding issues. |
| 5 | Others | Other infrastructure concerns not covered by the categories above. |

### Environmental — handled by CENRO

| # | Category | Description |
|---|---|---|
| 1 | Illegal Dumping | Large amount of garbage illegally dumped in an unauthorized public or private space. |
| 2 | Garbage Collection | Garbage collection request or missed scheduled pickup in the area. |

**Total: 7 categories** (5 Infrastructure + 2 Environmental)

---

## 7. Technology Stack Summary

```
┌─────────────────────────────────────────────────────────────────┐
│                    CIVILWATCH TECH STACK                        │
├─────────────────────┬───────────────────────────────────────────┤
│ Layer               │ Technology                                │
├─────────────────────┼───────────────────────────────────────────┤
│ Frontend            │ HTML5, CSS3, Vanilla JavaScript           │
│ Maps                │ Leaflet.js + OpenStreetMap tiles          │
│ Charts              │ Chart.js                                  │
│ Icons               │ Material Symbols (Google)                 │
├─────────────────────┼───────────────────────────────────────────┤
│ Backend Runtime     │ Node.js v20+                              │
│ Backend Framework   │ Express.js                                │
│ Real-time           │ Socket.io                                 │
├─────────────────────┼───────────────────────────────────────────┤
│ Database            │ MySQL 8.0                                 │
│ ORM                 │ Sequelize                                 │
├─────────────────────┼───────────────────────────────────────────┤
│ Authentication      │ JWT (httpOnly cookies) + bcrypt           │
│ Authorization       │ RBAC Middleware (role-based)              │
├─────────────────────┼───────────────────────────────────────────┤
│ Image Storage       │ Cloudinary                                │
│ Upload Middleware   │ Multer + multer-storage-cloudinary        │
├─────────────────────┼───────────────────────────────────────────┤
│ Hosting – Backend   │ Railway / Render                          │
│ Hosting – DB        │ Railway MySQL / PlanetScale               │
│ Hosting – Frontend  │ Netlify / Express static serve            │
├─────────────────────┼───────────────────────────────────────────┤
│ Dev Tools           │ Postman, TablePlus, nodemon, PM2, dotenv  │
└─────────────────────┴───────────────────────────────────────────┘
```

---

*CIVILWATCH — University of Mindanao Digos Branch | BS Information Technology Capstone 2026*
*Proponents: Renz Justine Y. Borinaga | Jhon Carlo Mag-Usara | Lawrence Roy P. Sereno*
*Adviser: Cyvil Dave Dasargo, MIT*
