# CIVILWATCH — Session Prompt Reference

> Paste this entire prompt at the start of any new session so you never have to repeat yourself.

---

## MASTER CONTEXT PROMPT

Copy and paste the block below at the start of every new Kiro/AI session:

---

```
You are helping me build and maintain my capstone project.

─────────────────────────────────────────────────────────
PROJECT TITLE
─────────────────────────────────────────────────────────
CIVILWATCH: A Geotagged Community Infrastructure and
Environmental Incident Reporting, Management, and
Monitoring System for Digos City.

─────────────────────────────────────────────────────────
PROJECT TYPE
─────────────────────────────────────────────────────────
Capstone prototype only. NO backend. NO production code.
Goal: Polished UI/UX prototype for defense presentation.

─────────────────────────────────────────────────────────
WHAT HAS ALREADY BEEN BUILT
─────────────────────────────────────────────────────────
Admin Web Dashboard (civilwatch-admin/) — COMPLETE

Technology stack:
- HTML5 + CSS3 + Vanilla JavaScript ONLY
- No React, No Vue, No Angular, No Bootstrap
- Chart.js for analytics charts
- Leaflet.js for GIS maps
- Material Symbols for icons
- Unsplash CDN for demo images
- Inter / Roboto font

Pages built:
1. index.html          — Login page (demo: any credentials)
2. dashboard.html      — Overview with stats, map, activity
3. pending-reports.html — Validation queue table
4. report-details.html  — Detail view, approve/reject modals
5. assign-office.html   — Office assignment form (matches reference UI)
6. monitoring.html      — Progress tracking with tabs and update modal
7. gis-map.html         — Leaflet map with filter chips + detail panel
8. analytics.html       — 5 charts: line, 2x horizontal bar, 2x doughnut
9. resolved-reports.html — Archive of resolved reports

CSS files (assets/css/):
variables.css, global.css, layout.css, sidebar.css,
navbar.css, cards.css, buttons.css, tables.css, badges.css,
forms.css, charts.css, map.css, responsive.css

JS files (assets/js/):
- app.js   → Sidebar, navbar, notifications panel, dark mode
- utils.js → Status badges, category badges, image URLs, toast

Data files (assets/data/):
- reports.json   → 18 sample reports
- analytics.json → Chart data
- barangays.json → 26 Digos City barangays with GPS coords

Features working:
✅ Sidebar collapse/expand
✅ Notifications panel (redesigned — gradient icons, unread dots,
   count badge, "Mark all as read", styled footer)
✅ Dark mode toggle (moon/sun icon in navbar, persists via localStorage)
✅ Live search + multi-filter on all report tables
✅ Leaflet maps on Dashboard, GIS Map, Report Details
✅ Chart.js: line chart (weekly/monthly toggle), 2 horizontal bars,
   2 doughnut charts
✅ Approve/Reject modals with toast feedback
✅ Assign Office: office cards, priority pills, notes textarea,
   success modal (all matching reference image)
✅ Update Progress modal on Monitoring page
✅ Tab filters on Monitoring (All/Assigned/In Progress/Resolved)
✅ Real Unsplash images per issue type (thumbnail + large size)
✅ Pagination UI (visual only — first page data shown)

─────────────────────────────────────────────────────────
WHAT IS NOT BUILT YET (Optional)
─────────────────────────────────────────────────────────
- users.html   (linked in sidebar, page not created)
- settings.html (linked in sidebar, page not created)
- Functional pagination
- Export Reports logic

─────────────────────────────────────────────────────────
SCOPE — DO NOT ADD THESE (EVER)
─────────────────────────────────────────────────────────
❌ AI image verification
❌ Duplicate detection
❌ Fire incidents
❌ Disaster prediction
❌ Crime reporting
❌ Lost and Found
❌ Emergency response
❌ Hazard forecasting
❌ Project NOAH concepts

─────────────────────────────────────────────────────────
SUPPORTED INCIDENT CATEGORIES
─────────────────────────────────────────────────────────
Infrastructure:
  Broken Streetlight, Damaged Road, Damaged Sidewalk,
  Blocked Drainage, Damaged Bridge, Road Sign Damage, Others

Environmental:
  Illegal Dumping, Blocked Canal, Overgrown Vegetation,
  Soil Erosion, Others

─────────────────────────────────────────────────────────
REPORT STATUS FLOW
─────────────────────────────────────────────────────────
Submitted → Pending Validation → Assigned to Office
→ In Progress → Resolved

─────────────────────────────────────────────────────────
DESIGN RULES
─────────────────────────────────────────────────────────
- White background (#F9FAFB), Blue primary (#1A56DB)
- Pending = Yellow (#F59E0B)
- In Progress = Orange (#F97316)
- Resolved = Green (#10B981)
- Border radius: 16px
- Font: Inter or Roboto
- Soft shadows, rounded cards, lots of whitespace
- Material Design 3 inspired
- Dark mode: background #161B27, cards #1E2330

─────────────────────────────────────────────────────────
OFFICE ASSIGNMENT RULES
─────────────────────────────────────────────────────────
Infrastructure issues → City Engineering Office (CEO)
Environmental issues  → City Environment and Natural
                        Resources Office (CENRO)
Others                → Super Administrator decides

─────────────────────────────────────────────────────────
USERS
─────────────────────────────────────────────────────────
Admin Dashboard users:
- Super Administrator (validates, assigns, monitors all)
- Office Personnel (updates status of assigned reports)

─────────────────────────────────────────────────────────
PROJECT INFO
─────────────────────────────────────────────────────────
University: University of Mindanao — Digos Branch
Proponents: Renz Justine Y. Borinaga,
            Jhon Carlo Mag-Usara,
            Lawrence Roy P. Sereno
Adviser: Cyvil Dave Dasargo, MIT
Year: 2026

─────────────────────────────────────────────────────────
INSTRUCTIONS FOR YOU
─────────────────────────────────────────────────────────
- Always read existing files before editing them
- Match existing code style — no new libraries
- Keep all CSS in the correct separate CSS file
- Keep all JS in app.js or utils.js (shared) or inline in the page
- Do not add features outside the defined scope
- This is a prototype — focus on UI/UX polish
- Refer to PROJECT_STATUS.md for what is done and what is pending
```

---

## Quick Reference: File Locations

| What you want to change | File to edit |
|-------------------------|-------------|
| Colors, spacing tokens | `assets/css/variables.css` |
| Dark mode overrides | `assets/css/global.css` (bottom section) |
| Sidebar navigation | `assets/js/app.js` → `renderSidebar()` |
| Navbar + notifications | `assets/js/app.js` → `renderNavbar()`, `renderNotifPanel()` |
| Dark mode toggle logic | `assets/js/app.js` → `toggleDarkMode()`, `loadTheme()` |
| Status badge HTML | `assets/js/utils.js` → `Utils.statusBadge()` |
| Category badge HTML | `assets/js/utils.js` → `Utils.categoryBadge()` |
| Image URLs | `assets/js/utils.js` → `PHOTO_URLS`, `getPhotoUrl()`, `getPhotoUrlLarge()` |
| Table toolbar style | `assets/css/tables.css` |
| Notification panel style | `assets/css/navbar.css` (bottom section) |
| Map pins / popup | `assets/css/map.css` |
| Chart containers | `assets/css/charts.css` |

---

## Quick Reference: Status Colors

| Status | Color | Hex |
|--------|-------|-----|
| Pending Validation | Yellow | `#F59E0B` |
| Assigned | Blue | `#1A56DB` |
| In Progress | Orange | `#F97316` |
| Resolved | Green | `#10B981` |

---

## Quick Reference: Dark Mode

- Toggled by clicking the **moon icon** in the navbar
- Stored in `localStorage` key: `theme` (`"light"` or `"dark"`)
- Applied as `data-theme="dark"` on `<html>` element
- All dark overrides are in `assets/css/global.css` under the `[data-theme="dark"]` block

---

## Common Tasks — How to Ask

| Task | How to phrase it |
|------|-----------------|
| Fix a page to match reference | "Look at [page], here's the reference image — fix the differences" |
| Add a new feature | "Add [feature] to [page] — keep it within CIVILWATCH scope" |
| Fix a bug | "On [page], [describe problem]" |
| Build a missing page | "Build users.html — follow the same style as the existing pages" |
| Change colors/style | "Update the [element] on [page] to look like [description]" |
| Add interactivity | "Make [element] on [page] interactive — [describe behavior]" |

---

## Pending Work

See `PROJECT_STATUS.md` → **Not Yet Built** section for the full list.

Priority suggestions for next session:
1. Build `users.html` — User management page
2. Build `settings.html` — System settings page
3. Make pagination functional (load more data on page click)
4. Add smooth page transition animations

---

*Keep this file. Paste the master prompt block at the top of every new session.*
