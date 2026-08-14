# CIVILWATCH — Project Status

> **Full-Stack Capstone | Flutter + Laravel + HTML/JS**
> Last Updated: August 13, 2026

---

## Overall Progress

| Component | Status | Notes |
|---|---|---|
| Admin Web Dashboard (HTML/JS) | ✅ Complete | 27 pages, all UI built, static prototype |
| Citizen Mobile App (Flutter) | ✅ Built | All screens done, zero backend connection (in-memory) |
| Laravel Backend API | ✅ Built | All routes, controllers, models, migrations done |
| Flutter ↔ Laravel Integration | 🔲 Not started | Next major phase |
| Web Admin ↔ Laravel Integration | 🔲 Not started | After Flutter integration |
| Real photo upload (image_picker) | 🔲 Not started | Depends on integration |
| Real GPS (geolocator) | 🔲 Not started | Depends on integration |
| SMS OTP (real provider) | 🔲 Not started | Optional — dev uses response-returned OTP |

---

## ✅ Component 1 — Admin Web Dashboard

**Location:** `prc/` (HTML/CSS/JS files)
**Stack:** HTML5 + CSS3 + Vanilla JavaScript + Leaflet.js + Chart.js

### Super Admin (11 pages)
- [x] `index.html` — Login with role-based routing
- [x] `dashboard.html` — Stats, recent reports, Leaflet map, activity feed
- [x] `pending-reports.html` — Validation queue with search + filters
- [x] `report-details.html` — Full detail, approve/reject modals, photo, timeline
- [x] `assign-office.html` — Office cards, priority pills, notes, success modal
- [x] `monitoring.html` — Tab filters, progress tracking, update modal
- [x] `gis-map.html` — Leaflet map with filter chips and detail panel
- [x] `analytics.html` — 5 Chart.js charts, weekly/monthly toggle
- [x] `resolved-reports.html` — Archive with search and filters
- [x] `users.html` — User table, slide-in details panel, Add User modal
- [x] `settings.html` — 7 sections: General, Categories, Offices, Notifications, Security, Logs, About

### CEO Office Pages — `offices/ceo/` (8 pages, Blue theme)
- [x] `dashboard.html`, `reports.html`, `inprogress.html`, `resolved.html`
- [x] `map.html`, `analytics.html`, `report-details.html`
- [x] `settings.html` — Placeholder (coming soon)

### CENRO Office Pages — `offices/cenro/` (8 pages, Green theme)
- [x] `dashboard.html`, `reports.html`, `inprogress.html`, `resolved.html`
- [x] `map.html`, `analytics.html`, `report-details.html`
- [x] `settings.html` — Placeholder (coming soon)

### Shared Components
- [x] Sidebar (collapse/expand, role-aware, logout)
- [x] Navbar (dark mode toggle, notification bell, profile)
- [x] Notifications drawer (slide-in, unread dots, mark all read)
- [x] Dark mode (moon/sun toggle, persisted via localStorage)
- [x] Toast notifications (success / error / info)
- [x] Modals (approve, reject, assign, update, resolve)
- [x] Before/After photo section shell

### Web Dashboard Pending (non-blocking)
| # | Task | Priority |
|---|---|---|
| 1 | After photo upload (FileReader preview) | High |
| 2 | CEO + CENRO Settings pages (currently placeholder) | High |
| 3 | Resolved rows → report-details link | Medium |
| 4 | Dashboard recent rows clickable | Medium |
| 5 | Analytics from live DB data | Medium |
| 6 | Functional pagination | Low |
| 7 | Export Reports (CSV/PDF) | Low |

---

## ✅ Component 2 — Citizen Mobile App (Flutter)

**Location:** `prc/civ-main/`
**Stack:** Flutter / Dart, flutter_map, OpenStreetMap, http (Nominatim only)
**Backend Status:** ZERO — 100% in-memory prototype

### Screens Built
- [x] Splash screen
- [x] Login (phone number + OTP flow — simulated)
- [x] OTP verification (simulated, 60s timer)
- [x] Registration (name, email optional, barangay, 6-digit PIN)
- [x] Home dashboard (greeting, stat tiles, map preview, announcements)
- [x] Report flow — 5 steps: Category → Concern → Photo → Location → Review
- [x] Report submitted (reference number, copy button)
- [x] My Reports (list, filter tabs, search)
- [x] Track Report (detail, 5-step timeline, activity log, office card)
- [x] Private Map (report GPS pin)
- [x] Community Map (all validated reports, category filter)
- [x] Notifications (grouped, mark read)
- [x] Profile (stats, menu, logout)

### Flutter App Pending (integration phase)
| # | Task | Notes |
|---|---|---|
| 1 | Add `ApiConstants` base URL | `lib/core/constants/api_constants.dart` |
| 2 | Wire Login → `POST /api/mobile/auth/send-otp` | Replace `Future.delayed` mock |
| 3 | Wire OTP verify → `POST /api/mobile/auth/verify-otp` | Gets real Sanctum token |
| 4 | Wire Register → `POST /api/mobile/auth/register` | Save token to secure storage |
| 5 | Wire report submit → `POST /api/mobile/reports` | Multipart with photo |
| 6 | Wire My Reports → `GET /api/mobile/reports` | Replace AppState list |
| 7 | Wire Track Report → `GET /api/mobile/reports/{id}` | Real activity log |
| 8 | Wire Community Map → `GET /api/mobile/reports/community` | Real validated pins |
| 9 | Wire Notifications → `GET /api/mobile/notifications` | Real DB notifications |
| 10 | Add `image_picker` for real photo capture | `pubspec.yaml` + Step 3 screen |
| 11 | Add `geolocator` + `permission_handler` for real GPS | `pubspec.yaml` + Step 4 screen |
| 12 | Add `flutter_secure_storage` for token persistence | Replace in-memory auth |

---

## ✅ Component 3 — Laravel Backend API

**Location:** `prc/laravel/`
**Stack:** Laravel 12, PHP, MySQL, Sanctum (multi-guard)

### Database Migrations (all created)
- [x] `users` — Admin staff (super_admin, ceo, cenro)
- [x] `citizens` — Mobile app users (phone + PIN)
- [x] `otp_codes` — 6-digit OTP with 5-min expiry
- [x] `government_offices` — CEO, CENRO, CPWD, CDRRMO, CVO
- [x] `citizen_reports` — Reports submitted from Flutter app
- [x] `report_activities` — Activity/timeline log per report
- [x] `citizen_notifications` — Per-citizen push-style notifications
- [x] `announcements` — City announcements shown in Flutter app

### Models (all created)
- [x] `User`, `Citizen`, `OtpCode`
- [x] `GovernmentOffice`, `CitizenReport`
- [x] `ReportActivity`, `CitizenNotification`, `Announcement`

### Controllers (all created)
- [x] `MobileAuthController` — OTP, register, logout, me
- [x] `MobileReportController` — Submit, list, community, show
- [x] `MobileNotificationController` — List, mark read
- [x] `MobileAnnouncementController` — Public announcements
- [x] `AdminCitizenReportController` — List, show, validate, assign, status, map, summary
- [x] `AdminOfficeController` — CRUD for government offices
- [x] `AdminAnnouncementController` — CRUD for announcements
- [x] `AdminWebController` — Blade web panel routes

### API Routes (all wired)
- [x] `/api/ping` — Health check
- [x] `/api/mobile/auth/*` — Citizen auth
- [x] `/api/mobile/reports/*` — Citizen reports
- [x] `/api/mobile/notifications/*` — Citizen notifications
- [x] `/api/mobile/announcements` — Public announcements
- [x] `/api/admin/*` — Admin report management
- [x] `/api/login`, `/api/user`, `/api/logout` — Legacy admin auth
- [x] `/api/reports/*` — Legacy admin report CRUD
- [x] `/api/analytics/*` — Analytics endpoints
- [x] `/api/notifications/*` — Admin notifications

### Blade Web Panel (all created)
- [x] `admin/login.blade.php`
- [x] `admin/dashboard.blade.php`
- [x] `admin/citizen-reports/index.blade.php` + `show.blade.php`
- [x] `admin/map.blade.php`
- [x] `admin/offices/index.blade.php`
- [x] `admin/announcements/index.blade.php`

### Seeders
- [x] `GovernmentOfficeSeeder` — 5 offices (CEO, CENRO, CPWD, CDRRMO, CVO)
- [x] `AnnouncementSeeder` — 2 sample announcements
- [x] `DatabaseSeeder` — Super admin + calls both seeders

### Backend Setup Pending
| # | Task | Notes |
|---|---|---|
| 1 | Create `.env` from `.env.example` | Set MySQL credentials |
| 2 | Run `composer install` | Install PHP dependencies |
| 3 | Run `php artisan migrate` | Create all tables |
| 4 | Run `php artisan db:seed` | Seed default data |
| 5 | Run `php artisan storage:link` | Enable photo uploads |
| 6 | Run `php artisan serve` | Start dev server |

---

## 🔲 Integration Phase (Next Major Work)

This is the main remaining task. The backend is 100% built to match the Flutter models exactly.

### Step-by-step Integration Plan

```
Phase 1 — Backend Running
  ↓ Create .env, run migrations, seed, serve
  ↓ Test: GET /api/ping → success

Phase 2 — Flutter Auth
  ↓ Add ApiConstants.baseUrl to Flutter
  ↓ Wire send-otp, verify-otp, register
  ↓ Store Sanctum token securely

Phase 3 — Flutter Reports
  ↓ Wire submit report (POST /api/mobile/reports)
  ↓ Wire My Reports list (GET /api/mobile/reports)
  ↓ Wire Track Report detail (GET /api/mobile/reports/{id})

Phase 4 — Flutter Notifications + Map
  ↓ Wire notifications (GET /api/mobile/notifications)
  ↓ Wire community map (GET /api/mobile/reports/community)

Phase 5 — Web Admin → Laravel API
  ↓ Replace static JSON fetches with fetch() to /api/*
  ↓ Replace localStorage auth with real Sanctum token

Phase 6 — Real Device Features
  ↓ Add image_picker for photo capture
  ↓ Add geolocator for real GPS
  ↓ Wire photo upload (multipart form)
```

---

## 📁 Complete File Map

```
APP-WITH-WEB/
├── prc/
│   ├── civ-main/              Flutter app (27 screens, 0% backend)
│   ├── laravel/               Laravel backend (100% built, needs DB setup)
│   └── [web admin files]      HTML/JS admin (100% prototype UI)
│
├── README.md                  Full project overview + quick start
├── PROJECT_STATUS.md          This file
├── FEATURES.md                Full feature list
├── FINAL_STATUS.md            Build completion per component
├── SESSION_PROGRESS.md        Session log + next tasks
├── SYSTEM_DESIGN.md           Architecture, ERD, DFD, use cases
├── PRODUCTION_PROMPT.md       Prompt for implementation sessions
├── PROMPT_REFERENCE.md        Master context for new sessions
└── civilwatch.sql             Database schema reference
```

---

## 🔐 Credentials Reference

### Web Prototype (localStorage — static)
| Role | Username | Password |
|---|---|---|
| Super Admin | `admin` | `admin123` |
| CEO | `ceo` | `ceo123` |
| CENRO | `cenro` | `cenro123` |

### Laravel Backend (after seeding)
| Email | Password | Role |
|---|---|---|
| `admin@civilwatch.ph` | `Admin@2026!` | super_admin |

---

*CIVILWATCH — University of Mindanao Digos Branch | BS Information Technology Capstone 2026*
