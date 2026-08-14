# CIVILWATCH — Production Implementation Prompt

> Use this as your master prompt when starting a new session focused on backend integration or production work.
> Last Updated: August 13, 2026

---

## The Prompt

```
I have a fully built capstone system called CIVILWATCH —
a Geotagged Community Incident Reporting System for Digos City.
The project has THREE components that are all co-located in one workspace.

─────────────────────────────────────────────────────────
WORKSPACE LOCATION
─────────────────────────────────────────────────────────
c:\Users\User\Downloads\SERENO\APP-WITH-WEB\

├── prc/
│   ├── civ-main/          Flutter citizen mobile app
│   ├── laravel/           Laravel 12 backend API
│   └── [web admin files]  HTML/CSS/JS admin dashboard

─────────────────────────────────────────────────────────
COMPONENT 1 — ADMIN WEB DASHBOARD (Complete Prototype)
─────────────────────────────────────────────────────────
Location: prc/ (HTML/CSS/JS files)
Stack: HTML5 + CSS3 + Vanilla JavaScript + Leaflet.js + Chart.js

27 pages across 3 portals:
- Super Admin (11 pages): login, dashboard, pending-reports,
  report-details, assign-office, monitoring, gis-map, analytics,
  resolved-reports, users, settings
- CEO Office (8 pages): offices/ceo/
- CENRO Office (8 pages): offices/cenro/

Current limitations (prototype):
- No backend — all data is static JSON or inline JS arrays
- Auth is localStorage only (role stored as cw_role)
- No data persistence — refresh resets all state

─────────────────────────────────────────────────────────
COMPONENT 2 — CITIZEN MOBILE APP (Complete Prototype)
─────────────────────────────────────────────────────────
Location: prc/civ-main/
Stack: Flutter / Dart SDK ^3.12.2

18 screens built:
- Auth: splash, login (phone+OTP), OTP verify, register (name, barangay, 6-digit PIN)
- Home: dashboard with stats, map preview, announcements
- Report flow (5 steps): category → concern → photo → location (GPS + Nominatim) → review
- My Reports, Track Report, Private Map, Community Map
- Notifications, Profile

Current limitations (prototype):
- ZERO backend connection — all data in-memory via AppState singleton
- OTP is simulated with Future.delayed — no real SMS
- Photo is a boolean flag — no real image_picker
- GPS is simulated at fixed coordinates — no real geolocator
- Resets completely on restart

Dependencies in pubspec.yaml:
- flutter_map ^8.1.1 (maps)
- latlong2 ^0.9.1
- google_fonts ^6.2.1
- http ^1.2.2 (Nominatim geocoding only — real HTTP not wired to Laravel yet)
- intl ^0.19.0
- url_launcher ^6.3.1

─────────────────────────────────────────────────────────
COMPONENT 3 — LARAVEL BACKEND (Fully Built, Needs DB Setup)
─────────────────────────────────────────────────────────
Location: prc/laravel/
Stack: Laravel 12, PHP, MySQL, Sanctum (multi-guard)

Two user systems running side by side:
  Staff/Admin: users table, email+password, auth:sanctum guard
  Citizens:    citizens table, phone+PIN, auth:citizen guard

Database migrations (all created):
  citizens, otp_codes, government_offices, citizen_reports,
  report_activities, citizen_notifications, announcements

API routes:
  GET  /api/ping                              Health check
  POST /api/mobile/auth/send-otp              Generate OTP (returned in response)
  POST /api/mobile/auth/verify-otp            Verify OTP → get Sanctum token
  POST /api/mobile/auth/register              Register citizen
  POST /api/mobile/auth/logout                Revoke token
  GET  /api/mobile/auth/me                    Citizen profile
  GET  /api/mobile/reports                    Citizen's own reports
  POST /api/mobile/reports                    Submit report (multipart)
  GET  /api/mobile/reports/community          Validated reports for community map
  GET  /api/mobile/reports/{id}               Report detail + activity log
  GET  /api/mobile/notifications              Citizen notifications
  POST /api/mobile/notifications/mark-all-read
  POST /api/mobile/notifications/{id}/read
  GET  /api/mobile/announcements              Public announcements (no auth)
  GET/POST/PUT/DELETE /api/admin/citizen-reports/{...}
  GET/POST/PUT/DELETE /api/admin/offices
  GET/POST/PUT/DELETE /api/admin/announcements
  POST /api/login                             Admin email+password login
  GET/POST/PUT/DELETE /api/reports/{...}      Legacy admin reports
  GET  /api/analytics/{...}                   Analytics endpoints

Seeders:
  DatabaseSeeder → super admin (admin@civilwatch.ph / Admin@2026!)
  GovernmentOfficeSeeder → CEO, CENRO, CPWD, CDRRMO, CVO
  AnnouncementSeeder → 2 sample announcements

API response shapes match Flutter models EXACTLY:
  CitizenReport  → Flutter IncidentReport model
  ReportActivity → Flutter ActivityEntry model
  CitizenNotification → Flutter AppNotification model
  Announcement   → Flutter Announcement model
  GovernmentOffice → Flutter GovernmentOffice model

─────────────────────────────────────────────────────────
CURRENT INTEGRATION STATUS
─────────────────────────────────────────────────────────
Flutter ↔ Laravel:  NOT YET CONNECTED (0%)
Web Admin ↔ Laravel: NOT YET CONNECTED (0%)

The immediate goal is to:
1. Get Laravel running (setup .env, migrate, seed, serve)
2. Connect Flutter app to Laravel API (replace all mock/in-memory calls)
3. Then connect web admin to Laravel API (replace static JSON)

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
Submitted → Pending Validation → Assigned to Office
→ In Progress → Resolved

Each status change via CitizenReport::transitionTo() auto-creates:
  1. ReportActivity log entry
  2. CitizenNotification to report owner

─────────────────────────────────────────────────────────
DESIGN TOKENS
─────────────────────────────────────────────────────────
Web Admin:
  Super Admin / CEO primary: #1A56DB
  CENRO primary:             #10B981
  Pending:                   #F59E0B
  In Progress:               #F97316
  Resolved:                  #10B981
  Page background:           #F9FAFB
  Dark background:           #161B27

Flutter App:
  Primary green:             #1B5E20
  Navy:                      #0D2137
  Background:                #F8FAFC
  Pending:                   #F59E0B
  In Progress:               #EA580C
  Resolved:                  #16A34A
  Assigned:                  #2563EB

─────────────────────────────────────────────────────────
PROJECT INFO
─────────────────────────────────────────────────────────
System:     CIVILWATCH — Geotagged Community Incident Reporting System
Location:   Digos City, Davao del Sur
University: University of Mindanao — Digos Branch
Program:    BS Information Technology
Year:       2026
Proponents: Renz Justine Y. Borinaga,
            Jhon Carlo Mag-Usara,
            Lawrence Roy P. Sereno
Adviser:    Cyvil Dave Dasargo, MIT

─────────────────────────────────────────────────────────
SCOPE — DO NOT ADD THESE
─────────────────────────────────────────────────────────
❌ AI image verification
❌ Duplicate detection
❌ Fire incidents / disaster prediction
❌ Crime reporting / Lost and Found
❌ Emergency response / Hazard forecasting

─────────────────────────────────────────────────────────
INSTRUCTIONS FOR YOU
─────────────────────────────────────────────────────────
- Always read existing files before editing them
- Match existing code style — no new libraries unless necessary
- For Flutter: keep all colors in app_colors.dart, routes in app_routes.dart
- For Laravel: follow existing controller/model patterns in the codebase
- For Web: keep CSS in separate CSS files, JS in app.js/utils.js or inline
- Build and test each step before moving to the next
- The backend is already fully built — focus on wiring, not rebuilding
- Refer to SESSION_PROGRESS.md for the numbered task list
```

---

## Laravel Setup Commands (Run Once)

```bash
# In prc/laravel/

# 1. Copy environment file
copy .env.example .env

# 2. Edit .env — set these values:
#    DB_CONNECTION=mysql
#    DB_HOST=127.0.0.1
#    DB_PORT=3306
#    DB_DATABASE=civilwatch
#    DB_USERNAME=root
#    DB_PASSWORD=your_mysql_password

# 3. Install dependencies
composer install

# 4. Generate app key
php artisan key:generate

# 5. Run migrations
php artisan migrate

# 6. Seed default data
php artisan db:seed

# 7. Link storage for photo uploads
php artisan storage:link

# 8. Start development server
php artisan serve
# → http://127.0.0.1:8000

# 9. Test health check
# GET http://127.0.0.1:8000/api/ping
# Expected: { "success": true, "message": "CivilWatch API is running." }
```

---

## Flutter Integration — Key Files to Edit

```
lib/
├── core/
│   ├── constants/
│   │   └── api_constants.dart     ← CREATE THIS: base URL + endpoint paths
│   └── state/
│       └── app_state.dart         ← Replace in-memory data with API calls
│
├── services/
│   ├── auth_service.dart          ← Wire to /api/mobile/auth/*
│   ├── report_service.dart        ← Wire to /api/mobile/reports/*
│   └── notification_service.dart  ← Wire to /api/mobile/notifications/*
│
└── screens/
    ├── auth/login_screen.dart     ← Wire send-otp
    ├── auth/otp_screen.dart       ← Wire verify-otp, get token
    ├── auth/register_screen.dart  ← Wire register
    ├── report/report_review.dart  ← Wire submit report
    ├── my_reports/...             ← Wire list from API
    ├── track_report/...           ← Wire show from API
    ├── community_map/...          ← Wire community endpoint
    └── notifications/...          ← Wire notifications endpoint
```

### New Packages to Add to pubspec.yaml

```yaml
dependencies:
  flutter_secure_storage: ^9.2.2   # Store Sanctum token securely
  image_picker: ^1.1.2             # Real photo capture
  geolocator: ^13.0.2              # Real GPS
  permission_handler: ^11.3.1      # Camera + location permissions
```

---

## API Base URL by Environment

| Environment | Base URL |
|---|---|
| Android Emulator | `http://10.0.2.2:8000/api/mobile` |
| iOS Simulator | `http://127.0.0.1:8000/api/mobile` |
| Real device (same WiFi) | `http://[your-local-IP]:8000/api/mobile` |
| Production | `https://your-domain.com/api/mobile` |

---

## Recommended Dev Tools

| Tool | Purpose |
|---|---|
| Postman | Test all API endpoints before wiring Flutter |
| TablePlus or DBeaver | MySQL GUI to verify data during dev |
| Flutter DevTools | Debug app state + network requests |
| Laravel Telescope | Optional — debug API requests in browser |

---

*CIVILWATCH — University of Mindanao Digos Branch | BS Information Technology Capstone 2026*
