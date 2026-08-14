# CIVILWATCH — Session Progress & Next Tasks

> Last Updated: August 13, 2026
> Context file for continuing development in the next session.

---

## Current Project State

All three components are built and co-located in one workspace:

| Component | Location | Status |
|---|---|---|
| Admin Web Dashboard | `prc/` (HTML/CSS/JS) | ✅ Complete prototype (27 pages) |
| Citizen Mobile App | `prc/civ-main/` | ✅ Complete prototype (18 screens, 0% backend) |
| Laravel Backend API | `prc/laravel/` | ✅ Fully built (needs DB setup to run) |

The three components are now in **one repository** (`APP-WITH-WEB`). Previous sessions had them separate. The web admin and Flutter app were already complete as prototypes. The Laravel backend was built to serve both.

---

## ✅ Completed This Session

### 1. Project Consolidation
- All three components (`web admin`, `civ-main Flutter app`, `laravel backend`) are now in one workspace under `prc/`
- All top-level documentation MDs updated to reflect the full-stack state

### 2. All MD Files Updated (August 13, 2026)

| File | What Changed |
|---|---|
| `README.md` | Full rewrite — project overview, folder structure, quick start, all API endpoints |
| `PROJECT_STATUS.md` | Full rewrite — all three components with detailed task checklists |
| `FEATURES.md` | Full rewrite — features across web admin, Flutter app, and Laravel backend |
| `FINAL_STATUS.md` | Full rewrite — build completion per component, remaining tasks numbered |
| `SESSION_PROGRESS.md` | This file — current state and next tasks |
| `SYSTEM_DESIGN.md` | Updated — actual stack (Laravel + Flutter, not Node.js) |
| `PRODUCTION_PROMPT.md` | Updated — actual stack reflected in prompt |
| `PROMPT_REFERENCE.md` | Updated — master context prompt reflects full-stack state |

### 3. Laravel Backend — What Was Already Built (Previous Session)

The backend was fully scaffolded with:
- 7 database migrations (citizens, otp_codes, government_offices, citizen_reports, report_activities, citizen_notifications, announcements)
- 8 Eloquent models with API response methods matching Flutter models exactly
- All mobile API routes: `/api/mobile/auth/*`, `/api/mobile/reports/*`, `/api/mobile/notifications/*`
- All admin API routes: `/api/admin/*`
- Blade web panel views: login, dashboard, citizen-reports, map, offices, announcements
- Seeders: GovernmentOfficeSeeder, AnnouncementSeeder, DatabaseSeeder (admin account)
- Multi-guard Sanctum config: `citizen` guard (phone+PIN) + `sanctum` guard (email+password)
- OTP system: generates code, stores in DB, returns in response (no SMS provider needed for dev)
- `CitizenReport::transitionTo()` — status change auto-creates activity log + citizen notification

---

## 🔲 Next Tasks (Priority Order)

### PHASE 1 — Get the Backend Running (Do This First)

| # | Task | Command / Action |
|---|---|---|
| 1 | Create `.env` from example | `copy .env.example .env` in `prc/laravel/` |
| 2 | Set MySQL credentials in `.env` | Edit `DB_*` variables |
| 3 | Install PHP dependencies | `composer install` |
| 4 | Generate app key | `php artisan key:generate` |
| 5 | Run migrations | `php artisan migrate` |
| 6 | Seed default data | `php artisan db:seed` |
| 7 | Link storage | `php artisan storage:link` |
| 8 | Start server | `php artisan serve` → `http://127.0.0.1:8000` |
| 9 | Test health check | `GET /api/ping` → `{ "success": true }` |

### PHASE 2 — Flutter Auth Integration

| # | Task | File(s) |
|---|---|---|
| 10 | Create `ApiConstants` with base URL | `lib/core/constants/api_constants.dart` |
| 11 | Add `flutter_secure_storage` to pubspec | `pubspec.yaml` |
| 12 | Wire `POST /api/mobile/auth/send-otp` | `auth/login_screen.dart` + `auth_service.dart` |
| 13 | Wire `POST /api/mobile/auth/verify-otp` | `auth/otp_screen.dart` + `auth_service.dart` |
| 14 | Wire `POST /api/mobile/auth/register` | `auth/register_screen.dart` + `auth_service.dart` |
| 15 | Store returned Sanctum token securely | `auth_service.dart` |
| 16 | Wire `GET /api/mobile/auth/me` for profile | `profile/profile_screen.dart` |

### PHASE 3 — Flutter Reports Integration

| # | Task | File(s) |
|---|---|---|
| 17 | Wire `POST /api/mobile/reports` (submit) | `report/report_review.dart` + `report_service.dart` |
| 18 | Wire `GET /api/mobile/reports` (my list) | `my_reports/my_reports_screen.dart` |
| 19 | Wire `GET /api/mobile/reports/{id}` (detail) | `track_report/track_report_screen.dart` |
| 20 | Wire `GET /api/mobile/reports/community` (map) | `community_map/community_map_screen.dart` |
| 21 | Add `image_picker` for real photo capture | `pubspec.yaml` + `report/report_photo.dart` |
| 22 | Add `geolocator` + `permission_handler` for GPS | `pubspec.yaml` + `report/report_location.dart` |

### PHASE 4 — Flutter Notifications + Announcements

| # | Task | File(s) |
|---|---|---|
| 23 | Wire `GET /api/mobile/notifications` | `notifications/notification_screen.dart` |
| 24 | Wire mark read / mark all read | `notifications/notification_screen.dart` |
| 25 | Wire `GET /api/mobile/announcements` | `home/home_screen.dart` |

### PHASE 5 — Web Admin → Laravel (Optional for Prototype Defense)

| # | Task | Notes |
|---|---|---|
| 26 | Replace static JSON fetches with `fetch()` to `/api/*` | All list/table pages |
| 27 | Replace localStorage auth with real Sanctum token | `index.html` login + `app.js` |
| 28 | Wire photo uploads to Laravel storage | `report-details.html` for CEO + CENRO |

### HIGH — Web Admin Polish (Can Do Anytime)

| # | Task | File(s) |
|---|---|---|
| 29 | After photo upload (FileReader preview) | `offices/ceo/report-details.html`, `offices/cenro/report-details.html` |
| 30 | CEO + CENRO Settings pages | `offices/ceo/settings.html`, `offices/cenro/settings.html` |

---

## 📁 Key File Reference

### Flutter App

| What to change | File |
|---|---|
| API base URL | `lib/core/constants/api_constants.dart` (create) |
| Auth service | `lib/services/auth_service.dart` |
| Report service | `lib/services/report_service.dart` |
| Notification service | `lib/services/notification_service.dart` |
| Login screen | `lib/screens/auth/login_screen.dart` |
| OTP screen | `lib/screens/auth/otp_screen.dart` |
| Register screen | `lib/screens/auth/register_screen.dart` |
| Report review (submit) | `lib/screens/report/report_review.dart` |
| My Reports | `lib/screens/my_reports/my_reports_screen.dart` |
| Track Report | `lib/screens/track_report/track_report_screen.dart` |
| Community Map | `lib/screens/community_map/community_map_screen.dart` |
| Notifications | `lib/screens/notifications/notification_screen.dart` |
| State | `lib/core/state/app_state.dart` |

### Laravel Backend

| What to change | File |
|---|---|
| Environment config | `prc/laravel/.env` |
| Mobile auth routes | `prc/laravel/routes/api.php` → `/api/mobile/auth/*` |
| Mobile auth logic | `prc/laravel/app/Http/Controllers/Mobile/MobileAuthController.php` |
| Report submit logic | `prc/laravel/app/Http/Controllers/Mobile/MobileReportController.php` |
| OTP strategy | `MobileAuthController::sendOtp()` → TODO comment for real SMS |
| Citizen model | `prc/laravel/app/Models/Citizen.php` |
| Report model | `prc/laravel/app/Models/CitizenReport.php` |
| Migrations | `prc/laravel/database/migrations/` |
| Seeders | `prc/laravel/database/seeders/` |

### Web Admin

| What to change | File |
|---|---|
| Login + role routing | `index.html` |
| Sidebar/navbar per role | `assets/js/app.js` |
| Shared CSS tokens | `assets/css/variables.css` |
| CEO report detail | `offices/ceo/report-details.html` |
| CENRO report detail | `offices/cenro/report-details.html` |

---

## 🔐 Credentials Quick Reference

### Web Prototype (static localStorage)
| Role | Username | Password |
|---|---|---|
| Super Admin | `admin` | `admin123` |
| CEO | `ceo` | `ceo123` |
| CENRO | `cenro` | `cenro123` |

### Laravel Backend (after seeding)
- Admin email: `admin@civilwatch.ph`
- Admin password: `Admin@2026!`

### Laravel Web Panel URL
- `http://127.0.0.1:8000/admin/login`

### API Base URLs
- Admin/web: `http://127.0.0.1:8000/api/`
- Mobile (emulator): `http://10.0.2.2:8000/api/mobile/`
- Mobile (device on same network): `http://[your-local-ip]:8000/api/mobile/`

---

## 💡 Architecture Reminder

```
Flutter App (civ-main)           Web Admin (HTML/JS)
        ↓  /api/mobile/*                ↓  /api/* or /api/admin/*
        └──────────────┬────────────────┘
                       ↓
              Laravel Backend (prc/laravel)
                       ↓  Eloquent ORM
                     MySQL
                   (civilwatch DB)
```

The Flutter app **never connects directly to MySQL**. Always through Laravel.

---

*Paste this file at the start of the next session for full context.*
*All three components are in: `c:\Users\User\Downloads\SERENO\APP-WITH-WEB\prc\`*
