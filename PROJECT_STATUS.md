# CIVILWATCH Admin Dashboard — Project Status

> **Capstone Prototype | HTML5 + CSS3 + Vanilla JS**
> Last Updated: August 1, 2026

---

## ✅ Build Completion Summary

All planned pages and components have been built and are fully functional as a UI/UX prototype.

---

## ✅ Completed Tasks

### Phase 1 — Foundation
- [x] Project folder structure created
- [x] `variables.css` — All CSS custom properties, color tokens, spacing, typography
- [x] `global.css` — Base reset, utility classes, toast notifications, modals, dark mode overrides
- [x] `layout.css` — App shell, grid systems, page content wrapper
- [x] `sidebar.css` — Collapsible sidebar, nav items, user profile strip
- [x] `navbar.css` — Top navigation bar, search, notifications panel (redesigned), dark mode button
- [x] `cards.css` — Stat cards, overview cards, info/tip/reminder cards
- [x] `buttons.css` — Primary, secondary, ghost, danger, success, icon, view button variants
- [x] `tables.css` — Data tables, toolbar, search inputs, filter selects, pagination
- [x] `badges.css` — Status badges, category badges, priority badges, tab bar, filter chips
- [x] `forms.css` — Form inputs, office cards, priority selector, OR divider
- [x] `charts.css` — Chart card containers, doughnut legend, analytics layout, toggle group
- [x] `map.css` — Leaflet map container, legend, detail panel, custom pins, popups
- [x] `responsive.css` — Breakpoints for 1280px, 1024px, 768px, 480px

### Phase 2 — Data
- [x] `reports.json` — 18 sample reports (Infrastructure + Environmental)
- [x] `analytics.json` — Weekly/monthly trend, top issues, by category, by barangay, status distribution
- [x] `barangays.json` — 26 Digos City barangays with GPS coordinates

### Phase 3 — JavaScript
- [x] `utils.js` — Status badges, category badges, toast, debounce, URL params, image URL map (thumbnail + large)
- [x] `app.js` — Sidebar, navbar, notifications panel, dark mode toggle, theme persistence via localStorage

### Phase 4 — HTML Pages

| Page | File | Status |
|------|------|--------|
| Login | `index.html` | ✅ Done |
| Dashboard | `dashboard.html` | ✅ Done |
| Pending Reports | `pending-reports.html` | ✅ Done |
| Report Details | `report-details.html` | ✅ Done |
| Assign Office | `assign-office.html` | ✅ Done |
| Monitoring | `monitoring.html` | ✅ Done |
| GIS Map | `gis-map.html` | ✅ Done |
| Analytics | `analytics.html` | ✅ Done |
| Resolved Reports | `resolved-reports.html` | ✅ Done |
| Users | `users.html` | ✅ Done |
| Settings | `settings.html` | ✅ Done |

### Phase 5 — Fixes & Polish
- [x] Assign Office page — rebuilt to match reference image exactly
  - Large photo thumbnail in summary card
  - Icon + label field rows with Material Symbols per field
  - Proper office card with Recommended badge and blue check
  - Building icon prefix on dropdown
  - Pill-style priority buttons (Low / Medium / High)
  - Redesigned right info cards (Tip / Why this office / Reminder)
- [x] Image URLs — replaced all with real Unsplash photos per issue type
  - Thumbnail size: 400×300px for table rows
  - Large size: 800×500px for detail/map panels
- [x] Notification panel — completely redesigned
  - "Notifications" title + red count badge
  - Styled "Mark all as read" pill button
  - Gradient icon circles per type (submit/assign/progress/resolved/comment/system)
  - Bottom border separators between items
  - Unread blue-tint rows with animated dot indicator
  - Timestamp with separator dot
  - "View all notifications" styled footer button
- [x] Dark mode — full implementation
  - Moon/Sun icon toggle in navbar
  - `data-theme="dark"` applied to `<html>`
  - Theme persisted via `localStorage` across all pages
  - Complete dark palette: cards, tables, inputs, badges, sidebar, modals, charts, maps, forms, notifications

---

## ✅ Additional Completed Pages

| Page | File | Status |
|------|------|--------|
| Users | `users.html` | ✅ Done |
| Settings | `settings.html` | ✅ Done |

### users.html features:
- 4 stat cards: Total Users, Active Users, Administrators, Staff
- Search + filter toolbar (role, office, status)
- Data table: 8 sample users with color avatars, role badges, status dots, last login
- Slide-in right details panel: avatar, name, role, office, account info, status chip, role & permissions, last activity, Edit/Reset Password/Deactivate buttons
- Add User modal with form fields

### settings.html features:
- 7-section left nav: General, Report Categories, Government Offices, Notification Settings, Security, System Logs, About System
- General: 6 system fields (name, date format, city, time format, language, map view) with Save
- Report Categories: Infrastructure / Environmental tabs, category table with icons, toggle, edit/delete
- Government Offices: offices table with type badges, active toggles, edit/delete, Add Office button
- Notification Settings: event table with per-channel toggles (System/Email/SMS) and status pills
- Security: Password Policy, Session Settings, Access Control with toggle switches and dropdowns
- System Logs: filterable activity log table with activity badges and Export Logs button
- About System: logo, version, description, proponents, adviser, college, copyright

## 🔲 Not Yet Built (Optional / Future)

| Page / Feature | Notes |
|------|-------|
| `report-details` for monitoring | Currently links to same report-details.html — could be extended with update progress inline |
| Functional pagination | UI exists, but only first page of data shown |
| Export Reports | Button shows "coming soon" toast — no actual export logic |
| Real-time map updates | Map pins are static — no live refresh |

---

## 📁 Final Folder Structure

```
civilwatch-admin/
│
├── index.html                  # Login page
├── dashboard.html              # Overview dashboard
├── pending-reports.html        # Validation queue
├── report-details.html         # Report detail + approve/reject
├── assign-office.html          # Office assignment
├── monitoring.html             # Progress tracking
├── gis-map.html               # Leaflet GIS map
├── analytics.html             # Chart.js analytics
├── resolved-reports.html      # Completed reports archive
│
├── README.md                   # Project overview & usage
├── PROJECT_STATUS.md           # This file — build progress
├── PROMPT_REFERENCE.md         # Prompt guide for continuing sessions
│
└── assets/
    ├── css/
    │   ├── variables.css       # CSS tokens + dark mode variables
    │   ├── global.css          # Base styles + dark mode overrides
    │   ├── layout.css          # App shell + grid
    │   ├── sidebar.css         # Sidebar nav
    │   ├── navbar.css          # Top nav + notifications panel
    │   ├── cards.css           # Card components
    │   ├── buttons.css         # Button variants
    │   ├── tables.css          # Tables + toolbar
    │   ├── badges.css          # Badges + chips + tabs
    │   ├── forms.css           # Forms + office cards
    │   ├── charts.css          # Chart containers
    │   ├── map.css             # Map + detail panel
    │   └── responsive.css      # Breakpoints
    │
    ├── js/
    │   ├── app.js              # Sidebar, navbar, notifications, dark mode
    │   └── utils.js            # Helpers, image URLs, status badges
    │
    └── data/
        ├── reports.json        # 18 sample incident reports
        ├── analytics.json      # Chart data
        └── barangays.json      # 26 barangays with coordinates
```

---

## 🧪 How to Open

No installation needed. Open `index.html` in any modern browser.

**Demo login:** Any username and password works.

---

## 🔗 Page Navigation Flow

```
index.html (Login)
    ↓
dashboard.html
    ├── → pending-reports.html
    │       └── → report-details.html
    │               └── → assign-office.html
    │                       └── → monitoring.html
    ├── → monitoring.html
    ├── → gis-map.html
    ├── → analytics.html
    └── → resolved-reports.html
```

---

## 🎨 Design Tokens

| Token | Value |
|-------|-------|
| Primary Blue | `#1A56DB` |
| Pending Yellow | `#F59E0B` |
| In Progress Orange | `#F97316` |
| Resolved Green | `#10B981` |
| Background | `#F9FAFB` |
| Card Background | `#FFFFFF` |
| Border Radius | `16px` |
| Font | Inter / Roboto |

### Dark Mode
| Token | Value |
|-------|-------|
| Background | `#161B27` |
| Card Background | `#1E2330` |
| Border | `#2E3A50` |
| Primary Blue (dark) | `#4D8EFF` |

---

## ⚠️ Known Limitations (Prototype)

1. No backend — all data is hardcoded dummy JSON
2. No real authentication — any credentials accepted
3. Pagination UI only — data does not page
4. No data persistence — refresh resets state
5. Unsplash images require internet connection
6. Users and Settings pages are not built

---

*This is a capstone prototype for academic presentation and defense only.*
*Not intended for production deployment.*
