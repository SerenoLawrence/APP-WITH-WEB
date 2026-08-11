# CIVILWATCH Admin Dashboard

**Project Type:** Capstone Project Prototype  
**Target Platform:** Web Dashboard (HTML/CSS/JavaScript)  
**Location:** Digos City

---

## Overview

CIVILWATCH is a Geotagged Community Infrastructure and Environmental Incident Reporting, Management, and Monitoring System for Digos City. This is the **Administrator Web Dashboard** for reviewing, validating, assigning, and monitoring incident reports submitted by residents.

---

## Getting Started

**No installation required!** Just open `index.html` in any modern browser.

### Login Credentials (Demo)
- **Username:** `admin` (or any username)
- **Password:** `admin123` (or any password)

---

## Pages

| Page | File | Description |
|------|------|-------------|
| Login | `index.html` | Administrator login page |
| Dashboard | `dashboard.html` | Overview with stats, recent reports, map, and activity feed |
| Pending Reports | `pending-reports.html` | Review and validate newly submitted reports |
| Report Details | `report-details.html` | Detailed view with photo, info, map, timeline, approve/reject |
| Assign Office | `assign-office.html` | Assign validated reports to City Engineering or CENRO |
| Monitoring | `monitoring.html` | Track progress of assigned reports with status updates |
| GIS Map | `gis-map.html` | Interactive Leaflet map showing all report locations |
| Analytics | `analytics.html` | Charts showing trends, top issues, barangays, status distribution |
| Resolved Reports | `resolved-reports.html` | Archive of all completed reports |

---

## Features

### ✅ Fully Interactive
- **Login System** — Demo authentication (any credentials work)
- **Sidebar** — Collapse/expand navigation
- **Notifications** — Slide-in panel with mark all as read
- **Live Search & Filters** — Real-time table filtering on all report pages
- **Map Integration** — Leaflet.js maps on Dashboard, GIS Map, and Report Details
- **Charts** — Chart.js analytics (line, horizontal bar, doughnut)
- **Modals** — Approve, reject, assign, and update progress flows
- **Toast Notifications** — Success/error feedback
- **Tab Filters** — Status-based filtering on Monitoring page
- **Report Timeline** — Visual progress tracker with status steps

### 📦 Technologies Used
- **HTML5** — Semantic structure
- **CSS3** — Modern, responsive design with CSS Variables
- **Vanilla JavaScript** — No frameworks, pure DOM manipulation
- **Leaflet.js** — Interactive maps
- **Chart.js** — Data visualization
- **Material Symbols** — Icon system
- **Unsplash API** — High-quality incident photos

---

## Folder Structure

```
civilwatch-admin/
├── index.html                 # Login page
├── dashboard.html             # Main dashboard
├── pending-reports.html       # Validation queue
├── report-details.html        # Detailed report view
├── assign-office.html         # Office assignment
├── monitoring.html            # Progress tracking
├── gis-map.html              # Geographic map view
├── analytics.html            # Charts & statistics
├── resolved-reports.html     # Completed reports
│
├── assets/
│   ├── css/
│   │   ├── variables.css     # CSS custom properties
│   │   ├── global.css        # Base styles
│   │   ├── layout.css        # Page layout
│   │   ├── sidebar.css       # Navigation sidebar
│   │   ├── navbar.css        # Top navigation + notifications
│   │   ├── cards.css         # Card components
│   │   ├── buttons.css       # Button styles
│   │   ├── tables.css        # Data tables
│   │   ├── badges.css        # Status & category badges
│   │   ├── forms.css         # Form inputs & controls
│   │   ├── charts.css        # Chart containers
│   │   ├── map.css           # Map-specific styles
│   │   └── responsive.css    # Mobile breakpoints
│   │
│   ├── js/
│   │   ├── app.js            # Sidebar, navbar, notifications
│   │   └── utils.js          # Helper functions, image URLs
│   │
│   └── data/
│       ├── reports.json      # Sample report data (18 reports)
│       ├── analytics.json    # Chart data
│       └── barangays.json    # Barangay coordinates (26 locations)
```

---

## Image Sources

All incident photos are sourced from **Unsplash** (free, high-quality stock photos):

| Issue Type | Source |
|------------|--------|
| Damaged Road | Pothole/road damage photos |
| Illegal Dumping | Garbage/waste photos |
| Damaged Sidewalk | Cracked pavement photos |
| Blocked Drainage | Water/flood photos |
| Overgrown Vegetation | Overgrown plants/weeds |
| Broken Streetlight | Street lamp photos |
| Soil Erosion | Erosion/landslide photos |
| Road Sign Damage | Traffic sign photos |

Images are automatically fetched via Unsplash CDN with optimized sizes:
- **Table thumbnails:** 400×300px
- **Detail pages:** 800×500px

---

## Design Inspiration

- **Material Design 3** — Modern Google design language
- **Google Maps** — Map interface and interaction patterns
- **GCash / Maya Business** — Clean financial dashboard aesthetic
- **Linear** — Minimal, professional UI

### Color Palette

- **Primary Blue:** `#1A56DB`
- **Pending Yellow:** `#F59E0B`
- **In Progress Orange:** `#F97316`
- **Resolved Green:** `#10B981`
- **Background:** `#F9FAFB`

---

## Report Categories

### 🏗️ Infrastructure
- Broken Streetlight
- Damaged Road
- Damaged Sidewalk
- Blocked Drainage
- Damaged Bridge
- Road Sign Damage

### 🌿 Environmental
- Illegal Dumping
- Blocked Canal
- Overgrown Vegetation
- Soil Erosion

---

## Status Flow

```
Submitted
    ↓
Pending Validation (Super Admin reviews)
    ↓
Assigned to Office (City Engineering / CENRO)
    ↓
In Progress (Office working on issue)
    ↓
Resolved
```

---

## Browser Support

- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Safari 14+
- ✅ Edge 90+

---

## Prototype Limitations

This is a **UI/UX prototype** for capstone defense. No backend implementation:

- ❌ No real database
- ❌ No user authentication validation
- ❌ No data persistence (refresh resets everything)
- ❌ Pagination is visual only (first page shown)
- ❌ Some pages (Users, Settings) are linked but not built

---

## Credits

**Developed by:**  
Renz Justine Y. Borinaga  
Jhon Carlo Mag-Usara  
Lawrence Roy P. Sereno  

**University of Mindanao**  
Branch: Digos City  
Program: Bachelor of Science in Information Technology  
Academic Year: 2026

**Project Advisor:**  
Cyvil Dave Dasargo, MIT

---

## License

This project is for **educational purposes only** as part of a capstone project requirement.

---

## Notes

- All data is **dummy/sample data** for demonstration
- Photos are from Unsplash and used under their free license
- No personal information is collected or stored
- System is designed for **Digos City Government** context

---

**Last Updated:** May 21, 2026
