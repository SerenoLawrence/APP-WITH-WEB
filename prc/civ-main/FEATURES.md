# CIVILWATCH — Feature Documentation

> **Community Infrastructure & Environmental Concern Reporting, Management, and Monitoring System**
> Digos City, Davao del Sur · Flutter Prototype v1.0.0

---

## Table of Contents

1. [Authentication](#1-authentication)
2. [Home Dashboard](#2-home-dashboard)
3. [Report Concern Flow](#3-report-concern-flow)
4. [My Reports](#4-my-reports)
5. [Track Report](#5-track-report)
6. [Community Map](#6-community-map)
7. [Notifications](#7-notifications)
8. [Profile](#8-profile)
9. [State Management & Data Layer](#9-state-management--data-layer)
10. [Design System](#10-design-system)
11. [Project Structure](#11-project-structure)
12. [Services Layer](#12-services-layer)
13. [Theme System](#13-theme-system)
14. [Extended Colour Tokens](#14-extended-colour-tokens)
15. [Extended Widget Library](#15-extended-widget-library)
16. [AppIcons Constants](#16-appicons-constants-libcoreconstantsapp_iconsdart)
17. [AppImages Constants](#17-appimages-constants-libcoreconstantsapp_imagesdart)
18. [Legacy / Parallel Screens](#18-legacy--parallel-screens)
19. [Additional Data Models](#19-additional-data-models)
20. ["Others" Category](#20-others-category)
21. [Six-Step Status Flow](#21-six-step-status-flow)
22. [AppState Factory Method](#22-appstate-factory-method)
23. [Updated Project Structure](#23-updated-project-structure)

---

## 1. Authentication

### Splash Screen
- Animated entry screen with CIVILWATCH logo and city tagline
- Auto-advances to Login after animation completes
- Fade transition into the auth flow

### Login Screen
- Philippine 🇵🇭 `+63` prefix with live `9XX XXX XXXX` digit formatter
- Validates 10-digit mobile number starting with `9`
- **Send OTP** button with loading state
- "Already have an account? Login" link (routes existing users past registration)
- Trust badge row: **Secure · Private · Trusted**
- Animated city skyline illustration at the bottom
- Slide + fade entrance animation

### OTP Screen
- 6 individual digit boxes with auto-advance and auto-backspace
- Displays the phone number the code was sent to
- 45-second countdown resend timer
- **Verify** button with loading spinner
- Security note banner: *"For your security, never share your OTP with anyone."*
- **Routing logic:**
  - `isNewUser: true` → navigates to **Register**
  - `isNewUser: false` → navigates directly to **Home**

### Register Screen
Four-step registration form (Step 4 of 4):

| Field | Type | Validation |
|---|---|---|
| Full Name | Text | First + last name required |
| Email Address | Text | Optional — validates format if filled |
| Home Barangay | Dropdown | All 22 Digos City barangays |
| Create 6-Digit PIN | PIN boxes | 6 digits, numeric only |
| Confirm PIN | PIN boxes | Must match Create PIN |
| Privacy Policy + Terms | Checkbox | Required before submit |

- Password strength bar replaced with **6-digit PIN entry** (two rows — create + confirm)
- PIN boxes display `●` obscured characters
- Red mismatch error banner if PINs do not match
- Animated form card with slide/fade entrance
- "Already have an account? Sign in" link

---

## 2. Home Dashboard

### Navigation Shell
- **5-tab bottom navigation:** Home · My Reports · Map (FAB centre button) · Notifications · Profile
- Uses `IndexedStack` — tabs preserve state when switching

### Home Tab
| Section | Description |
|---|---|
| App Bar | CIVILWATCH logo + notification bell with unread count badge |
| Greeting | Time-based greeting (Good morning/afternoon/evening) + user's first name |
| Report a Concern | Dark navy CTA banner — taps into the 5-step report flow |
| My Reports Summary | 4 stat tiles: Pending Validation · In Progress · Resolved · Total Reports |
| Community Map Preview | Mini interactive map card with colour-coded pins, taps to full map |
| Latest Announcements | Scrollable list of city announcements with date |

---

## 3. Report Concern Flow

A 5-step animated wizard. Data is passed forward as `Map<String, dynamic>` through named routes.

### Progress Stepper
```
Category → Concern → Photo → Location → Review
```
Animated connector lines fill green as each step is completed. Active step shows a glow shadow.

---

### Step 1 — Category (`/report/category`)
- Two large animated selection cards
- **Infrastructure** — roads and public infrastructure
- **Environment** — sanitation and waste management
- Animated radio indicator, icon badge, and border on selection
- Cannot proceed without a selection

---

### Step 2 — Concern (`/report/concern`)
Category badge shown at top. Radio-select cards with icon, label, and hint text.

**Infrastructure concerns:**
| Concern | Icon | Hint |
|---|---|---|
| Road Repair | `add_road_rounded` | Potholes, damaged road surface needing repair |
| Road Graveling | `terrain_rounded` | Unpaved or gravel road needs improvement |
| Streetlight / Light Pole Concern | `light_rounded` | Broken, flickering, or missing streetlight |
| Blocked Canal | `water_damage_rounded` | Canal blocked by debris or sediment |
| Others | `more_horiz_rounded` | Other infrastructure concerns not listed above |

**Environment concerns:**
| Concern | Icon | Hint |
|---|---|---|
| Illegal Dumping | `delete_sweep_rounded` | Waste illegally dumped in public areas |
| Garbage Collection | `recycling_rounded` | Missed or irregular garbage collection schedule |

---

### Step 3 — Photo (`/report/photo`)
- **Take Photo** — primary action button
- **Choose from Gallery** — secondary action
- Photo preview with remove (×) button once selected
- Simulated selection in prototype (boolean flag `hasPhoto`)
- Tip banner: *"Make sure the concern is clearly visible in the photo."*
- Photo is **required** to proceed (with skip option)

---

### Step 4 — Location (`/report/location`)
Two location action buttons:

| Button | Behaviour |
|---|---|
| 📍 Use Current Location | Simulates GPS fix at Digos City centre, triggers reverse geocoding |
| 🗺 Pick Location on Map | Toggles inline OpenStreetMap — tap anywhere to drop a pin |

**Map features:**
- Inline `flutter_map` with OpenStreetMap tiles
- Tap-to-place red marker
- "Tap the map to place a marker" hint overlay
- Live geocoding spinner while resolving address

**Auto-filled address card (via Nominatim reverse geocoding):**
```
Street / Area   [editable text field]
Purok           [editable text field]
Barangay        [editable text field]
City            [editable text field]
Province        [editable text field]
```
Falls back to editable fields if geocoding fails, with "Edit manually" badge.

**Additional fields:**
| Field | Type | Required |
|---|---|---|
| Landmark | Text | Optional — hints: Near Barangay Hall, Near Church |
| Additional Details | Multiline text (max 300 chars) | Optional |
| Severity | Chips | Required |

**Severity chips:**
| Level | Colour |
|---|---|
| Low | Green `#16A34A` |
| Medium | Orange `#F59E0B` |
| High | Red `#DC2626` |

Location (pin drop) is **required** to proceed.

---

### Step 5 — Review (`/report/review`)
Modern summary card — read only, no edit buttons.

| Row | Data shown |
|---|---|
| Category | Colour chip (Infrastructure / Environment) |
| Concern | Concern type with icon |
| Photo | Image preview thumbnail or "No photo" warning |
| Location | Full address string (Street, Purok, Barangay, City, Province) |
| Landmark | Shown only if provided |
| Additional Details | Text or "No additional details" placeholder |
| Severity | Colour chip (Low / Medium / High) |

- Animated confirmation checkbox — required before submit
- **Submit Concern** button with loading spinner (1.5s simulated delay)
- Back button returns to Location step

---

### Submitted Screen (`/report/submitted`)
- Elastic scale animation on green checkmark
- Custom city skyline `CustomPainter` illustration
- **Reference number** displayed in `Roboto Mono` (e.g. `CW-2026-00125`)
- Copy-to-clipboard button for reference number
- Submission timestamp
- *"You can track your concern status in My Reports."* tip
- **Go to My Reports** and **Back to Home** buttons

---

## 4. My Reports

- Full searchable list of the current user's submitted concerns
- **Filter tabs:** All · Pending · In Progress · Resolved
- Each card shows: category badge, concern type, barangay, status chip, severity, submitted date
- Empty state with "Report a Concern" shortcut button
- Pull-to-scroll with `BouncingScrollPhysics`
- Taps through to **Track Report** detail view

---

## 5. Track Report

### Track Report Screen
Full detail view of a single concern report:

- Reference number header
- Category + Severity chips
- Status badge with colour coding
- **5-step progress timeline** with animated fill:
  ```
  Submitted → Pending Validation → Assigned to Office → In Progress → Resolved
  ```
- Activity log — timestamped entries for every status change
- Assigned government office card (name, abbreviation, phone number)
- Report location details
- **View on Map** → opens Private Map Screen
- **Demo: Advance Status** button — cycles through all statuses for testing purposes

### Status Update Screen
Dedicated status history and detail view for a single report.

### Private Map Screen
- Full-screen `flutter_map` centred on the report's stored GPS coordinates
- Shows the user's own pin only
- Yellow "Pending Validation — Only you can see this report" banner overlay
- Coordinates displayed in footer

---

## 6. Community Map

- Full-screen interactive OpenStreetMap
- **Colour-coded pins:**
  - Amber — Infrastructure concerns
  - Green — Environment concerns
- Layer toggle buttons to filter by category
- Report count badge
- Mini detail card on pin tap (concern type, barangay, status)
- Privacy note: *"Reports are visible only after validation."*

---

## 7. Notifications

- Grouped notification list: **Today · Yesterday · Earlier**
- Green unread dot indicator per notification
- **Mark All Read** button
- Individual tap marks notification as read
- Auto-generated notifications on:
  - Concern submitted
  - Status changed (Pending Validation, Assigned, In Progress, Resolved)
- Unread count badge on bell icon in Home app bar

---

## 8. Profile

- User card with initials avatar, full name, phone number, barangay + city
- **Activity stats:** Total Concerns · Resolved · Pending
- Menu items:
  - Personal Information
  - Change PIN
  - Notification Settings
  - Privacy & Security
  - About CIVILWATCH
  - Help & Support
- **Log Out** button (red, bottom of screen)

---

## 9. State Management & Data Layer

| Concern | Implementation |
|---|---|
| State management | Singleton `ChangeNotifier` (`AppState`) — no external package |
| Persistence | In-memory only — resets on app restart (prototype) |
| Navigation | Named routes via `RouteGenerator` + `Navigator.pushNamed` |
| Data passing | `Map<String, dynamic>` threaded through route arguments |
| Geocoding | Live Nominatim API (OpenStreetMap) via `http` package |
| Maps | `flutter_map` + `latlong2` + OpenStreetMap tile layer |

### Dummy Data (pre-loaded)
| Dataset | Count |
|---|---|
| User reports | 5 |
| Community reports | 7 |
| Government offices | 4 (CEO, CENRO, CPWD, CDRRMO) |
| City announcements | Seeded in `DummyData` |
| Notifications | Auto-generated on state changes |

### Government Offices
| Abbreviation | Full Name | Handles |
|---|---|---|
| CEO | City Engineering Office | Infrastructure |
| CENRO | City Environment and Natural Resources Office | Environment |
| CPWD | City Public Works Department | Infrastructure + Environment |
| CDRRMO | City Disaster Risk Reduction Office | Infrastructure + Environment |

### Report Status Flow
```
Submitted → Pending Validation → Assigned to Office → In Progress → Resolved
```

### Severity Normalisation
Legacy values are normalised automatically:
```
Minor → Low    |    Moderate → Medium    |    Severe → High
```

---

## 10. Design System

### Colour Palette
| Token | Hex | Usage |
|---|---|---|
| `primary` | `#1B5E20` | Buttons, active states, success |
| `navy` | `#0D2137` | App bar, CTA banner, headings |
| `background` | `#F8FAFC` | Screen backgrounds |
| `white` | `#FFFFFF` | Cards, inputs |
| `infrastructure` | `#F59E0B` | Infrastructure category |
| `environment` | `#16A34A` | Environment category |
| `statusPending` | `#F59E0B` | Pending Validation |
| `statusInProgress` | `#EA580C` | In Progress |
| `statusResolved` | `#16A34A` | Resolved |
| `statusAssigned` | `#2563EB` | Assigned to Office |
| `severityLow` | `#16A34A` | Low severity chip |
| `severityMedium` | `#F59E0B` | Medium severity chip |
| `severityHigh` | `#DC2626` | High severity chip |

### Typography
| Font | Usage |
|---|---|
| **Inter** | All UI text (weights 400–900) |
| **Roboto Mono** | Reference numbers only |

Both loaded via `google_fonts` package.

### Animations
| Animation | Implementation |
|---|---|
| Page transitions | Slide (right→left) for pushes, Fade for root routes |
| Selection cards | `AnimatedContainer` — 200ms `easeOutCubic` |
| Stepper progress | `AnimatedContainer` — 300ms fill |
| Success screen | `ElasticOut` scale + `FadeTransition` |
| Form entrance | `SlideTransition` + `FadeTransition` — 600ms |
| PIN / OTP boxes | Per-box fill + border animation |

### Component Conventions
| Property | Value |
|---|---|
| Card border radius | 16–20px |
| Button height | 52–54px |
| Button border radius | 16px |
| Button elevation shadow | `color.withOpacity(0.3)` at `Offset(0, 4)` |
| Input border radius | 12–14px |
| Spacing unit | 8px base grid |

---

## 11. Project Structure

> **Note:** The full updated structure (including all new directories and files) is documented in [Section 23](#23-updated-project-structure). The abbreviated view below covers the core layout:

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart        # All colour tokens
│   │   ├── app_icons.dart         # IconData constants (NEW)
│   │   ├── app_images.dart        # Network image URL constants (NEW)
│   │   └── app_strings.dart       # All string constants + barangay list
│   ├── routes/
│   │   ├── app_routes.dart        # Named route constants
│   │   └── route_generator.dart   # Route → Widget mapping
│   ├── state/
│   │   └── app_state.dart         # Singleton ChangeNotifier
│   ├── theme/                     # NEW directory
│   │   ├── app_theme.dart
│   │   ├── light_theme.dart
│   │   └── text_styles.dart
│   └── utils/
│       ├── dummy_data.dart        # Seeded prototype data
│       ├── helpers.dart           # Date, category, severity, icon helpers
│       └── validators.dart        # Form validators (phone, PIN, email, name)
│
├── models/
│   ├── report.dart                # IncidentReport + ActivityEntry
│   ├── user.dart                  # AppUser
│   ├── notification_model.dart    # AppNotification
│   └── office.dart                # GovernmentOffice
│
├── screens/
│   ├── splash/splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── otp_screen.dart
│   │   └── register_screen.dart
│   ├── home/home_screen.dart
│   ├── report/
│   │   ├── _report_stepper.dart   # Shared animated stepper widget
│   │   ├── report_category.dart   # Step 1
│   │   ├── report_concern.dart    # Step 2 (current)
│   │   ├── report_issue.dart      # Step 2 (legacy — different issue set)
│   │   ├── report_photo.dart      # Step 3
│   │   ├── report_location.dart   # Step 4 (current — GPS + map + geocoding)
│   │   ├── report_details.dart    # Step 4 (legacy — barangay dropdown)
│   │   ├── report_review.dart     # Step 5
│   │   └── report_submitted.dart  # Success screen
│   ├── my_reports/my_reports_screen.dart
│   ├── track_report/
│   │   ├── track_report_screen.dart
│   │   └── status_update_screen.dart
│   ├── map_preview/private_map_screen.dart
│   ├── community_map/community_map_screen.dart
│   ├── notifications/notification_screen.dart
│   └── profile/profile_screen.dart
│
├── services/                      # NEW directory
│   ├── auth_service.dart
│   ├── notification_service.dart
│   ├── report_service.dart
│   └── semaphore_service.dart
│
└── widgets/
    ├── buttons/
    │   ├── primary_button.dart
    │   ├── secondary_button.dart  # NEW
    │   └── icon_button.dart       # NEW
    ├── cards/                     # NEW directory
    │   ├── activity_card.dart
    │   ├── notification_card.dart
    │   ├── report_card.dart
    │   └── status_card.dart
    ├── common/
    │   ├── app_network_image.dart # NEW
    │   ├── empty_state.dart       # NEW
    │   ├── loading.dart           # NEW
    │   ├── section_title.dart
    │   └── status_chip.dart       # NEW
    ├── inputs/
    │   ├── custom_textfield.dart  # NEW
    │   ├── otp_box.dart
    │   └── search_field.dart      # NEW
    ├── map/
    │   ├── filter_chip.dart
    │   ├── map_marker.dart
    │   └── map_preview.dart
    ├── navigation/
    │   ├── app_bar.dart
    │   └── bottom_nav.dart
    └── timeline/
        └── progress_timeline.dart # NEW
```

---

### Dependencies

```yaml
dependencies:
  flutter_map: ^8.1.1      # Interactive maps
  latlong2: ^0.9.1          # Latitude/longitude types
  google_fonts: ^6.2.1      # Inter + Roboto Mono
  http: ^1.2.2              # Nominatim geocoding API calls + Semaphore OTP
  intl: ^0.19.0             # Date formatting
  url_launcher: ^6.3.1      # External links
  cupertino_icons: ^1.0.8   # iOS-style icons

dev_dependencies:
  flutter_lints: ^6.0.0     # Lint rules
```

---

## 12. Services Layer

A dedicated `lib/services/` directory provides a clean separation between UI and data concerns.

| Service | File | Responsibility |
|---|---|---|
| `AuthService` | `auth_service.dart` | `sendOtp()`, `verifyOtp()`, `logout()`, `isLoggedIn` — all mocked with `Future.delayed` |
| `NotificationService` | `notification_service.dart` | `getNotifications()`, `getUnreadCount()`, `markAllRead()`, `markRead(id)` |
| `ReportService` | `report_service.dart` | `getUserReports()`, `getReportById(id)`, `submitReport(data)`, `updateReportStatus()` |
| `SemaphoreService` | `semaphore_service.dart` | Production-ready Semaphore SMS OTP integration stub (see SEMAPHORE_OTP_PRODUCTION.md) |

### SemaphoreService
Implements the Semaphore Philippine SMS gateway (`/api/v4/otp` endpoint). Currently scaffolded with placeholder credentials. Handles Philippine number normalisation (`09XX…` → `639XX…`, `+63…` → `63…`). Has a 15-second timeout. Returns the generated OTP code as a `String` on success, `null` on failure.

---

## 13. Theme System

### AppTheme (`lib/core/theme/app_theme.dart`)
Full `ThemeData` definition using Material 3. Defines global styles for:
- `ElevatedButton`, `OutlinedButton`, `TextButton`
- `InputDecorationTheme` (filled, rounded, green focus border)
- `CardThemeData` (white, no elevation, divider border)
- `ChipThemeData` (rounded, navy selected state)
- `DividerThemeData`
- `BottomNavigationBarThemeData`
- System UI overlay (transparent status bar, dark icons)

`light_theme.dart` is a convenience re-export of `app_theme.dart`.

### AppTextStyles (`lib/core/theme/text_styles.dart`)
Named static text style constants:

| Style | Font | Size | Weight | Usage |
|---|---|---|---|---|
| `displayLarge` | Inter | 32 | 800 | Large hero text |
| `displayMedium` | Inter | 28 | 700 | Medium display |
| `h1`–`h4` | Inter | 24/20/18/16 | 700/700/600/600 | Section headings |
| `bodyLarge` / `bodyMedium` / `bodySmall` | Inter | 16/14/12 | 400 | Body copy |
| `labelLarge` / `labelMedium` / `labelSmall` | Inter | 14/12/11 | 600/600/500 | Form labels, chips |
| `caption` | Inter | 11 | 400 | Captions, hints |
| `buttonLarge` / `buttonMedium` | Inter | 16/14 | 700/600 | Button text |
| `appBarTitle` | Inter | 18 | 700 | App bar title |
| `navLabel` | Inter | 11 | 500 | Bottom nav labels |
| `refNumber` | Roboto Mono | 18 | 700 | Reference numbers (letter-spacing 1.2) |

---

## 14. Extended Colour Tokens

The actual `AppColors` class includes several tokens not listed in the Section 10 palette:

| Token | Hex | Usage |
|---|---|---|
| `primaryLight` | `#2E7D32` | Green variant |
| `primaryMid` | `#388E3C` | Green mid-tone |
| `primarySurface` | `#E8F5E9` | Light green tint — unread notifications, avatar bg |
| `navyLight` | `#1A3A5C` | Navy variant |
| `statusSubmitted` | `#7C3AED` | Purple — Submitted status |
| `statusSubmittedBg` | `#F5F3FF` | Purple tint |
| `statusPendingBorder` | `#FDE68A` | Amber border |
| `statusInProgressBorder` | `#FED7AA` | Orange border |
| `statusResolvedBorder` | `#BBF7D0` | Green border |
| `statusAssignedBorder` | `#BFDBFE` | Blue border |
| `infrastructureBg` | `#FFFBEB` | Amber tint |
| `environmentBg` | `#F0FDF4` | Green tint |
| `cardShadow` | `rgba(0,0,0,0.06)` | Subtle card drop shadow |
| `loginBg` | `#E8F4FD` | Light blue — login screen background |
| `loginBgDark` | `#BFDBFE` | Darker blue login bg variant |
| `textPrimary` | `#0F172A` | Primary text |
| `textSecondary` | `#64748B` | Secondary text |
| `textHint` | `#94A3B8` | Hint / placeholder text |
| `textDisabled` | `#CBD5E1` | Disabled text / inactive buttons |
| `inputBorder` | `#E2E8F0` | Input field borders |
| `inputFill` | `#F8FAFC` | Input field fill |
| `surface` | `#FFFFFF` | Card surfaces |
| `divider` | `#E2E8F0` | Dividers |

---

## 15. Extended Widget Library

### Buttons

| Widget | File | Description |
|---|---|---|
| `PrimaryButton` | `buttons/primary_button.dart` | Full-width navy button; supports `icon`, `isLoading` spinner, custom `backgroundColor`/`textColor`/`width`/`height`/`borderRadius` |
| `SecondaryButton` | `buttons/secondary_button.dart` | Outlined button, navy border; supports `icon`, custom `borderColor`/`textColor`/`width`/`height` |
| `AppIconButton` | `buttons/icon_button.dart` | Circular icon button; supports optional numeric `badge` (red dot, shows "9+" when >9), `hasBorder`, `backgroundColor`, configurable `size`/`iconSize` |

### Cards

| Widget | File | Description |
|---|---|---|
| `ReportCard` | `cards/report_card.dart` | Report list item: 90×110 photo/icon thumbnail, issue title, status chip, barangay, submitted date, category badge, chevron arrow |
| `ActivityCard` | `cards/activity_card.dart` | Single activity log entry: status-coloured icon circle, connector line (hidden on last item), title with optional "Current" badge, description, formatted timestamp |
| `NotificationCard` | `cards/notification_card.dart` | Notification list item: status icon, title + unread green dot, message, `timeAgo` timestamp. Unread items have a `primarySurface` background |
| `StatusCard` | `cards/status_card.dart` | Current status summary card: large coloured icon circle, status label, message text, optional date row, optional lock icon |

### Common

| Widget | File | Description |
|---|---|---|
| `StatusChip` | `common/status_chip.dart` | Pill chip with coloured dot + status text; `small` prop reduces padding/font size |
| `EmptyState` | `common/empty_state.dart` | Centred empty state: icon circle (primarySurface bg), title, optional subtitle, optional action button |
| `AppLoading` | `common/loading.dart` | Centred green `CircularProgressIndicator` with optional message label |
| `AppNetworkImage` | `common/app_network_image.dart` | `Image.network` wrapper with shimmer placeholder (loading spinner) and broken-image fallback; supports `borderRadius` clipping |

### Inputs

| Widget | File | Description |
|---|---|---|
| `CustomTextField` | `inputs/custom_textfield.dart` | Full-featured `TextFormField` wrapper with label, hint, validator, `prefixWidget`/`suffixWidget`, `inputFormatters`, `readOnly`/`onTap`, multiline, maxLength, obscure text support |
| `SearchField` | `inputs/search_field.dart` | 48px search bar with magnifier prefix icon; live clear (×) button appears when text is present |

### Timeline

| Widget | File | Description |
|---|---|---|
| `ProgressTimeline` | `timeline/progress_timeline.dart` | Horizontally scrollable 5-step progress tracker. Each step shows a coloured icon circle (filled when reached), step label, and a connector line (green if passed, grey if not). The current step shows a "Current" badge. Uses `report.statusIndex` to determine progress. |

### Map Widgets (additions to Section 10)

| Widget | File | Description |
|---|---|---|
| `MapFilterChip` | `map/filter_chip.dart` | Category filter pill for the community map: animated colour fill when active, supports `isFiltersChip` (outlined-only, never filled) |
| `MapMarker` | `map/map_marker.dart` | Reusable teardrop circle-pin widget: colour-coded circle with issue icon, triangle tail via `CustomPainter`, scales up and glows when selected |
| `MapPreviewWidget` | `map/map_preview.dart` | Static non-interactive simulated map using `CustomPainter`: beige background, white roads, blue bezier river, green blocks, coloured pin with tail, decorative zoom buttons |

---

## 16. AppIcons Constants (`lib/core/constants/app_icons.dart`)

Centralised `IconData` constants class (`Icons.*` wrappers) grouped by purpose:

| Group | Constants |
|---|---|
| Navigation | `home`, `homeOutline`, `myReports`, `myReportsOutline`, `map`, `mapOutline`, `notifications`, `notificationsOutline`, `profile`, `profileOutline` |
| Report Actions | `report`, `camera`, `gallery`, `location`, `currentLocation`, `mapSelect`, `description` |
| Status Icons | `submitted`, `pending`, `assigned`, `inProgress`, `resolved` |
| Categories | `infrastructure`, `environment` |
| Issue Types | `streetlight`, `road`, `sidewalk`, `drainage`, `bridge`, `roadSign`, `dumping`, `canal`, `vegetation`, `erosion`, `others` |
| UI Actions | `arrowRight`, `arrowBack`, `arrowForward`, `search`, `filter`, `edit`, `copy`, `layers`, `shield`, `lock`, `send`, `verify`, `close`, `info`, `warning`, `settings`, `help`, `about`, `logout`, `announcement`, `phone`, `crosshair`, `viewAll`, `eye` |

---

## 17. AppImages Constants (`lib/core/constants/app_images.dart`)

All images are loaded from network URLs — no local asset files are bundled. The `assets/` folders are intentionally empty in `pubspec.yaml`.

| Constant | Source | Usage |
|---|---|---|
| `logo` | icons8.com (shield, navy) | App identity icon |
| `logoWhite` | icons8.com (shield, white) | White variant |
| `cityscape` | Unsplash | Login / home background |
| `successIllustration` | icons8.com (bubbles checkmark) | Submitted screen |
| `emptyReports` | icons8.com (nothing found) | Empty state |
| `mapPlaceholder` | Unsplash | Map fallback |

---

## 18. Legacy / Parallel Screens

The codebase contains two parallel implementations of some report steps. Both are wired up via route aliases in `AppRoutes`.

### `ReportIssueScreen` (`report/report_issue.dart`) — Legacy Step 2
An older version of the concern selection step with a different issue set:

**Infrastructure issues:**
| Issue | Icon |
|---|---|
| Broken Streetlight | `light_rounded` |
| Damaged Road | `add_road_rounded` |
| Damaged Sidewalk | `directions_walk_rounded` |
| Blocked Drainage | `water_rounded` |
| Damaged Bridge | `directions_rounded` |
| Road Sign Damage | `signpost_rounded` |
| Others | `more_horiz_rounded` |

**Environment issues:**
| Issue | Icon |
|---|---|
| Illegal Dumping | `delete_rounded` |
| Blocked Canal | `water_damage_rounded` |
| Overgrown Vegetation | `grass_rounded` |
| Soil Erosion | `terrain_rounded` |
| Others | `more_horiz_rounded` |

This screen passes `issue` (not `concern`) as the route argument key.

### `ReportDetailsScreen` (`report/report_details.dart`) — Legacy Step 4
An older version of the location/details step. Key differences from `ReportLocationScreen`:
- Uses a barangay **dropdown** (not GPS/map) as the primary location picker
- Location options: "Use Current Location" toggle vs "Select on Map" toggle (no inline map rendered)
- Severity chips use **Minor / Moderate / Severe** labels (normalised to Low/Medium/High on submit via `AppHelpers.normaliseSeverity()`)
- No address card, no Nominatim geocoding, no purok/city/province fields

### Route Aliases in `AppRoutes`
```dart
static const String reportIssue   = '/report/concern'; // alias for reportConcern
static const String reportDetails  = '/report/location'; // alias for reportLocation
static const String stepIssue      // AppStrings alias for stepConcern
static const String selectTheIssue // AppStrings alias for selectTheConcern
```

---

## 19. Additional Data Models

### `Announcement` (defined in `dummy_data.dart`)
```dart
class Announcement {
  final String id;
  final String title;
  final String body;
  final DateTime date;
}
```
Used by `DummyData.announcements` and rendered in the Home tab's "Latest Announcements" section. Two announcements are seeded.

### `MapPin` (defined in `dummy_data.dart`)
```dart
class MapPin {
  final String id;
  final String reportId;     // links to IncidentReport in AppState
  final String category;     // 'Infrastructure' | 'Environment' | 'Others'
  final String issue;
  final String description;
  final String barangay;
  final String status;
  final String referenceNumber;
  final double lat;
  final double lng;
  final String? imageUrl;
}
```
Used exclusively by `CommunityMapScreen`. `DummyData.communityPins` seeds **7 pins** with coordinates around Digos City. Linked to `DummyData.communityReports` (7 full `IncidentReport` objects) via `reportId`.

---

## 20. "Others" Category

The community map now supports a third report category beyond Infrastructure and Environment:

| Category | Colour | Filter chip icon |
|---|---|---|
| Others | Purple (`#7C3AED`) | `more_horiz_rounded` |

Example seeded "Others" report: **Stray Animals** (Barangay New Visayas) — assigned to City Veterinary Office, status Resolved.

---

## 21. Six-Step Status Flow

The actual status sequence has **six** statuses, not five. "Submitted" is an initial entry-point status distinct from "Pending Validation":

```
Submitted → Pending Validation → Assigned to Office → In Progress → Resolved
```

`IncidentReport.statusOrder` lists all five visible steps. The `Submitted` status is the 0th index and maps to the purple `statusSubmitted` colour. Both `Submitted` and `Pending Validation` cause `report.isPending` to return `true`.

The `ActivityLog` entries always start with two auto-generated entries:
1. `Concern Submitted` (status: `Submitted`)
2. `Pending Validation` (status: `Pending Validation`, +1 minute)

---

## 22. AppState Factory Method

`AppState.buildFromFormData(Map<String, dynamic> data)` is a static factory that constructs an `IncidentReport` from the 5-step report wizard's accumulated route arguments. Key normalisation logic applied:

- Accepts both `concern` and `issue` keys (prefers `concern`)
- Accepts both `additionalDetails` and `description` keys (prefers `additionalDetails`)
- Normalises severity: `Minor → Low`, `Moderate → Medium`, `Severe → High` via `AppHelpers.normaliseSeverity()`
- Falls back to `6.7498, 125.3572` (Digos City centre) if lat/lng are missing
- Generates a reference number client-side via `AppHelpers.generateRefNumber()` if not already present

---

## 23. Updated Project Structure

The actual `lib/` structure differs from Section 11 in several ways:

```
lib/
├── app.dart                           # Root widget — ListenableBuilder + MaterialApp + AppTheme
├── main.dart                          # Entry point — runApp(CivilWatchApp())
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # All colour tokens (extended — see Section 14)
│   │   ├── app_icons.dart             # ← NEW: IconData constants class
│   │   ├── app_images.dart            # ← NEW: Network image URL constants
│   │   └── app_strings.dart           # All string constants + 22 barangay list
│   ├── routes/
│   │   ├── app_routes.dart            # Route constants (includes aliases)
│   │   └── route_generator.dart       # Route factory with slide/fade transitions
│   ├── state/
│   │   └── app_state.dart             # Singleton ChangeNotifier + buildFromFormData()
│   ├── theme/                         # ← NEW directory
│   │   ├── app_theme.dart             # Full Material 3 ThemeData
│   │   ├── light_theme.dart           # Re-export of app_theme.dart
│   │   └── text_styles.dart           # AppTextStyles named constants
│   └── utils/
│       ├── dummy_data.dart            # Seeded data; defines MapPin + Announcement models
│       ├── helpers.dart               # AppHelpers: date, greeting, status/category/severity helpers, showSnack
│       └── validators.dart            # Form validators
│
├── models/
│   ├── report.dart                    # IncidentReport + ActivityEntry
│   ├── user.dart                      # AppUser (firstName + initials + pendingReports getters)
│   ├── notification_model.dart        # AppNotification
│   └── office.dart                    # GovernmentOffice (+ optional email, address fields)
│
├── screens/
│   ├── splash/splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── otp_screen.dart
│   │   └── register_screen.dart
│   ├── home/home_screen.dart          # IndexedStack shell + CustomPainter city/map illustrations
│   ├── report/
│   │   ├── _report_stepper.dart       # Shared animated stepper widget
│   │   ├── report_category.dart       # Step 1
│   │   ├── report_concern.dart        # Step 2 (current) — concern cards with hint text
│   │   ├── report_issue.dart          # Step 2 (legacy) — issue list, different concern set
│   │   ├── report_photo.dart          # Step 3
│   │   ├── report_location.dart       # Step 4 (current) — GPS + inline map + Nominatim
│   │   ├── report_details.dart        # Step 4 (legacy) — barangay dropdown + no geocoding
│   │   ├── report_review.dart         # Step 5
│   │   └── report_submitted.dart      # Success screen
│   ├── my_reports/my_reports_screen.dart
│   ├── track_report/
│   │   ├── track_report_screen.dart
│   │   └── status_update_screen.dart
│   ├── map_preview/private_map_screen.dart
│   ├── community_map/community_map_screen.dart
│   ├── notifications/notification_screen.dart
│   └── profile/profile_screen.dart
│
├── services/                          # ← NEW directory
│   ├── auth_service.dart
│   ├── notification_service.dart
│   ├── report_service.dart
│   └── semaphore_service.dart
│
└── widgets/
    ├── buttons/
    │   ├── primary_button.dart
    │   ├── secondary_button.dart      # ← NEW
    │   └── icon_button.dart           # ← NEW (AppIconButton with badge support)
    ├── cards/                         # ← NEW directory
    │   ├── activity_card.dart
    │   ├── notification_card.dart
    │   ├── report_card.dart
    │   └── status_card.dart
    ├── common/
    │   ├── app_network_image.dart     # ← NEW
    │   ├── empty_state.dart           # ← NEW
    │   ├── loading.dart               # ← NEW (AppLoading)
    │   ├── section_title.dart
    │   └── status_chip.dart           # ← NEW
    ├── inputs/
    │   ├── custom_textfield.dart      # ← NEW
    │   ├── otp_box.dart
    │   └── search_field.dart          # ← NEW
    ├── map/
    │   ├── filter_chip.dart
    │   ├── map_marker.dart
    │   └── map_preview.dart
    ├── navigation/
    │   ├── app_bar.dart               # CivilWatchAppBar (title + optional subtitle + divider)
    │   └── bottom_nav.dart            # CivilWatchBottomNav (Map tab = circular FAB-style)
    └── timeline/
        └── progress_timeline.dart     # ← NEW: horizontal scrollable ProgressTimeline widget
```

---

### Dependencies

```yaml
dependencies:
  flutter_map: ^8.1.1      # Interactive maps
  latlong2: ^0.9.1          # Latitude/longitude types
  google_fonts: ^6.2.1      # Inter + Roboto Mono
  http: ^1.2.2              # Nominatim geocoding + Semaphore OTP
  intl: ^0.19.0             # Date formatting
  url_launcher: ^6.3.1      # External links
  cupertino_icons: ^1.0.8   # iOS-style icons

dev_dependencies:
  flutter_lints: ^6.0.0
```

---

*CIVILWATCH is a prototype. All data is in-memory and resets on restart. No backend, authentication server, or database is connected.*
