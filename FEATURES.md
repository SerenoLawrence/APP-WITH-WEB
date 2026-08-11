# CIVILWATCH — Current Features

> **Capstone Prototype | HTML5 + CSS3 + Vanilla JS**
> Last Updated: August 7, 2026

---

## Authentication & Roles

- Three roles: Super Admin, CEO (City Engineering Office), and CENRO
- Login routes each role to their respective dashboard automatically
- Role guards protect every page from unauthorized access
- Wrong-role bypass redirects to the correct office dashboard
- Dark mode and session state persist via `localStorage`
- Logout clears session and returns to login

**Demo Credentials**

| Role | Username | Password |
|------|----------|----------|
| Super Administrator | `admin` | `admin123` |
| City Engineering Officer | `ceo` | `ceo123` |
| CENRO Administrator | `cenro` | `cenro123` |

---

## Super Admin (11 Pages)

| Page | File | Description |
|------|------|-------------|
| Login | `index.html` | Role-based routing on login |
| Dashboard | `dashboard.html` | Stat cards, recent reports table, Leaflet map, activity feed, quick actions |
| Pending Reports | `pending-reports.html` | Validation queue with search and filters |
| Report Details | `report-details.html` | Full detail view, approve/reject modals, photo, timeline |
| Assign Office | `assign-office.html` | Assign reports to CEO or CENRO with priority and notes |
| Monitoring | `monitoring.html` | Tab-filtered progress tracking with update modal |
| GIS Map | `gis-map.html` | Leaflet map with filter chips and detail panel |
| Analytics | `analytics.html` | 5 Chart.js charts (line, bar ×2, doughnut ×2), weekly/monthly toggle |
| Resolved Reports | `resolved-reports.html` | Searchable archive of completed reports |
| Users | `users.html` | User table, slide-in details panel, Add User modal |
| Settings | `settings.html` | 7 sections: General, Categories, Offices, Notifications, Security, Logs, About |

---

## CEO Office — `offices/ceo/` (Blue Theme, 8 Pages)

| Page | File | Description |
|------|------|-------------|
| Dashboard | `dashboard.html` | 4 stat cards, recent reports list, Leaflet map with legend |
| Reports | `reports.html` | Assigned infrastructure reports table, View button |
| In Progress | `inprogress.html` | Active reports with stat cards, list layout, right info panel |
| Resolved | `resolved.html` | Resolved archive with 3 summary stat cards |
| Map | `map.html` | Leaflet map with filter chips (All / In Progress / For Resolution / Resolved / Assigned) |
| Analytics | `analytics.html` | Infrastructure-only: 4 summary cards + 5 charts |
| Report Details | `report-details.html` | Incident photo, info table, Leaflet preview, 5-step timeline, update form, resolve modal, before/after photo section |
| Settings | `settings.html` | Placeholder — coming soon |

---

## CENRO Office — `offices/cenro/` (Green Theme, 8 Pages)

Same structure as CEO, scoped to environmental reports with green accent colors.

| Page | File | Description |
|------|------|-------------|
| Dashboard | `dashboard.html` | 4 stat cards, recent reports list, Leaflet map with legend |
| Reports | `reports.html` | Assigned environmental reports table, View button |
| In Progress | `inprogress.html` | Active reports with stat cards, list layout, right info panel |
| Resolved | `resolved.html` | Resolved archive with 3 summary stat cards |
| Map | `map.html` | Leaflet map with filter chips |
| Analytics | `analytics.html` | Environmental-only: 4 summary cards + 5 charts |
| Report Details | `report-details.html` | Same as CEO, green accent, environmental data |
| Settings | `settings.html` | Placeholder — coming soon |

---

## Shared UI Components

- **Sidebar** — collapse/expand, role-aware navigation, logout link
- **Navbar** — dark mode toggle, notification bell with unread badge, profile name/title from `localStorage`
- **Notifications Drawer** — slide-in panel, gradient icon circles per type, unread dots, mark all as read, footer link
- **Dark Mode** — moon/sun toggle, `data-theme="dark"` on `<html>`, persisted across all pages
- **Toast Notifications** — success, error, and info variants
- **Modals** — approve, reject, assign, update progress, resolve confirmation
- **Before/After Photo Section** — Before auto-loads citizen photo; After is UI shell (upload wiring pending)

---

## Data Layer

| File | Contents |
|------|----------|
| `assets/data/reports.json` | 18 sample incident reports (infrastructure + environmental) |
| `assets/data/analytics.json` | Chart data: trends, categories, barangays, status distribution |
| `assets/data/barangays.json` | 26 Digos City barangays with GPS coordinates |

---

## Report Categories

**Infrastructure (CEO)**
- Road Repair, Road Graveling, Streetlight / Light Pole Concern, Blocked Canal, Others

**Environmental (CENRO)**
- Illegal Dumping, Garbage Collection

---

## Report Status Flow

```
Submitted by Citizen
        ↓
Pending Validation  ← Super Admin reviews
        ↓
Assigned to Office  ← CEO or CENRO
        ↓
In Progress         ← Office working on issue
        ↓
Resolved
```

---

## Technologies Used

| Technology | Purpose |
|------------|---------|
| HTML5 | Semantic page structure |
| CSS3 + CSS Variables | Styling, theming, dark mode |
| Vanilla JavaScript | DOM manipulation, routing, state |
| Leaflet.js | Interactive maps |
| Chart.js | Data visualization |
| Material Symbols | Icon system |
| Unsplash CDN | Incident photos (400×300 thumbnails, 800×500 detail) |

---

## Pending / Not Yet Implemented

| Priority | Feature | Notes |
|----------|---------|-------|
| High | After photo upload | FileReader local preview when office uploads resolution photo — UI shell exists, logic not wired |
| High | Office Settings pages | CEO and CENRO settings show "coming soon" placeholder |
| Medium | Resolved rows → report-details link | View button not yet added |
| Medium | Dashboard recent rows clickable | Report list items not individually linked |
| Medium | Analytics from live data | Charts use hardcoded dummy numbers, not calculated from `reports.json` |
| Low | Functional pagination | UI exists, only first page of data shown |
| Low | Export Reports | Button shows "coming soon" toast — no CSV/PDF output |
| Low | Real-time map refresh | All pins are static — no live status update |
| Low | Mobile responsive polish | Breakpoints exist but office pages untested on small screens |

---

## Known Prototype Limitations

These are by design and will not be fixed unless explicitly requested.

- No backend, database, or API — all data is static JSON or inline JS arrays
- No real authentication — `localStorage` only, clearable via DevTools
- No data persistence — refreshing the page resets all state
- Unsplash images require an internet connection to load

---

## Design Tokens

| Token | Value |
|-------|-------|
| Super Admin / CEO primary | `#1A56DB` |
| CENRO primary | `#10B981` |
| In Progress | `#F97316` |
| Pending / For Resolution | `#F59E0B` |
| Resolved | `#10B981` |
| Page background | `#F9FAFB` |
| Card background | `#FFFFFF` |
| Dark page background | `#161B27` |
| Dark card background | `#1E2330` |
| Border radius (cards) | `16px` |

---

## Project Info

| | |
|---|---|
| **System** | CIVILWATCH — Geotagged Community Incident Reporting System |
| **Location** | Digos City |
| **University** | University of Mindanao — Digos Branch |
| **Program** | BS Information Technology |
| **Year** | 2026 |
| **Proponents** | Renz Justine Y. Borinaga, Jhon Carlo Mag-Usara, Lawrence Roy P. Sereno |
| **Adviser** | Cyvil Dave Dasargo, MIT |
