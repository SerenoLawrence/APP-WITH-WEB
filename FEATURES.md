# CIVILWATCH — Full Feature List

> **Full-Stack Capstone | Flutter + Laravel + HTML/JS**
> Last Updated: August 13, 2026

---

## System Overview

CIVILWATCH has three components. Features below are organized by component.

---

## Component 1 — Admin Web Dashboard (HTML/JS Prototype)

### Authentication & Roles
- Three roles: Super Admin, CEO (City Engineering Office), CENRO
- Login routes each role to their respective dashboard automatically
- Role guards protect every page — wrong role redirects to correct dashboard
- Dark mode and session state persist via `localStorage`
- Logout clears session and returns to login

**Demo Credentials (static prototype)**

| Role | Username | Password |
|---|---|---|
| Super Administrator | `admin` | `admin123` |
| City Engineering Officer | `ceo` | `ceo123` |
| CENRO Administrator | `cenro` | `cenro123` |

### Super Admin (11 Pages)

| Page | File | Description |
|---|---|---|
| Login | `index.html` | Role-based routing on login |
| Dashboard | `dashboard.html` | Stat cards, recent reports, Leaflet map, activity feed, quick actions |
| Pending Reports | `pending-reports.html` | Validation queue with search and filters |
| Report Details | `report-details.html` | Full detail, approve/reject modals, photo, timeline |
| Assign Office | `assign-office.html` | Assign reports to CEO or CENRO with priority and notes |
| Monitoring | `monitoring.html` | Tab-filtered progress tracking with update modal |
| GIS Map | `gis-map.html` | Leaflet map with filter chips and detail panel |
| Analytics | `analytics.html` | 5 Chart.js charts (line, bar ×2, doughnut ×2), weekly/monthly toggle |
| Resolved Reports | `resolved-reports.html` | Searchable archive of completed reports |
| Users | `users.html` | User table, slide-in details panel, Add User modal |
| Settings | `settings.html` | 7 sections: General, Categories, Offices, Notifications, Security, Logs, About |

### CEO Office — `offices/ceo/` (Blue Theme, 8 Pages)

| Page | Description |
|---|---|
| `dashboard.html` | 4 stat cards, recent reports list, Leaflet map with legend |
| `reports.html` | Assigned infrastructure reports table, View button |
| `inprogress.html` | Active reports with stat cards, list layout, right info panel |
| `resolved.html` | Resolved archive with 3 summary stat cards |
| `map.html` | Leaflet map with filter chips |
| `analytics.html` | Infrastructure-only: 4 summary cards + 5 charts |
| `report-details.html` | Incident photo, info table, Leaflet preview, 5-step timeline, update form, resolve modal, before/after photo |
| `settings.html` | Placeholder — coming soon |

### CENRO Office — `offices/cenro/` (Green Theme, 8 Pages)
Same structure as CEO, scoped to environmental reports with green accent colors.

### Shared UI Components
- **Sidebar** — collapse/expand, role-aware navigation, logout link
- **Navbar** — dark mode toggle, notification bell with unread badge, profile name/title
- **Notifications Drawer** — slide-in panel, gradient icons, unread dots, mark all as read
- **Dark Mode** — moon/sun toggle, persisted across all pages
- **Toast Notifications** — success, error, info variants
- **Modals** — approve, reject, assign, update progress, resolve confirmation
- **Before/After Photo Section** — shell built; after-upload logic pending

---

## Component 2 — Citizen Mobile App (Flutter)

### Authentication
- Phone number entry with `+63` prefix and live formatter
- OTP screen — 6 individual digit boxes, 60s resend timer *(currently simulated)*
- Registration — full name, email (optional), home barangay dropdown, 6-digit PIN (create + confirm)
- PIN is the citizen's password — numeric, obscured, confirmed on registration
- Logout clears in-memory session

### Home Dashboard
- Time-based greeting (Good morning/afternoon/evening)
- Report a Concern CTA banner
- 4 stat tiles: Pending Validation, In Progress, Resolved, Total Reports
- Mini interactive community map preview
- Latest city announcements list

### Report Concern Flow (5 Steps)
Animated wizard — data passed via route arguments.

| Step | Screen | What it does |
|---|---|---|
| 1 | Category | Choose Infrastructure or Environment |
| 2 | Concern | Choose one of 7 concern types (see categories below) |
| 3 | Photo | Take or choose photo *(simulated in prototype)* |
| 4 | Location | GPS or map tap + auto Nominatim reverse geocoding + address fields + landmark + severity |
| 5 | Review | Read-only summary, confirmation checkbox, submit |

After submit: reference number screen (`CW-YYYY-#####`), copyable, timestamp.

### My Reports
- Full list of citizen's own submitted reports
- Filter tabs: All · Pending · In Progress · Resolved
- Search across reference number and concern type
- Each card: category badge, concern, barangay, status chip, severity, date
- Taps to Track Report detail view

### Track Report
- Reference number, category, severity chips, status badge
- 5-step visual progress timeline (Submitted → Pending Validation → Assigned to Office → In Progress → Resolved)
- Activity log — timestamped entries for every status change
- Assigned government office card
- View on Map button → Private Map screen

### Community Map
- Full-screen interactive OpenStreetMap
- Colour-coded pins: Amber (Infrastructure), Green (Environment), Purple (Others)
- Filter by category
- Tap pin → mini detail card (concern, barangay, status)
- Only validated reports are visible

### Notifications
- Grouped: Today · Yesterday · Earlier
- Unread green dot indicator
- Mark All Read button
- Events: concern submitted, status changes

### Profile
- User card: initials avatar, name, phone, barangay
- Stats: Total Concerns, Resolved, Pending
- Menu: Personal Info, Change PIN, Notification Settings, Privacy, About, Help
- Log Out button

---

## Component 3 — Laravel Backend API

### Citizen Authentication (`/api/mobile/auth/`)
- `POST send-otp` — Generates 6-digit OTP, stores with 5-min expiry. OTP returned in response (dev mode — no SMS yet)
- `POST verify-otp` — Validates OTP, returns `{ token, isNewUser }`
- `POST register` — Creates citizen account (phone, name, barangay, PIN hash), returns Sanctum token
- `POST logout` — Revokes current token
- `GET me` — Returns citizen profile + total/resolved report counts

### Citizen Reports (`/api/mobile/reports/`)
- `GET /` — Citizen's own reports. Filterable by `?status=`
- `POST /` — Submit new report (multipart — supports photo upload)
- `GET /community` — All validated reports for community map (public pins)
- `GET /{id}` — Full report detail with activity log

### Citizen Notifications (`/api/mobile/notifications/`)
- `GET /` — Notifications list with unread count
- `POST /mark-all-read` — Mark all as read
- `POST /{id}/read` — Mark one as read

### Public Endpoints (no auth)
- `GET /api/mobile/announcements` — City announcements
- `GET /api/ping` — Health check

### Admin Report Management (`/api/admin/citizen-reports/`)
- List with filters, show detail, summary stats, map pins
- Validate (approve → makes report public on community map)
- Assign to office
- Update status with optional notes

### Admin Offices + Announcements (`/api/admin/`)
- Full CRUD for government offices
- Full CRUD for city announcements

### Legacy Admin API (`/api/`)
- Email + password login → Sanctum token
- Reports CRUD, analytics endpoints, admin notifications

### Automatic Report Events (via `CitizenReport::transitionTo()`)
Every status change automatically:
1. Updates `status` column on `citizen_reports`
2. Creates a `ReportActivity` entry (visible in Flutter activity log)
3. Sends a `CitizenNotification` to the report owner

### Reference Number Format
```
CW-{YEAR}-{5-digit-padded-sequence}
Example: CW-2026-00125
```
Generated server-side — collision-safe sequential counter per year.

---

## Report Categories

**Infrastructure → City Engineering Office (CEO)**

| Label | Icon | Description |
|---|---|---|
| Road Repair | `add_road_rounded` | Potholes, damaged road surface |
| Road Graveling | `terrain_rounded` | Unpaved or gravel road needs improvement |
| Streetlight / Light Pole Concern | `light_rounded` | Broken, flickering, or missing streetlight |
| Blocked Canal | `water_damage_rounded` | Canal blocked by debris or sediment |
| Others | `more_horiz_rounded` | Other infrastructure concerns |

**Environmental → CENRO**

| Label | Icon | Description |
|---|---|---|
| Illegal Dumping | `delete_sweep_rounded` | Waste illegally dumped in public areas |
| Garbage Collection | `recycling_rounded` | Missed or irregular garbage collection |

---

## Report Status Flow

```
Citizen Submits → Pending Validation → Assigned to Office → In Progress → Resolved
```

| Status | Color (Web) | Color (App) | Who Sets It |
|---|---|---|---|
| Pending Validation | Amber `#F59E0B` | Amber `#F59E0B` | Auto on submit |
| Assigned to Office | Blue `#1A56DB` | Blue `#2563EB` | Super Admin |
| In Progress | Orange `#F97316` | Orange `#EA580C` | CEO / CENRO |
| Resolved | Green `#10B981` | Green `#16A34A` | CEO / CENRO |

---

## Government Offices (Seeded in Laravel)

| Abbreviation | Full Name | Handles |
|---|---|---|
| CEO | City Engineering Office | Infrastructure |
| CENRO | City Environment and Natural Resources Office | Environment |
| CPWD | City Public Works Department | Infrastructure + Environment |
| CDRRMO | City Disaster Risk Reduction Office | Infrastructure + Environment |
| CVO | City Veterinary Office | Others |

---

## Database Tables (Laravel Migrations)

| Table | Purpose |
|---|---|
| `users` | Admin staff accounts |
| `citizens` | Mobile app user accounts |
| `otp_codes` | OTP verification codes (5-min expiry) |
| `government_offices` | Office records |
| `citizen_reports` | Reports submitted from Flutter app |
| `report_activities` | Status change activity log |
| `citizen_notifications` | Per-citizen notifications |
| `announcements` | City announcements |

---

## Technology Stack Summary

| Layer | Technology |
|---|---|
| Admin Web Frontend | HTML5, CSS3, Vanilla JavaScript |
| Admin Maps | Leaflet.js + OpenStreetMap |
| Admin Charts | Chart.js |
| Admin Icons | Material Symbols |
| Citizen Mobile App | Flutter / Dart SDK ^3.12.2 |
| App Maps | flutter_map ^8.1.1 + OpenStreetMap |
| App Fonts | Google Fonts (Inter + Roboto Mono) |
| App HTTP | http ^1.2.2 (Nominatim geocoding) |
| Backend Framework | Laravel 12 |
| Backend Auth | Laravel Sanctum (multi-guard: staff + citizens) |
| Backend Language | PHP |
| Database | MySQL |
| ORM | Eloquent (Laravel built-in) |

---

## Pending Features (Integration Phase)

| Feature | Component | Status |
|---|---|---|
| Flutter ↔ Laravel auth wiring | Flutter + Laravel | 🔲 Not started |
| Flutter ↔ Laravel report submit | Flutter + Laravel | 🔲 Not started |
| Real photo upload (image_picker) | Flutter | 🔲 Not started |
| Real GPS (geolocator) | Flutter | 🔲 Not started |
| Secure token storage (flutter_secure_storage) | Flutter | 🔲 Not started |
| Web admin ↔ Laravel API (replace static JSON) | Web + Laravel | 🔲 Not started |
| After photo upload wiring | Web + Laravel | 🔲 Not started |
| Office settings pages (CEO + CENRO) | Web | 🔲 Not started |
| SMS OTP (real provider) | Laravel | 🔲 Not started (OTP in response for dev) |

---

## Known Prototype Limitations (By Design)

- Flutter app: no backend connection — all data in-memory, resets on restart
- Web admin: no backend — all data is static JSON or inline JS arrays
- Web auth: localStorage only — no real session/token
- Photo upload: UI shell only — no real file handling yet
- GPS: simulated at Digos City centre `6.7498, 125.3572`
- OTP: simulated with `Future.delayed` — no real SMS sent

---

## Project Info

| | |
|---|---|
| **System** | CIVILWATCH — Geotagged Community Incident Reporting System |
| **Location** | Digos City, Davao del Sur |
| **University** | University of Mindanao — Digos Branch |
| **Program** | BS Information Technology |
| **Year** | 2026 |
| **Proponents** | Renz Justine Y. Borinaga, Jhon Carlo Mag-Usara, Lawrence Roy P. Sereno |
| **Adviser** | Cyvil Dave Dasargo, MIT |
