# CIVILWATCH — Development Log

> **System:** Geotagged Community Incident Reporting System
> **Location:** Digos City
> **University:** University of Mindanao — Digos Branch
> **Program:** BS Information Technology · 2026
> **Proponents:** Renz Justine Y. Borinaga, Jhon Carlo Mag-Usara, Lawrence Roy P. Sereno
> **Adviser:** Cyvil Dave Dasargo, MIT

---

## Phase 0 — Prototype (Pre-Laravel)

**Status:** Complete ✓

The full system was built as a vanilla HTML5 / CSS3 / Vanilla JS prototype to validate the UI/UX and page flow before connecting a backend.

### Pages Built

#### Super Admin (11 pages)
| Page | File |
|------|------|
| Login | `index.html` |
| Dashboard | `dashboard.html` |
| Pending Reports | `pending-reports.html` |
| Report Details | `report-details.html` |
| Assign Office | `assign-office.html` |
| Monitoring | `monitoring.html` |
| GIS Map | `gis-map.html` |
| Analytics | `analytics.html` |
| Resolved Reports | `resolved-reports.html` |
| Users | `users.html` |
| Settings | `settings.html` |

#### CEO Office — `offices/ceo/` (8 pages)
Dashboard, Reports, In Progress, Resolved, Map, Analytics, Report Details, Settings

#### CENRO Office — `offices/cenro/` (8 pages)
Same structure as CEO, scoped to environmental reports with green accent theme.

### Technologies Used in Prototype
- HTML5, CSS3, CSS Variables (dark mode via `data-theme`)
- Vanilla JavaScript
- Leaflet.js — interactive maps
- Chart.js — analytics charts
- Material Symbols — icon system
- Static JSON files for data (`reports.json`, `analytics.json`, `barangays.json`)

### Auth in Prototype (now replaced)
- Hardcoded credential map in JS
- Role stored in `localStorage` only
- No real security — clearable via DevTools

---

## Phase 1 — Laravel Migration

**Status:** Complete ✓
**Date:** August 10, 2026

### What Was Done

#### 1. File Migration
All prototype files were moved into the Laravel `public/` directory:

```
public/
├── index.html                  ← Login
├── dashboard.html
├── analytics.html
├── gis-map.html
├── monitoring.html
├── pending-reports.html
├── assign-office.html
├── resolved-reports.html
├── report-details.html
├── users.html
├── settings.html
├── css/                        ← 13 CSS files
├── js/
│   ├── app.js
│   └── utils.js
├── data/
│   ├── reports.json
│   ├── analytics.json
│   └── barangays.json
└── offices/
    ├── ceo/                    ← 8 pages
    └── cenro/                  ← 8 pages
```

Original prototype files outside `prc/` were deleted after copying.

#### 2. Database
- Existing `civilwatch.sql` copied into `prc/laravel/`
- `.env` already pointed to `civilwatch` MySQL database

**Database schema:**

| Table | Purpose |
|-------|---------|
| `users` | 3 roles: super_admin, ceo, cenro |
| `reports` | Core incident reports with GPS, status, category, priority |
| `report_assignments` | Tracks who assigned what, when, and with what notes |
| `report_photos` | Before/after photos (Cloudinary URLs) |
| `report_timeline` | Full audit trail of every status change |
| `notifications` | Per-user notification records |

#### 3. Eloquent Models Created
- `app/Models/Report.php`
- `app/Models/ReportAssignment.php`
- `app/Models/ReportTimeline.php`
- `app/Models/ReportPhoto.php`
- `app/Models/Notification.php`
- `app/Models/User.php` — already existed, kept as-is

#### 4. Controllers Created
- `app/Http/Controllers/AuthController.php` — already existed and complete
- `app/Http/Controllers/ReportController.php` — new
- `app/Http/Controllers/AnalyticsController.php` — new
- `app/Http/Controllers/NotificationController.php` — new
- `app/Http/Controllers/UserController.php` — already existed

#### 5. API Routes (`routes/api.php`)

| Method | Endpoint | Controller | Notes |
|--------|----------|------------|-------|
| GET | `/api/ping` | inline | Health check |
| POST | `/api/login` | AuthController | Public |
| GET | `/api/user` | AuthController | Auth required |
| POST | `/api/logout` | AuthController | Auth required |
| GET | `/api/users` | UserController | Super admin |
| POST | `/api/users` | UserController | Super admin |
| GET | `/api/users/{id}` | UserController | Super admin |
| PUT | `/api/users/{id}` | UserController | Super admin |
| DELETE | `/api/users/{id}` | UserController | Super admin |
| GET | `/api/reports` | ReportController | Role-scoped |
| POST | `/api/reports` | ReportController | — |
| GET | `/api/reports/map` | ReportController | Map pins |
| GET | `/api/reports/{id}` | ReportController | Role-scoped |
| PUT | `/api/reports/{id}` | ReportController | Super admin |
| DELETE | `/api/reports/{id}` | ReportController | Super admin |
| POST | `/api/reports/{id}/validate` | ReportController | Super admin |
| POST | `/api/reports/{id}/reject` | ReportController | Super admin |
| POST | `/api/reports/{id}/assign` | ReportController | Super admin |
| POST | `/api/reports/{id}/status` | ReportController | CEO / CENRO |
| GET | `/api/analytics` | AnalyticsController | Full payload |
| GET | `/api/analytics/summary` | AnalyticsController | Stat cards |
| GET | `/api/analytics/status-distribution` | AnalyticsController | Doughnut |
| GET | `/api/analytics/by-category` | AnalyticsController | Doughnut |
| GET | `/api/analytics/top-issues` | AnalyticsController | Bar chart |
| GET | `/api/analytics/top-barangays` | AnalyticsController | Bar chart |
| GET | `/api/analytics/weekly-trend` | AnalyticsController | Line chart |
| GET | `/api/analytics/monthly-trend` | AnalyticsController | Line chart |
| GET | `/api/notifications` | NotificationController | — |
| GET | `/api/notifications/unread-count` | NotificationController | Badge poll |
| POST | `/api/notifications/read-all` | NotificationController | — |
| POST | `/api/notifications/{id}/read` | NotificationController | — |
| DELETE | `/api/notifications/{id}` | NotificationController | — |
| DELETE | `/api/notifications` | NotificationController | Clear all |

#### 6. Frontend Auth Updated
- `public/index.html` — login input changed from `username` to `email`, JS now POSTs to `/api/login` via `fetch()`, stores Sanctum token as `cw_token` in localStorage
- `public/js/app.js` — logout now calls `POST /api/logout` to revoke token server-side, notifications load from real API, badge polls every 30 seconds
- `Api` helper added to `app.js` — wraps all `fetch()` calls with `Authorization: Bearer {token}` header, auto-redirects to login on 401
- `requireAuth()` guard added to `app.js` — call on any protected page

#### 7. Auth Approach — Laravel Sanctum
Token-based auth. After login, the server returns a signed token tied to the user's record in the `users` table. That token is sent with every API request via `Authorization: Bearer`. Role-based access is enforced server-side in each controller. No more fakeable `localStorage` role strings.

---

## Decisions & Clarifications Log

| # | Question | Decision |
|---|----------|----------|
| 1 | Auth approach | Laravel Sanctum — token-based, server-enforced roles |
| 2 | Photo upload | Keep as prototype UI shell for now — real upload is a future feature |
| 3 | Missing root-level pages | Add when wiring each page's backend calls (next phase) |
| 4 | Mobile app folder | Place inside `prc/mobile/` as sibling to `prc/laravel/` |
| 5 | Database | Use existing `civilwatch.sql` — imported to MySQL |

---

## Phase 2 — Page-by-Page API Integration (NEXT)

**Status:** Not started

### Goal
Replace all static JSON data and hardcoded arrays in each HTML page with real `fetch()` calls to the Laravel API using the `Api` helper from `app.js`.

### Pages to Wire Up (in priority order)

#### Super Admin
- [ ] `dashboard.html` — stat cards via `GET /api/analytics/summary`, recent reports via `GET /api/reports?limit=5`
- [ ] `pending-reports.html` — report list via `GET /api/reports?status=pending`, validate/reject modals
- [ ] `report-details.html` — full report via `GET /api/reports/{id}`, timeline, photos
- [ ] `assign-office.html` — `POST /api/reports/{id}/assign`
- [ ] `monitoring.html` — all in-progress reports, update modal
- [ ] `gis-map.html` — map pins via `GET /api/reports/map`
- [ ] `analytics.html` — all charts via `GET /api/analytics`
- [ ] `resolved-reports.html` — `GET /api/reports?status=resolved`
- [ ] `users.html` — `GET /api/users`, add/edit/delete user modals
- [ ] `settings.html` — general settings (TBD)

#### CEO Office
- [ ] `offices/ceo/dashboard.html`
- [ ] `offices/ceo/reports.html`
- [ ] `offices/ceo/inprogress.html`
- [ ] `offices/ceo/resolved.html`
- [ ] `offices/ceo/map.html`
- [ ] `offices/ceo/analytics.html`
- [ ] `offices/ceo/report-details.html` — status update form → `POST /api/reports/{id}/status`

#### CENRO Office
- [ ] Same 7 pages as CEO, scoped to environmental

---

## Future Features (Post-Phase 2)

| Priority | Feature | Notes |
|----------|---------|-------|
| High | After photo upload | FileReader local preview + upload to Cloudinary or local storage. `report_photos` table and `ReportPhoto` model are already in place. |
| High | CEO & CENRO Settings pages | Currently show "coming soon" placeholder. Need profile edit, password change. |
| Medium | Real-time updates | Replace 30s polling with Laravel Echo + Pusher or Reverb for live notifications and report status changes |
| Medium | Export Reports | CSV/PDF export from reports tables. Button exists, shows "coming soon" toast. |
| Medium | Pagination | UI exists on all tables but only first page is shown. Wire up Laravel paginator response. |
| Medium | Dashboard clickable rows | Report list items on dashboard not individually linked to report-details. |
| Medium | Resolved rows → detail link | View button missing on resolved report rows. |
| Low | Mobile responsive polish | Breakpoints exist but office pages untested on small screens. |
| Low | Real-time map refresh | All pins are static — no live status update as reports change. |
| Low | Analytics from live data | Currently charts use hardcoded dummy numbers. Phase 2 will fix this. |

---

## Mobile App

A separate mobile app (for citizens to submit reports) will live at:
```
prc/
├── laravel/        ← this web system
└── mobile/         ← citizen-facing mobile app (future)
```

The `reports` table already has `submitted_by` and `submitted_contact` fields to receive citizen submissions from the mobile app. The `POST /api/reports` endpoint is public-ready for mobile use.

---

## Project File Structure (Current)

```
prc/laravel/
├── app/
│   ├── Http/Controllers/
│   │   ├── AuthController.php
│   │   ├── AnalyticsController.php
│   │   ├── NotificationController.php
│   │   ├── ReportController.php
│   │   └── UserController.php
│   └── Models/
│       ├── User.php
│       ├── Report.php
│       ├── ReportAssignment.php
│       ├── ReportTimeline.php
│       ├── ReportPhoto.php
│       └── Notification.php
├── docs/
│   └── DEVLOG.md               ← this file
├── public/
│   ├── index.html              ← Login
│   ├── dashboard.html
│   ├── [... 9 more super admin pages]
│   ├── css/                    ← 13 CSS files
│   ├── js/
│   │   ├── app.js              ← App shell + Api helper + requireAuth()
│   │   └── utils.js
│   ├── data/
│   │   ├── reports.json
│   │   ├── analytics.json
│   │   └── barangays.json
│   └── offices/
│       ├── ceo/                ← 8 pages
│       └── cenro/              ← 8 pages
├── routes/
│   ├── api.php                 ← All API routes
│   └── web.php
├── civilwatch.sql              ← Database dump
└── .env                        ← DB=civilwatch, Sanctum configured
```
