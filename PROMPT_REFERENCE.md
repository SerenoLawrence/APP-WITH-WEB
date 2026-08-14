# CIVILWATCH — Session Prompt Reference

> Paste this at the start of any new Kiro/AI session so you never have to re-explain the project.
> Last Updated: August 13, 2026

---

## MASTER CONTEXT PROMPT

Copy and paste the block below at the start of every new session:

---

```
You are helping me build and maintain my capstone project CIVILWATCH.

─────────────────────────────────────────────────────────
PROJECT TITLE
─────────────────────────────────────────────────────────
CIVILWATCH: A Geotagged Community Infrastructure and
Environmental Incident Reporting, Management, and
Monitoring System for Digos City.

─────────────────────────────────────────────────────────
WORKSPACE
─────────────────────────────────────────────────────────
c:\Users\User\Downloads\SERENO\APP-WITH-WEB\

All three components are inside prc/:
  prc/civ-main/    ← Flutter citizen mobile app
  prc/laravel/     ← Laravel 12 backend API
  prc/[web files]  ← HTML/CSS/JS admin dashboard

─────────────────────────────────────────────────────────
WHAT HAS BEEN BUILT
─────────────────────────────────────────────────────────

COMPONENT 1 — Admin Web Dashboard (Complete UI Prototype)
  Stack: HTML5 + CSS3 + Vanilla JavaScript + Leaflet.js + Chart.js
  Pages: 27 (11 Super Admin + 8 CEO + 8 CENRO)
  Status: 100% prototype UI — no backend connected yet
  Auth: localStorage (cw_role, cw_name, cw_title)

  Demo login:
    admin / admin123  → Super Admin
    ceo   / ceo123    → City Engineering Office
    cenro / cenro123  → CENRO

COMPONENT 2 — Citizen Mobile App (Complete UI Prototype)
  Stack: Flutter / Dart SDK ^3.12.2
  Screens: 18 (auth, home, report flow, my reports,
           track report, map, notifications, profile)
  Status: 100% screens built — ZERO backend connection
  All data is in-memory (AppState singleton), resets on restart
  The only real HTTP call is Nominatim reverse geocoding

COMPONENT 3 — Laravel Backend (Fully Built, Needs DB Setup)
  Stack: Laravel 12, PHP, MySQL, Sanctum (multi-guard)
  Status: 100% API built — needs composer install + migrate + serve
  Two auth guards:
    auth:sanctum → staff (email+password) → /api/* and /admin/*
    auth:citizen → citizens (phone+OTP+PIN) → /api/mobile/*
  All API response shapes match Flutter models exactly

─────────────────────────────────────────────────────────
INTEGRATION STATUS
─────────────────────────────────────────────────────────
Flutter ↔ Laravel:    NOT YET CONNECTED
Web Admin ↔ Laravel:  NOT YET CONNECTED

Current phase: Connecting Flutter app to Laravel backend.
Check SESSION_PROGRESS.md for the numbered task list.

─────────────────────────────────────────────────────────
LARAVEL QUICK START
─────────────────────────────────────────────────────────
cd prc/laravel
copy .env.example .env   ← set DB_* credentials
composer install
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan serve         ← runs at http://127.0.0.1:8000

Admin login after seeding:
  Email:    admin@civilwatch.ph
  Password: Admin@2026!

Web panel: http://127.0.0.1:8000/admin/login
API base:  http://127.0.0.1:8000/api/
Health:    GET /api/ping → { "success": true }

─────────────────────────────────────────────────────────
FLUTTER API BASE URLS
─────────────────────────────────────────────────────────
Android emulator: http://10.0.2.2:8000/api/mobile
iOS simulator:    http://127.0.0.1:8000/api/mobile
Real device:      http://[local-IP]:8000/api/mobile

─────────────────────────────────────────────────────────
KEY API ENDPOINTS (Mobile)
─────────────────────────────────────────────────────────
POST /api/mobile/auth/send-otp          No auth — returns OTP in response
POST /api/mobile/auth/verify-otp        No auth — returns { token, isNewUser }
POST /api/mobile/auth/register          No auth — returns token
GET  /api/mobile/auth/me                Bearer token required
POST /api/mobile/reports                Submit report (multipart)
GET  /api/mobile/reports                My reports list
GET  /api/mobile/reports/community      Community map reports (validated)
GET  /api/mobile/reports/{id}           Report detail + activity log
GET  /api/mobile/notifications          Notifications list
POST /api/mobile/notifications/mark-all-read
GET  /api/mobile/announcements          Public — no auth required

─────────────────────────────────────────────────────────
REPORT CATEGORIES
─────────────────────────────────────────────────────────
Infrastructure (→ CEO):
  Road Repair, Road Graveling,
  Streetlight / Light Pole Concern, Blocked Canal, Others

Environmental (→ CENRO):
  Illegal Dumping, Garbage Collection

─────────────────────────────────────────────────────────
REPORT STATUS FLOW
─────────────────────────────────────────────────────────
Pending Validation → Assigned to Office → In Progress → Resolved

Status colors:
  Pending:    Amber  #F59E0B
  Assigned:   Blue   #1A56DB (web) / #2563EB (app)
  In Progress:Orange #F97316 (web) / #EA580C (app)
  Resolved:   Green  #10B981 (web) / #16A34A (app)

─────────────────────────────────────────────────────────
DESIGN TOKENS — WEB ADMIN
─────────────────────────────────────────────────────────
Primary (Admin/CEO):   #1A56DB
CENRO primary:         #10B981
Page background:       #F9FAFB
Card background:       #FFFFFF
Border radius (cards): 16px
Dark background:       #161B27
Dark card:             #1E2330

─────────────────────────────────────────────────────────
DESIGN TOKENS — FLUTTER APP
─────────────────────────────────────────────────────────
Primary green:   #1B5E20
Navy:            #0D2137
Background:      #F8FAFC
Card:            #FFFFFF
Border radius:   16–20px
Font:            Inter (UI) + Roboto Mono (reference numbers)

─────────────────────────────────────────────────────────
SCOPE — DO NOT ADD
─────────────────────────────────────────────────────────
❌ AI image verification / duplicate detection
❌ Fire, disaster, crime, lost and found
❌ Emergency response / hazard forecasting

─────────────────────────────────────────────────────────
PROJECT INFO
─────────────────────────────────────────────────────────
University: University of Mindanao — Digos Branch
Program:    BS Information Technology
Year:       2026
Proponents: Renz Justine Y. Borinaga,
            Jhon Carlo Mag-Usara,
            Lawrence Roy P. Sereno
Adviser:    Cyvil Dave Dasargo, MIT

─────────────────────────────────────────────────────────
INSTRUCTIONS FOR YOU
─────────────────────────────────────────────────────────
- Always read existing files before editing them
- Match existing code style — no new libraries unless needed
- For Flutter: colors in app_colors.dart, routes in app_routes.dart
- For Laravel: follow existing Controller/Model patterns in the code
- For Web: keep CSS in separate files, JS in app.js/utils.js or inline
- Build and test each step before moving to the next
- The backend is fully built — wire it, don't rebuild it
- Check SESSION_PROGRESS.md for the numbered task list
```

---

## Quick Reference: File Locations

### Flutter App (`prc/civ-main/lib/`)

| What | File |
|---|---|
| API base URL (create this) | `core/constants/api_constants.dart` |
| All color tokens | `core/constants/app_colors.dart` |
| All string constants | `core/constants/app_strings.dart` |
| Named routes | `core/routes/app_routes.dart` |
| Route factory | `core/routes/route_generator.dart` |
| App state (singleton) | `core/state/app_state.dart` |
| Dummy/seed data | `core/utils/dummy_data.dart` |
| Auth service | `services/auth_service.dart` |
| Report service | `services/report_service.dart` |
| Notification service | `services/notification_service.dart` |
| Login screen | `screens/auth/login_screen.dart` |
| OTP screen | `screens/auth/otp_screen.dart` |
| Register screen | `screens/auth/register_screen.dart` |
| Report review (submit) | `screens/report/report_review.dart` |
| My Reports | `screens/my_reports/my_reports_screen.dart` |
| Track Report | `screens/track_report/track_report_screen.dart` |
| Community Map | `screens/community_map/community_map_screen.dart` |
| Notifications | `screens/notifications/notification_screen.dart` |
| Home | `screens/home/home_screen.dart` |
| Profile | `screens/profile/profile_screen.dart` |

### Laravel Backend (`prc/laravel/`)

| What | File |
|---|---|
| All API routes | `routes/api.php` |
| Web panel routes | `routes/web.php` |
| Mobile auth controller | `app/Http/Controllers/Mobile/MobileAuthController.php` |
| Mobile reports controller | `app/Http/Controllers/Mobile/MobileReportController.php` |
| Mobile notifications | `app/Http/Controllers/Mobile/MobileNotificationController.php` |
| Admin report controller | `app/Http/Controllers/Admin/AdminCitizenReportController.php` |
| Citizen model | `app/Models/Citizen.php` |
| CitizenReport model | `app/Models/CitizenReport.php` |
| Auth config (guards) | `config/auth.php` |
| Environment config | `.env` (copy from `.env.example`) |
| Migrations | `database/migrations/` |
| Seeders | `database/seeders/` |

### Web Admin

| What | File |
|---|---|
| Login + role routing | `index.html` |
| Sidebar/navbar (per role) | `assets/js/app.js` |
| Shared CSS tokens | `assets/css/variables.css` |
| Dark mode overrides | `assets/css/global.css` |
| Status badge HTML | `assets/js/utils.js` → `Utils.statusBadge()` |
| CEO report detail | `offices/ceo/report-details.html` |
| CENRO report detail | `offices/cenro/report-details.html` |
| CEO analytics | `offices/ceo/analytics.html` |
| CENRO analytics | `offices/cenro/analytics.html` |

---

## Quick Reference: Credentials

### Web Prototype (static)
| Role | Username | Password |
|---|---|---|
| Super Admin | `admin` | `admin123` |
| CEO | `ceo` | `ceo123` |
| CENRO | `cenro` | `cenro123` |

### Laravel (after seeding)
| Email | Password |
|---|---|
| `admin@civilwatch.ph` | `Admin@2026!` |

---

## Quick Reference: Common Tasks

| Task | How to phrase it |
|---|---|
| Wire a Flutter screen | "Wire [screen] to [endpoint] — replace the mock in [service file]" |
| Fix a Laravel API response | "Fix the response shape in [controller] to match Flutter [model]" |
| Fix a web admin page | "On [page], [describe problem] — keep the same CSS/JS style" |
| Add a new feature | "Add [feature] to [component] — check FEATURES.md for scope" |
| Check next tasks | "What is the next task in SESSION_PROGRESS.md?" |
| Run the backend | "Help me set up and run the Laravel backend in prc/laravel/" |

---

## Pending Work (Summary)

See `SESSION_PROGRESS.md` for the full numbered task list.

**Priority order:**
1. Get Laravel running (setup `.env`, migrate, seed, serve)
2. Wire Flutter auth (send-otp, verify-otp, register)
3. Wire Flutter report submission
4. Wire Flutter My Reports, Track Report, Community Map, Notifications
5. Add `image_picker` (real photo) + `geolocator` (real GPS) to Flutter
6. Connect Web Admin to Laravel API (replace static JSON)

---

*Keep this file. Paste the master prompt block at the top of every new session.*
*All three components are in: prc/ inside the APP-WITH-WEB workspace.*
