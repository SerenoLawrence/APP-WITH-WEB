# CIVILWATCH — Final Build Status

> **Full-Stack Capstone | Flutter + Laravel + HTML/JS**
> Last Updated: August 13, 2026
> Current Phase: Integration (Flutter ↔ Laravel)

---

## Build Summary by Component

| Component | Build | Notes |
|---|---|---|
| Admin Web Dashboard | ✅ 100% UI complete | 27 pages, static prototype |
| Citizen Mobile App | ✅ 100% UI complete | All screens, zero backend |
| Laravel Backend API | ✅ 100% API built | Needs DB setup + serve to be live |
| Flutter ↔ Laravel | 🔲 0% | Next phase |
| Web Admin ↔ Laravel | 🔲 0% | After Flutter phase |

---

## ✅ Admin Web Dashboard — Complete

### All 27 Pages Built

**Super Admin (11 pages)**
- [x] `index.html` — Login with 3-role routing
- [x] `dashboard.html` — Stats, recent reports, Leaflet map, activity feed, quick actions
- [x] `pending-reports.html` — Validation queue, search + filters
- [x] `report-details.html` — Full detail, approve/reject modals, photo, timeline
- [x] `assign-office.html` — Office cards, priority pills, notes, success modal
- [x] `monitoring.html` — Tab filters, progress tracking, update modal
- [x] `gis-map.html` — Leaflet map with filter chips and detail panel
- [x] `analytics.html` — 5 Chart.js charts (line, bar ×2, doughnut ×2), weekly/monthly toggle
- [x] `resolved-reports.html` — Archive with search and filters
- [x] `users.html` — User table, slide-in details panel, Add User modal
- [x] `settings.html` — 7 sections: General, Categories, Offices, Notifications, Security, Logs, About

**CEO Office — `offices/ceo/` (8 pages, Blue theme)**
- [x] `dashboard.html`, `reports.html`, `inprogress.html`, `resolved.html`
- [x] `map.html`, `analytics.html`, `report-details.html`
- [x] `settings.html` — Placeholder only

**CENRO Office — `offices/cenro/` (8 pages, Green theme)**
- [x] `dashboard.html`, `reports.html`, `inprogress.html`, `resolved.html`
- [x] `map.html`, `analytics.html`, `report-details.html`
- [x] `settings.html` — Placeholder only

**Shared:**
- [x] Role-based login + localStorage routing
- [x] Role guards on all pages
- [x] Sidebar (collapse/expand, role-aware, logout)
- [x] Notifications drawer (slide-in, z-index fixed, unread dots, mark all read)
- [x] Dark mode (moon/sun toggle, persisted, full dark palette)
- [x] Toast notifications
- [x] All modals (approve, reject, assign, update, resolve)
- [x] Before/After photo section shell (after-upload logic pending)
- [x] Leaflet.js z-index cap via `map.css`

---

## ✅ Citizen Mobile App — All Screens Built

| Screen | File | Status |
|---|---|---|
| Splash | `splash/splash_screen.dart` | ✅ Done |
| Login | `auth/login_screen.dart` | ✅ Done |
| OTP | `auth/otp_screen.dart` | ✅ Done |
| Register | `auth/register_screen.dart` | ✅ Done |
| Home | `home/home_screen.dart` | ✅ Done |
| Report Category | `report/report_category.dart` | ✅ Done |
| Report Concern | `report/report_concern.dart` | ✅ Done |
| Report Photo | `report/report_photo.dart` | ✅ Done |
| Report Location | `report/report_location.dart` | ✅ Done (Nominatim geocoding live) |
| Report Review | `report/report_review.dart` | ✅ Done |
| Report Submitted | `report/report_submitted.dart` | ✅ Done |
| My Reports | `my_reports/my_reports_screen.dart` | ✅ Done |
| Track Report | `track_report/track_report_screen.dart` | ✅ Done |
| Status Update | `track_report/status_update_screen.dart` | ✅ Done |
| Private Map | `map_preview/private_map_screen.dart` | ✅ Done |
| Community Map | `community_map/community_map_screen.dart` | ✅ Done |
| Notifications | `notifications/notification_screen.dart` | ✅ Done |
| Profile | `profile/profile_screen.dart` | ✅ Done |

**Services Layer (stubs — ready for real wiring):**
- [x] `auth_service.dart` — sendOtp, verifyOtp, logout, isLoggedIn
- [x] `report_service.dart` — getUserReports, getReportById, submitReport
- [x] `notification_service.dart` — getNotifications, markRead, markAllRead

**Widget Library:**
- [x] PrimaryButton, SecondaryButton, AppIconButton (with badge)
- [x] ReportCard, ActivityCard, NotificationCard, StatusCard
- [x] StatusChip, EmptyState, AppLoading, AppNetworkImage
- [x] CustomTextField, SearchField, OtpBox
- [x] MapFilterChip, MapMarker, MapPreviewWidget
- [x] ProgressTimeline (5-step horizontal scrollable)

---

## ✅ Laravel Backend — Fully Built

### Database Migrations (all created, run with `php artisan migrate`)

| Migration | Table | Description |
|---|---|---|
| `2026_01_01_000001` | `citizens` | Mobile app users — phone, PIN hash, barangay |
| `2026_01_01_000002` | `otp_codes` | OTP codes with 5-min expiry |
| `2026_01_01_000003` | `government_offices` | CEO, CENRO, CPWD, CDRRMO, CVO |
| `2026_01_01_000004` | `citizen_reports` | Reports from Flutter app |
| `2026_01_01_000005` | `report_activities` | Activity/timeline log per report |
| `2026_01_01_000006` | `citizen_notifications` | Per-citizen notifications |
| `2026_01_01_000007` | `announcements` | City announcements |

### All API Routes Wired
- [x] `/api/ping` — Health check
- [x] `/api/mobile/auth/*` — Citizen auth (send-otp, verify-otp, register, logout, me)
- [x] `/api/mobile/reports/*` — Citizen reports (submit, list, community, show)
- [x] `/api/mobile/notifications/*` — Citizen notifications
- [x] `/api/mobile/announcements` — Public announcements
- [x] `/api/admin/*` — Admin report management + offices + announcements
- [x] `/api/login`, `/api/reports/*`, `/api/analytics/*` — Legacy admin API

### Run Commands (one-time setup)
```bash
# In prc/laravel/
copy .env.example .env       # then edit DB credentials
composer install
php artisan key:generate
php artisan migrate
php artisan db:seed
php artisan storage:link
php artisan serve             # → http://127.0.0.1:8000
```

---

## 🔲 Remaining Work

### HIGH — Must complete for full integration

| # | Task | Component |
|---|---|---|
| 1 | Setup `.env` with MySQL credentials and run migrations | Laravel |
| 2 | Add `ApiConstants` base URL to Flutter app | Flutter |
| 3 | Wire Flutter auth (send-otp, verify-otp, register) | Flutter ↔ Laravel |
| 4 | Store Sanctum token securely (add `flutter_secure_storage`) | Flutter |
| 5 | Wire Flutter report submission with real API call | Flutter ↔ Laravel |
| 6 | Wire Flutter My Reports + Track Report with real data | Flutter ↔ Laravel |
| 7 | Wire Flutter Community Map with real validated reports | Flutter ↔ Laravel |
| 8 | Wire Flutter Notifications with real DB data | Flutter ↔ Laravel |

### HIGH — Should complete before defense

| # | Task | Component |
|---|---|---|
| 9 | Add `image_picker` for real photo capture | Flutter |
| 10 | Add `geolocator` + `permission_handler` for real GPS | Flutter |
| 11 | After photo upload (FileReader preview) | Web admin |
| 12 | CEO + CENRO Settings pages (currently placeholder) | Web admin |

### MEDIUM — Nice to have

| # | Task | Component |
|---|---|---|
| 13 | Web admin fetch from real Laravel API (replace JSON) | Web + Laravel |
| 14 | Web admin replace localStorage auth with real tokens | Web + Laravel |
| 15 | Resolved rows → report-details link | Web admin |
| 16 | Dashboard recent rows → individual report links | Web admin |
| 17 | Analytics from live DB data | Web + Laravel |

### LOW — Polish / Future

| # | Task | Notes |
|---|---|---|
| 18 | SMS OTP (real provider — Semaphore/Vonage) | OTP currently returned in API response |
| 19 | Functional pagination on all list pages | UI exists |
| 20 | Export Reports (CSV/PDF) | Button shows "coming soon" toast |
| 21 | Real-time map pin refresh | All pins are static |
| 22 | Mobile responsive polish for office pages | Untested on small screens |
| 23 | Push notifications (FCM) | Not built — in-app only for now |

---

## 🔐 Credentials Reference

### Web Prototype (static localStorage)
| Role | Username | Password |
|---|---|---|
| Super Admin | `admin` | `admin123` |
| CEO | `ceo` | `ceo123` |
| CENRO | `cenro` | `cenro123` |

### Laravel Backend (after `php artisan db:seed`)
| Email | Password | Role |
|---|---|---|
| `admin@civilwatch.ph` | `Admin@2026!` | super_admin |

---

## 🎨 Design Tokens

| Token | Web Admin | Flutter App |
|---|---|---|
| Super Admin / CEO primary | `#1A56DB` | — |
| CENRO primary | `#10B981` | — |
| App primary (green) | — | `#1B5E20` |
| App navy | — | `#0D2137` |
| Pending | `#F59E0B` | `#F59E0B` |
| In Progress | `#F97316` | `#EA580C` |
| Resolved | `#10B981` | `#16A34A` |
| Assigned | `#1A56DB` | `#2563EB` |
| Page background | `#F9FAFB` | `#F8FAFC` |
| Card background | `#FFFFFF` | `#FFFFFF` |
| Dark page background | `#161B27` | N/A |
| Dark card background | `#1E2330` | N/A |
| Card border radius | `16px` | `16–20px` |

---

## ⚠️ Prototype Limitations (Both Components)

These are by design. Do not fix unless explicitly requested.

- **Flutter app** — No backend. All data in-memory. Resets on restart.
- **Web admin** — No backend. All data is static JSON or inline JS arrays.
- **Authentication** — localStorage (web) / in-memory (Flutter). Not real sessions.
- **Photo upload** — UI only. No real file handling.
- **GPS** — Simulated at `6.7498, 125.3572` (Digos City centre).
- **OTP** — Simulated with `Future.delayed`. No real SMS.
- **Pagination** — UI exists, only first page shown.

---

## 📋 Project Info

| | |
|---|---|
| **System** | CIVILWATCH — Geotagged Community Incident Reporting System |
| **Location** | Digos City, Davao del Sur |
| **University** | University of Mindanao — Digos Branch |
| **Program** | BS Information Technology |
| **Year** | 2026 |
| **Proponents** | Renz Justine Y. Borinaga, Jhon Carlo Mag-Usara, Lawrence Roy P. Sereno |
| **Adviser** | Cyvil Dave Dasargo, MIT |

---

*For new sessions: read SESSION_PROGRESS.md for the latest task context.*
*All three components (web, app, backend) are co-located in prc/ folder.*
