# CIVILWATCH — Full-Stack Project

**CIVILWATCH: A Geotagged Community Infrastructure and Environmental Incident Reporting, Management, and Monitoring System for Digos City.**

> University of Mindanao — Digos Branch | BS Information Technology | Capstone 2026
> Proponents: Renz Justine Y. Borinaga, Jhon Carlo Mag-Usara, Lawrence Roy P. Sereno
> Adviser: Cyvil Dave Dasargo, MIT

---

## Project Overview

CIVILWATCH is a full-stack system with three components that all work together:

| Component | Technology | Location | Status |
|---|---|---|---|
| Admin Web Dashboard | HTML5 + CSS3 + Vanilla JS | `prc/` (web files) | ✅ Complete (prototype) |
| Citizen Mobile App | Flutter / Dart | `prc/civ-main/` | ✅ Built (prototype — no backend yet) |
| Backend API | Laravel 12 + PHP + MySQL | `prc/laravel/` | ✅ Built (API ready, needs DB connection) |

---

## Architecture

```
┌─────────────────────────┐     ┌──────────────────────────┐
│   Admin Web Dashboard   │     │  Citizen Mobile App      │
│   HTML + CSS + JS        │     │  Flutter / Dart          │
│   (Browser)              │     │  (Android / iOS)         │
└────────────┬────────────┘     └─────────────┬────────────┘
             │  REST API                       │  REST API
             │  /api/admin/*                   │  /api/mobile/*
             └─────────────────┬───────────────┘
                               │
                ┌──────────────▼──────────────┐
                │   Laravel 12 Backend         │
                │   PHP + Sanctum Auth         │
                │   prc/laravel/               │
                └──────────────┬───────────────┘
                               │  Eloquent ORM
                               ▼
                        ┌─────────────┐
                        │   MySQL DB  │
                        │  civilwatch │
                        └─────────────┘
```

---

## Folder Structure

```
APP-WITH-WEB/
├── prc/
│   ├── civ-main/          # Flutter citizen mobile app
│   │   ├── lib/           # Dart source code
│   │   ├── android/       # Android build files
│   │   ├── ios/           # iOS build files
│   │   └── pubspec.yaml   # Flutter dependencies
│   │
│   ├── laravel/           # Laravel backend API
│   │   ├── app/           # Controllers, Models, Middleware
│   │   ├── routes/        # api.php — all API endpoints
│   │   ├── database/      # Migrations + Seeders
│   │   ├── resources/     # Blade views (admin web panel)
│   │   ├── .env.example   # Environment variable template
│   │   └── artisan        # Laravel CLI
│   │
│   └── [web admin files]  # HTML/CSS/JS admin dashboard
│
├── civilwatch.sql          # Database schema reference
├── README.md               # This file
├── FEATURES.md             # Full feature list across all components
├── FINAL_STATUS.md         # Build completion status
├── PROJECT_STATUS.md       # Detailed task progress
├── SESSION_PROGRESS.md     # Current session log and next tasks
├── SYSTEM_DESIGN.md        # Architecture, ERD, DFD, Use Cases
├── PRODUCTION_PROMPT.md    # Prompt for production implementation sessions
└── PROMPT_REFERENCE.md     # Master context prompt for new sessions
```

---

## Quick Start

### 1. Run the Laravel Backend

```bash
# Navigate to the Laravel folder
cd prc/laravel

# Copy environment file
copy .env.example .env

# Edit .env — set your MySQL credentials
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=civilwatch
# DB_USERNAME=root
# DB_PASSWORD=your_password

# Install PHP dependencies
composer install

# Generate app key
php artisan key:generate

# Run database migrations
php artisan migrate

# Seed default data (admin account + offices + announcements)
php artisan db:seed

# Link storage for photo uploads
php artisan storage:link

# Start the development server
php artisan serve
# → Runs at http://127.0.0.1:8000
```

**Default admin login after seeding:**
- Email: `admin@civilwatch.ph`
- Password: `Admin@2026!`

### 2. Open the Admin Web Panel

Visit: `http://127.0.0.1:8000/admin/login`

Or open `prc/[web files]/index.html` directly in a browser for the static prototype.

### 3. Run the Flutter App

```bash
cd prc/civ-main
flutter pub get
flutter run
```

> The Flutter app currently uses in-memory dummy data. To connect it to the Laravel backend, update `lib/core/constants/api_constants.dart` with the base URL `http://10.0.2.2:8000/api/mobile` (Android emulator) or `http://127.0.0.1:8000/api/mobile` (web/desktop).

---

## API Endpoints (Laravel)

### Health Check
```
GET /api/ping  →  { "success": true, "message": "CivilWatch API is running." }
```

### Citizen Mobile App (`/api/mobile/...`)

| Method | Endpoint | Description | Auth |
|---|---|---|---|
| POST | `/api/mobile/auth/send-otp` | Send OTP to phone number | Public |
| POST | `/api/mobile/auth/verify-otp` | Verify OTP, get token | Public |
| POST | `/api/mobile/auth/register` | Register new citizen | Public |
| GET | `/api/mobile/announcements` | City announcements | Public |
| POST | `/api/mobile/auth/logout` | Logout | Token |
| GET | `/api/mobile/auth/me` | Citizen profile | Token |
| GET | `/api/mobile/reports` | My reports | Token |
| POST | `/api/mobile/reports` | Submit new report | Token |
| GET | `/api/mobile/reports/community` | Community map reports | Token |
| GET | `/api/mobile/reports/{id}` | Report detail + activity log | Token |
| GET | `/api/mobile/notifications` | Notifications | Token |
| POST | `/api/mobile/notifications/mark-all-read` | Mark all read | Token |
| POST | `/api/mobile/notifications/{id}/read` | Mark one read | Token |

### Admin Web Panel (`/api/admin/...`)

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/admin/citizen-reports` | List all citizen reports |
| GET | `/api/admin/citizen-reports/summary` | Dashboard stat counts |
| GET | `/api/admin/citizen-reports/map` | Map pins (lat/lng) |
| GET | `/api/admin/citizen-reports/{id}` | Report detail |
| POST | `/api/admin/citizen-reports/{id}/validate` | Validate/approve report |
| POST | `/api/admin/citizen-reports/{id}/assign` | Assign to office |
| POST | `/api/admin/citizen-reports/{id}/status` | Update status |
| GET/POST/PUT/DELETE | `/api/admin/offices` | Manage government offices |
| GET/POST/PUT/DELETE | `/api/admin/announcements` | Manage announcements |

---

## User Roles

| Role | System | Access |
|---|---|---|
| Super Admin | Admin Web + API | Validate reports, assign offices, manage users, all analytics |
| CEO | Admin Web + API | Infrastructure reports assigned to City Engineering Office |
| CENRO | Admin Web + API | Environmental reports assigned to CENRO |
| Citizen | Flutter Mobile App | Submit reports, track status, view community map |

---

## Report Status Flow

```
Citizen Submits
      ↓
Pending Validation  ←  Super Admin reviews
      ↓
Assigned to Office  ←  Super Admin assigns to CEO or CENRO
      ↓
In Progress         ←  Office working on the issue
      ↓
Resolved            ←  Office marks resolved + uploads after photo
```

---

## Report Categories

**Infrastructure → City Engineering Office (CEO)**
- Road Repair
- Road Graveling
- Streetlight / Light Pole Concern
- Blocked Canal
- Others

**Environmental → CENRO**
- Illegal Dumping
- Garbage Collection

---

## Technologies Used

| Layer | Technology |
|---|---|
| Admin Frontend | HTML5, CSS3, Vanilla JavaScript, Leaflet.js, Chart.js |
| Citizen Mobile App | Flutter, Dart, flutter_map, OpenStreetMap |
| Backend | Laravel 12, PHP, Laravel Sanctum |
| Database | MySQL |
| Auth (Admin) | Sanctum email + password tokens |
| Auth (Citizen) | Sanctum phone + OTP + PIN tokens |
| Maps | Leaflet.js (web), flutter_map (mobile), OpenStreetMap tiles |

---

## Demo Credentials (Web Prototype / Static)

| Role | Username | Password |
|---|---|---|
| Super Administrator | `admin` | `admin123` |
| City Engineering Officer | `ceo` | `ceo123` |
| CENRO Administrator | `cenro` | `cenro123` |

**Laravel backend credentials (after seeding):**
- Email: `admin@civilwatch.ph` · Password: `Admin@2026!`

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

---

*Last Updated: August 13, 2026*
