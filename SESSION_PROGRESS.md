# CIVILWATCH — Session Progress & Next Tasks

> Last Updated: August 3, 2026
> Context file for continuing development in the next session.

---

## ✅ Completed This Session

### 1. Settings Page — Notification Table Fix
- Removed System, Email, SMS columns from the Notification Settings table
- Status column replaced with a toggle switch (On/Off) aligned under ACTIVE header
- Toggle is now vertically and horizontally centered in its column

---

### 2. Role-Based Login System
Three login credentials now route to separate dashboards:

| Username | Password | Role | Redirects To |
|----------|----------|------|--------------|
| `admin` | `admin123` | Super Admin | `dashboard.html` |
| `ceo` | `ceo123` | City Engineering Officer | `offices/ceo/dashboard.html` |
| `cenro` | `cenro123` | CENRO Administrator | `offices/cenro/dashboard.html` |

- `localStorage` stores: `cw_role`, `cw_name`, `cw_title`
- `app.js` reads role and renders role-specific sidebar, navbar name/title, and initials

---

### 3. Role Guards on All Super Admin Pages
Guard script added at the top of every super admin page (before `<head>`):
- No role → redirect to `index.html`
- Wrong role → redirect to correct office dashboard

Pages guarded: `dashboard.html`, `pending-reports.html`, `assign-office.html`, `monitoring.html`, `gis-map.html`, `analytics.html`, `resolved-reports.html`, `report-details.html`, `users.html`, `settings.html`

---

### 4. Office Pages — Folder Structure

```
offices/
├── ceo/
│   ├── dashboard.html       ✅ Blue theme, infrastructure stats, Leaflet map
│   ├── reports.html         ✅ My Assigned Reports table (infrastructure only)
│   ├── inprogress.html      ✅ Active Reports — redesigned (see below)
│   ├── resolved.html        ✅ Resolved Reports with summary cards
│   ├── map.html             ✅ Leaflet map with filter chips
│   ├── analytics.html       ✅ Infrastructure-only analytics (5 charts)
│   ├── settings.html        ✅ Placeholder (coming soon)
│   └── report-details.html  ✅ Full detail page (see below)
│
└── cenro/
    ├── dashboard.html       ✅ Green theme, environmental stats, Leaflet map
    ├── reports.html         ✅ My Assigned Reports table (environmental only)
    ├── inprogress.html      ✅ Active Reports — redesigned (see below)
    ├── resolved.html        ✅ Resolved Reports with summary cards
    ├── map.html             ✅ Leaflet map with filter chips
    ├── analytics.html       ✅ Environmental-only analytics (5 charts)
    ├── settings.html        ✅ Placeholder (coming soon)
    └── report-details.html  ✅ Full detail page (see below)
```

All office pages use `../../assets/` for shared CSS/JS.
All office pages have role guards that prevent wrong-role access.

---

### 5. Active Reports Page (inprogress.html) — Redesigned
Matches new reference UI:
- 3 stat cards: In Progress / For Resolution / Assigned (each with "View all" filter link)
- Report list: photo thumbnail + title + location + ref number + date/time + assigned-by
- Status pill per row: In Progress (orange) / For Resolution (yellow) / Assigned (blue/green)
- "Continue →" button links to `report-details.html?ref=`
- Search + category filter + barangay filter + sort (Newest/Oldest)
- Right info panel: "About Active Reports" legend + "Quick Tips"
- CEO = blue accent, CENRO = green accent

---

### 6. Report Details Page (report-details.html) — Built for Both Offices
Features:
- Back link → My Assigned Reports
- Title + reference number + status badge + assigned date
- Incident photo (citizen submitted)
- Incident information table (category, location, coordinates, date, reference)
- Description card
- Leaflet map preview with link to full map
- 5-step progress timeline (Submitted → Validated → Assigned → In Progress → Resolved)
- Update Progress form (status dropdown + remarks textarea with char count)
- "Save Update" button (updates status badge live)
- "Mark as Resolved" button → confirmation modal → success banner + timeline update
- Before/After photo section (side by side):
  - **Before**: citizen's original incident photo (auto-loaded)
  - **After**: placeholder with "Upload After Photo" button (future task)
- Info tip at bottom
- CEO = blue, CENRO = green

---

### 7. Analytics Pages — Built for Both Offices

**CEO Analytics** (`offices/ceo/analytics.html`):
- Summary strip: Total Assigned (32), In Progress (18), Resolved (22), Resolution Rate (68%)
- Chart 1: Infrastructure Reports Over Time — line chart (weekly/monthly toggle)
- Chart 2: Most Reported Infrastructure Issues — horizontal bar (Damaged Road, Blocked Drainage, etc.)
- Chart 3: Status Distribution — doughnut
- Chart 4: Reports by Barangay — horizontal bar
- Chart 5: Priority Distribution — doughnut

**CENRO Analytics** (`offices/cenro/analytics.html`):
- Summary strip: Total Assigned (28), In Progress (16), Resolved (35), Resolution Rate (74%)
- Chart 1: Environmental Reports Over Time — line chart (weekly/monthly toggle)
- Chart 2: Most Reported Environmental Issues — horizontal bar (Illegal Dumping, Blocked Canal, etc.)
- Chart 3: Status Distribution — doughnut
- Chart 4: Reports by Barangay — horizontal bar
- Chart 5: Priority Distribution — doughnut

---

### 8. Sidebar Updates (app.js)
- "In Progress" renamed to "Active Reports" for both CEO and CENRO
- Analytics nav item added between Map and Settings for both roles
- CENRO sidebar uses green gradient background
- Logout link added to all role sidebars — clears localStorage and redirects to `index.html`

---

## 🔲 Pending Tasks (Next Session)

### HIGH PRIORITY

| # | Task | File(s) |
|---|------|---------|
| 1 | **Before/After photo upload** — implement actual file picker with `FileReader` local preview. Before = citizen photo, After = office uploads resolution photo. Side-by-side display. | `offices/ceo/report-details.html`, `offices/cenro/report-details.html` |
| 2 | **Office Settings page** — currently just a placeholder. Build actual settings (profile info, notification preferences, password change) for CEO and CENRO. | `offices/ceo/settings.html`, `offices/cenro/settings.html` |

### MEDIUM PRIORITY

| # | Task | File(s) |
|---|------|---------|
| 3 | **Resolved reports → report-details link** — `resolved.html` rows are not yet linked to `report-details.html`. Add View button with `?ref=` param. | `offices/ceo/resolved.html`, `offices/cenro/resolved.html` |
| 4 | **Dashboard → reports link** — "View All Assigned Reports" in dashboard links to `reports.html` but recent report rows are not individually clickable to report-details. | `offices/ceo/dashboard.html`, `offices/cenro/dashboard.html` |
| 5 | **Analytics data sync** — analytics figures are currently hardcoded dummy data. Consider pulling counts from the shared `reports.json` data for consistency. | `offices/ceo/analytics.html`, `offices/cenro/analytics.html` |

### LOW PRIORITY / FUTURE

| # | Task | Notes |
|---|------|-------|
| 6 | Functional pagination on all table pages | UI exists, data doesn't page |
| 7 | Export reports button | Currently shows "coming soon" toast |
| 8 | Real-time map pin updates | Pins are static |
| 9 | Super Admin — view CEO/CENRO report progress | Super admin can't currently see what office users have updated |

---

## 📁 Key File Reference

| What to change | File |
|----------------|------|
| Login credentials & routing | `index.html` |
| Sidebar/navbar per role | `assets/js/app.js` → `renderSidebar()`, `renderNavbar()` |
| Role logout logic | `assets/js/app.js` → `logout()` |
| Shared CSS tokens | `assets/css/variables.css` |
| CEO dashboard | `offices/ceo/dashboard.html` |
| CENRO dashboard | `offices/cenro/dashboard.html` |
| CEO report detail | `offices/ceo/report-details.html` |
| CENRO report detail | `offices/cenro/report-details.html` |
| CEO analytics | `offices/ceo/analytics.html` |
| CENRO analytics | `offices/cenro/analytics.html` |

---

## 🎨 Design Tokens

| Token | Super Admin | CEO | CENRO |
|-------|-------------|-----|-------|
| Primary color | `#1A56DB` | `#1A56DB` | `#10B981` |
| Light bg | `#EFF6FF` | `#EFF6FF` | `#ECFDF5` |
| Sidebar bg | Dark blue gradient | Dark blue gradient | `#166534` green gradient |
| In Progress | `#F97316` | `#F97316` | `#F97316` |
| For Resolution | `#F59E0B` | `#F59E0B` | `#F59E0B` |
| Resolved | `#10B981` | `#10B981` | `#10B981` |

---

## 🔐 Role Guard Pattern

All protected pages use this script **before `<head>`**:

```html
<!-- Super Admin pages (root level) -->
<script>
  (function(){
    var role = localStorage.getItem('cw_role');
    if (!role) { window.location.replace('index.html'); }
    else if (role !== 'superadmin') {
      window.location.replace(role === 'ceo' ? 'offices/ceo/dashboard.html' : 'offices/cenro/dashboard.html');
    }
  })();
</script>

<!-- CEO pages (offices/ceo/) -->
<script>
  (function(){
    var role = localStorage.getItem('cw_role');
    if (!role) { window.location.replace('../../index.html'); }
    else if (role !== 'ceo') {
      window.location.replace(role === 'superadmin' ? '../../dashboard.html' : '../cenro/dashboard.html');
    }
  })();
</script>

<!-- CENRO pages (offices/cenro/) -->
<script>
  (function(){
    var role = localStorage.getItem('cw_role');
    if (!role) { window.location.replace('../../index.html'); }
    else if (role !== 'cenro') {
      window.location.replace(role === 'superadmin' ? '../../dashboard.html' : '../ceo/dashboard.html');
    }
  })();
</script>
```

---

*Paste this file at the start of the next session for full context.*
