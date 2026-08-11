# CIVILWATCH — Production Implementation Prompt

> Use this as your master prompt when starting a new session to build the production-ready version of CIVILWATCH.

---

## The Prompt

```
I have a fully built HTML/CSS/Vanilla JS prototype for a capstone system called CIVILWATCH — 
a Geotagged Community Incident Reporting System for Digos City. I need to convert this 
prototype into a production-ready full-stack web application.

---

## Current Prototype Stack

- Frontend: HTML5, CSS3, Vanilla JavaScript (27 pages across 3 portals)
- Maps: Leaflet.js (already integrated)
- Charts: Chart.js
- Icons: Material Symbols
- Data: Static JSON files (no backend yet)
- Auth: localStorage only (no real session/token system)

---

## Target Production Stack

### Backend
- Runtime: Node.js
- Framework: Express.js
- Language: JavaScript (keep the stack consistent with the frontend)
- Architecture: REST API (JSON responses)

### Database
- MySQL (relational, hosted locally or on PlanetScale/Railway for deployment)
- ORM: Sequelize (for model definitions, migrations, associations)

### Authentication
- JWT (JSON Web Tokens) stored in httpOnly cookies
- bcrypt for password hashing
- Role-based access control: super_admin, ceo, cenro
- Middleware to protect all API routes by role

### Image Storage
- Cloudinary (for incident photos uploaded by citizens and resolution/after photos uploaded by offices)
- Use multer + cloudinary-storage for upload middleware
- Store Cloudinary public_id and secure_url in the database, not binary blobs

### Maps
- Keep Leaflet.js on the frontend
- Backend provides report coordinates via API (lat, lng stored in MySQL)
- Real-time pin status updates via polling or Socket.io

### Frontend (Preserved)
- Keep all existing HTML/CSS/JS pages as-is for structure and styling
- Replace all static JSON data fetches and hardcoded arrays with fetch() calls to the REST API
- Replace localStorage auth with JWT cookie-based auth
- Keep dark mode, sidebar, navbar, toast, and modals intact

---

## System Roles and Access

| Role | Access |
|------|--------|
| super_admin | Full access: validate reports, assign to offices, manage users, view all analytics |
| ceo | City Engineering Office: view assigned infrastructure reports, update progress, resolve |
| cenro | CENRO: view assigned environmental reports, update progress, resolve |

---

## Core Database Tables Needed

- users (id, name, email, password_hash, role, office, avatar_url, created_at)
- reports (id, reference_no, title, description, category, status, priority, barangay, lat, lng, submitted_by, assigned_to_office, created_at, updated_at)
- report_photos (id, report_id, type [before/after], cloudinary_url, cloudinary_public_id, uploaded_by, created_at)
- report_timeline (id, report_id, action, note, performed_by, created_at)
- notifications (id, user_id, message, type, is_read, created_at)
- report_assignments (id, report_id, assigned_to, assigned_by, priority, notes, created_at)

---

## Report Status Flow

Submitted → Pending → Assigned → In Progress → For Resolution → Resolved

Each status change must:
1. Update the reports table
2. Insert a row into report_timeline
3. Create a notification for the relevant user/office

---

## API Endpoints Needed

### Auth
- POST /api/auth/login
- POST /api/auth/logout
- GET  /api/auth/me

### Reports
- GET    /api/reports                (with filters: status, category, office, barangay, date range)
- GET    /api/reports/:id
- POST   /api/reports                (citizen submission with photo upload)
- PATCH  /api/reports/:id/status
- PATCH  /api/reports/:id/assign
- GET    /api/reports/:id/timeline
- POST   /api/reports/:id/photos     (Cloudinary upload for after photo)

### Users
- GET    /api/users
- POST   /api/users
- PATCH  /api/users/:id
- DELETE /api/users/:id

### Analytics
- GET    /api/analytics/summary      (total counts by status)
- GET    /api/analytics/trends       (monthly counts for line chart)
- GET    /api/analytics/by-category
- GET    /api/analytics/by-barangay
- GET    /api/analytics/by-office

### Notifications
- GET    /api/notifications          (for logged-in user)
- PATCH  /api/notifications/read-all

### Map
- GET    /api/map/pins               (returns id, lat, lng, status, category, title for all reports)

---

## Citizen Mobile App Note

There is a separate citizen-facing mobile app (React Native or Flutter — TBD) that submits 
reports with geotagged photos. The backend must support unauthenticated report submission 
via POST /api/reports with a photo upload to Cloudinary.

---

## Pending Features to Complete During Production

These were already designed in the prototype but not wired up:

1. After photo upload — wire FileReader + Cloudinary upload when office resolves a report
2. CEO and CENRO Settings pages — build out profile settings, password change, notification preferences
3. Functional pagination — all list/table views need real limit/offset from the API
4. Export Reports — CSV export via json2csv, PDF via pdfkit or puppeteer
5. Analytics charts driven by real DB data — not hardcoded arrays
6. Clickable rows on Dashboard recent reports and Resolved lists

---

## Folder Structure (Target)

/civilwatch
  /client          ← existing prototype HTML/CSS/JS (served as static files or kept separate)
  /server
    /config        ← db.js, cloudinary.js, env config
    /controllers   ← auth, reports, users, analytics, notifications, map
    /middleware    ← auth guard (JWT verify), role check, upload (multer+cloudinary)
    /models        ← Sequelize models: User, Report, ReportPhoto, Timeline, Notification, Assignment
    /routes        ← express routers per resource
    /utils         ← response helpers, status constants, date helpers
    app.js         ← express setup, cors, cookie-parser, routes
    server.js      ← entry point, listen

---

## Environment Variables Needed (.env)

PORT=5000
NODE_ENV=production

DB_HOST=
DB_PORT=3306
DB_NAME=civilwatch
DB_USER=
DB_PASSWORD=

JWT_SECRET=
JWT_EXPIRES_IN=7d
COOKIE_SECURE=true

CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=

CLIENT_URL=https://civilwatch.digos.gov.ph

---

## Instructions for the AI

1. Start by scaffolding the /server folder structure above.
2. Set up Express with cors, helmet, cookie-parser, morgan.
3. Configure Sequelize with MySQL and define all models with associations.
4. Build auth routes first (login, logout, /me) with JWT + bcrypt.
5. Build the reports CRUD with Cloudinary photo upload middleware.
6. Build analytics endpoints that query the DB (not hardcoded).
7. Build the map pins endpoint.
8. Build notifications (insert on status change, mark as read).
9. Then update the frontend JS files to replace static data with fetch() to the API.
10. Replace localStorage session with /api/auth/me check on page load.
11. Wire the after photo upload on report-details.html for CEO and CENRO.
12. Wire functional pagination on all list pages.
13. Wire export buttons to generate CSV downloads.
14. Add Socket.io for real-time map pin updates and notification badge refresh.

Preserve all existing HTML structure, CSS classes, dark mode tokens, and component behavior. 
Only touch the JavaScript data layer — fetch from API instead of JSON files.
```

---

## Why Node.js + Express?

Node.js is the best fit for this project for these reasons:

- **Same language as the frontend** — no context switching between PHP/Python and JS
- **Express is lightweight** — full control, no magic, easy to learn for a capstone
- **Sequelize works great with MySQL** — model definitions, migrations, associations are straightforward
- **Excellent ecosystem** — multer, cloudinary-storage, jwt, bcrypt, socket.io, json2csv all have mature Node packages
- **Real-time ready** — Socket.io for live map updates and notification badges is trivial to add
- **Deployment is simple** — runs on Railway, Render, or a plain VPS with PM2

Alternatives considered:

| Option | Why Not |
|--------|---------|
| PHP/Laravel | Different language from the frontend, heavier for a capstone team |
| Python/Django | Different language, ORM style is more opinionated |
| Python/FastAPI | Good but adds Python to a JS-only team |
| Firebase | No MySQL, vendor lock-in, harder to document for panel defense |

---

## Recommended Dev Tools

| Tool | Purpose |
|------|---------|
| Postman | Test all API endpoints before wiring the frontend |
| TablePlus or DBeaver | GUI for MySQL during development |
| Railway or PlanetScale | Free MySQL hosting for demo/defense |
| Cloudinary (free tier) | 25GB storage, 25GB bandwidth/month — more than enough |
| PM2 | Process manager for Node.js in production |
| dotenv | Environment variable loading |
| nodemon | Auto-restart during development |

---

## Deployment Target

| Layer | Service |
|-------|---------|
| Backend (Node/Express) | Railway or Render (free tier) |
| Database (MySQL) | Railway MySQL plugin or PlanetScale |
| Image Storage | Cloudinary |
| Frontend (static HTML) | Same Railway service (Express serves `/client` as static) or Netlify |
| Domain | `civilwatch.digos.gov.ph` (if available) or a free subdomain |

---

*CIVILWATCH — University of Mindanao Digos Branch | BS Information Technology Capstone 2026*
