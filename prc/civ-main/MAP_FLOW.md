# CivilWatch — Map Feature: Full Structure & Flow

> Generated from codebase scan — Flutter / Dart project  
> App name: **CIVILWATCH** | Location: Digos City, Davao del Sur

---

## 1. Full Project File Structure

```
lib/
├── main.dart                          # Entry point — runApp(CivilWatchApp())
├── app.dart                           # Root widget, MaterialApp, RouteGenerator
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart            # All color tokens (status, category, map pin colors)
│   │   ├── app_icons.dart             # Icon constants
│   │   ├── app_images.dart            # Image asset paths
│   │   └── app_strings.dart           # String constants
│   ├── routes/
│   │   ├── app_routes.dart            # Route name constants (strings)
│   │   └── route_generator.dart       # Route factory — builds all screens from route names
│   ├── state/
│   │   └── app_state.dart             # Singleton ChangeNotifier — all in-memory data
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── light_theme.dart
│   │   └── text_styles.dart
│   └── utils/
│       ├── dummy_data.dart            # All seed data: MapPin list, IncidentReport list
│       ├── helpers.dart               # AppHelpers: color/icon resolvers for categories & status
│       └── validators.dart
│
├── models/
│   ├── notification_model.dart        # AppNotification model
│   ├── office.dart                    # GovernmentOffice model
│   ├── report.dart                    # IncidentReport + ActivityEntry (has lat/lng)
│   └── user.dart                      # AppUser model
│
├── screens/
│   ├── splash/
│   │   └── splash_screen.dart
│   ├── auth/
│   │   ├── login_screen.dart
│   │   ├── otp_screen.dart
│   │   └── register_screen.dart
│   ├── home/
│   │   └── home_screen.dart           # Shell with IndexedStack — embeds CommunityMapScreen
│   ├── community_map/
│   │   └── community_map_screen.dart  # PRIMARY map screen — OSM tile map + all pins
│   ├── map_preview/
│   │   └── private_map_screen.dart    # SECONDARY map screen — single-report location
│   ├── my_reports/
│   │   └── my_reports_screen.dart
│   ├── track_report/
│   │   ├── track_report_screen.dart
│   │   └── status_update_screen.dart
│   ├── report/
│   │   ├── _report_stepper.dart
│   │   ├── report_category.dart
│   │   ├── report_issue.dart
│   │   ├── report_photo.dart
│   │   ├── report_details.dart
│   │   ├── report_review.dart
│   │   └── report_submitted.dart
│   ├── notifications/
│   │   └── notification_screen.dart
│   └── profile/
│       └── profile_screen.dart
│
├── services/
│   ├── auth_service.dart
│   ├── notification_service.dart
│   └── report_service.dart
│
└── widgets/
    ├── buttons/
    │   ├── icon_button.dart
    │   ├── primary_button.dart
    │   └── secondary_button.dart
    ├── cards/
    │   ├── activity_card.dart
    │   ├── notification_card.dart
    │   ├── report_card.dart
    │   └── status_card.dart
    ├── common/
    │   ├── app_network_image.dart
    │   ├── empty_state.dart
    │   ├── loading.dart
    │   ├── section_title.dart
    │   └── status_chip.dart
    ├── inputs/
    │   ├── custom_textfield.dart
    │   ├── otp_box.dart
    │   └── search_field.dart
    ├── map/                           ← MAP WIDGETS
    │   ├── filter_chip.dart           # Category filter pill (All/Infrastructure/Environment/Others)
    │   ├── map_marker.dart            # Reusable teardrop pin widget
    │   └── map_preview.dart           # Static simulated map (CustomPainter, no real tiles)
    ├── navigation/
    │   ├── app_bar.dart
    │   └── bottom_nav.dart            # CivilWatchBottomNav — tab 2 = Community Map
    └── timeline/
        └── progress_timeline.dart
```

---

## 2. Map-Related Files — What Each One Does

| File | Role |
|------|------|
| `lib/screens/community_map/community_map_screen.dart` | Primary full-screen map — OSM tiles, filtered multi-pin view, detail sheet, stats bar |
| `lib/screens/map_preview/private_map_screen.dart` | Single-report location map — OSM tiles, one pin, info sheet, coordinate display |
| `lib/widgets/map/map_preview.dart` | Static simulated map preview (CustomPainter) — used in report review & track-report screens |
| `lib/widgets/map/map_marker.dart` | Reusable teardrop circle-pin widget with category coloring |
| `lib/widgets/map/filter_chip.dart` | Animated filter pill chip for the community map's category bar |
| `lib/core/utils/dummy_data.dart` | Defines `MapPin` struct; seeds `communityPins` (7 map pins) and `communityReports` (full `IncidentReport` objects with lat/lng) |
| `lib/core/state/app_state.dart` | Singleton `ChangeNotifier` — holds all report data; `getById()` used by PrivateMapScreen |
| `lib/core/utils/helpers.dart` | `AppHelpers` — resolves category/status → Color and issue type → IconData for every pin |
| `lib/models/report.dart` | `IncidentReport` model — carries `latitude` and `longitude` fields used for pin placement |
| `lib/core/routes/app_routes.dart` | Defines `/community-map` and `/private-map` route constants |
| `lib/core/routes/route_generator.dart` | Wires route names → screen constructors; extracts `reportId` arg for `PrivateMapScreen` |
| `lib/screens/home/home_screen.dart` | Shell — embeds `CommunityMapScreen(embedded: true)` as tab 2; shows `_MiniMapCard` on home tab |

---

## 3. Data Model — MapPin

Defined inline in `dummy_data.dart`:

```dart
class MapPin {
  final String id;
  final String reportId;      // links to an IncidentReport
  final String issue;         // e.g. "Broken Streetlight"
  final String category;      // "Infrastructure" | "Environment" | "Others"
  final String status;        // "Pending Validation" | "In Progress" | "Resolved" …
  final String description;
  final String barangay;
  final String referenceNumber;
  final double lat;
  final double lng;
  final String? imageUrl;
}
```

`DummyData.communityPins` contains **7 pins** seeded with coordinates around Digos City (lat ≈ 6.74–6.76, lng ≈ 125.35–125.36).

---

## 4. Complete Map Feature Flow — Step by Step

### Step 1 — App Boot

```
main.dart
  └── runApp(CivilWatchApp())          [lib/app.dart]
        └── ListenableBuilder(AppState())
              └── MaterialApp(
                    initialRoute: '/',
                    onGenerateRoute: RouteGenerator.generateRoute
                  )
```

- `AppState()` singleton is constructed → loads `DummyData.myReports`, `DummyData.communityReports`, `DummyData.notifications` into memory.

---

### Step 2 — Splash → Login → Home

```
SplashScreen  →  LoginScreen  →  OtpScreen  →  HomeScreen
     /                /login          /otp           /home
```

Navigation is driven by `Navigator.pushNamed(context, AppRoutes.xxx)`.  
`RouteGenerator` handles every route with either a **slide** or **fade** `PageRouteBuilder` transition.

---

### Step 3 — HomeScreen Shell

**File:** `lib/screens/home/home_screen.dart`

```
HomeScreen
└── Scaffold
    ├── body: IndexedStack
    │     index 0 → _HomeTab          (home content)
    │     index 1 → MyReportsScreen   (embedded: true)
    │     index 2 → CommunityMapScreen(embedded: true)  ← MAP TAB
    │     index 3 → NotificationScreen(embedded: true)
    │     index 4 → ProfileScreen     (embedded: true)
    └── bottomNavigationBar: CivilWatchBottomNav
          onTap: setState(_navIndex = i)
```

**Two entry points to the map from the Home tab (`_HomeTab`):**

| Trigger | Destination |
|---------|------------|
| Tap bottom nav tab 2 | `CommunityMapScreen(embedded: true)` via `IndexedStack` |
| Tap "View Map" action in "Community Map" section | `Navigator.pushNamed(context, AppRoutes.communityMap)` — standalone |
| Tap `_MiniMapCard` | Same as above — `AppRoutes.communityMap` |

---

### Step 4 — Route Resolution for Community Map

**File:** `lib/core/routes/route_generator.dart`

```dart
case AppRoutes.communityMap:   // '/community-map'
  return _slide(const CommunityMapScreen());
```

No arguments required. `CommunityMapScreen` defaults `embedded = false` when navigated to standalone.

---

### Step 5 — CommunityMapScreen Initialisation

**File:** `lib/screens/community_map/community_map_screen.dart`

```
CommunityMapScreen (StatefulWidget)
  State: _CommunityMapScreenState
    _activeFilter = 'All'
    _selectedPin  = null
    _mapController = MapController()   ← flutter_map controller
    _center = LatLng(6.7498, 125.3572) ← Digos City hardcoded
```

**Computed properties set up immediately:**

```dart
List<MapPin> get _filteredPins {
  if (_activeFilter == 'All') return DummyData.communityPins;
  return DummyData.communityPins.where((p) => p.category == _activeFilter).toList();
}

int get _infraCount  → DummyData.communityPins.where(category == 'Infrastructure').length
int get _envCount    → DummyData.communityPins.where(category == 'Environment').length
int get _othersCount → DummyData.communityPins.where(category == 'Others').length
```

---

### Step 6 — CommunityMapScreen Widget Tree

```
Scaffold
└── SafeArea
    └── Column
        ├── _MapHeader           ← Title "Community Map", location label, notification bell
        │     (if !embedded → shows back arrow)
        │
        ├── _FilterRow           ← Horizontal scrollable filter chips
        │     MapFilterChip(label: 'All',            icon: grid_view)
        │     MapFilterChip(label: 'Infrastructure', icon: construction)
        │     MapFilterChip(label: 'Environment',    icon: eco)
        │     MapFilterChip(label: 'Others',         icon: more_horiz)
        │     MapFilterChip(label: 'Filters',        isFiltersChip: true)
        │     onChanged → setState(_activeFilter = f; _selectedPin = null)
        │
        ├── Expanded
        │   └── Stack
        │       ├── FlutterMap                       ← Real OSM tile map
        │       │   ├── MapOptions(
        │       │   │     initialCenter: _center,
        │       │   │     initialZoom: 13.5,
        │       │   │     onTap: setState(_selectedPin = null)
        │       │   │   )
        │       │   ├── TileLayer(
        │       │   │     urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
        │       │   │     userAgentPackageName: 'com.civilwatch.app'
        │       │   │     maxZoom: 19
        │       │   │   )
        │       │   └── MarkerLayer
        │       │         markers: _filteredPins.map((pin) { ... }).toList()
        │       │                                    ← MARKER BUILD LOOP (see Step 7)
        │       │
        │       └── Positioned (right: 14, bottom: adaptive)
        │             GestureDetector → _mapController.move(_center, 13.5)
        │             Container (circle, my_location icon)
        │
        └── AnimatedSwitcher (slide-up transition)
              _selectedPin != null → _PinDetailSheet(pin, onClose, mapController)
              _selectedPin == null → _StatsBar(total, infraCount, envCount, othersCount)
```

---

### Step 7 — Marker Build Loop (The Core Map Function)

This is the heart of the map rendering, inside `MarkerLayer`:

```dart
markers: _filteredPins.map((pin) {

  // 1. Is this pin currently tapped?
  final isSelected = _selectedPin?.id == pin.id;

  // 2. Resolve category → Color  (AppHelpers.getCategoryColor)
  //    Infrastructure → AppColors.infrastructure (orange)
  //    Environment    → AppColors.environment    (green)
  //    Others         → AppColors.statusSubmitted (blue-grey)
  final color = AppHelpers.getCategoryColor(pin.category);

  // 3. Resolve issue type → IconData  (AppHelpers.getIssueIcon)
  //    "Broken Streetlight" → Icons.light_rounded
  //    "Damaged Road"       → Icons.add_road_rounded
  //    "Blocked Drainage"   → Icons.water_rounded
  //    ... (10 issue types mapped)
  final icon = AppHelpers.getIssueIcon(pin.issue);

  // 4. Build a flutter_map Marker
  return Marker(
    point: LatLng(pin.lat, pin.lng),   // position on map
    width:  isSelected ? 58 : 48,
    height: isSelected ? 70 : 58,
    alignment: Alignment.bottomCenter,
    child: GestureDetector(
      onTap: () => _onPinTap(pin),     // toggles _selectedPin
      child: _TeardropPin(
        color: color,
        icon: icon,
        isSelected: isSelected,
      ),
    ),
  );

}).toList()
```

---

### Step 8 — _TeardropPin Widget

```
_TeardropPin (StatelessWidget)
└── SizedBox(width: size, height: size * 1.3)
    └── Stack(alignment: Alignment.topCenter)
        ├── Container(             ← Circle head
        │     shape: BoxShape.circle,
        │     color: category color,
        │     border: white stroke,
        │     boxShadow: colored glow,
        │     child: Icon(issue icon, color: white)
        │   )
        └── Positioned(bottom: 0)  ← Triangle tail
              CustomPaint(_TailPainter)
                  Path: moveTo(0,0) → lineTo(w,0) → lineTo(w/2, h) → close()
```

Size scales up (`48 → 58`) and glow intensifies (`blurRadius 8 → 14`) when selected.

---

### Step 9 — Pin Tap → Detail Sheet

When a user taps a pin, `_onPinTap(pin)` runs:

```dart
void _onPinTap(MapPin pin) {
  setState(() {
    // Tap same pin again → deselect. Tap different pin → select new one.
    _selectedPin = _selectedPin?.id == pin.id ? null : pin;
  });
}
```

`AnimatedSwitcher` at the bottom of the column slides up `_PinDetailSheet`:

```
_PinDetailSheet
└── Container (white, rounded top corners, shadow)
    ├── Drag handle bar
    ├── Row
    │   ├── Image (90×90, from pin.imageUrl or placeholder)
    │   ├── Column
    │   │   ├── Category icon bubble (AppHelpers.getCategoryBgColor + getIssueIcon)
    │   │   ├── Issue title text
    │   │   ├── Status badge (AppHelpers.getStatusBgColor + getStatusColor)
    │   │   └── Reference number
    │   └── Close button → setState(_selectedPin = null)
    ├── "Details" section (description text, barangay with location icon)
    ├── "Location Preview" section
    │   └── MapPreviewWidget (static simulated map, non-interactive)
    └── Action buttons row
        ├── "View on Map"      → Navigator.pushNamed(AppRoutes.privateMap, args: {reportId})
        └── "View Full Details"→ Navigator.pushNamed(AppRoutes.trackReport, args: {reportId, readOnly: true})
```

---

### Step 10 — Route Resolution for Private Map

**File:** `lib/core/routes/route_generator.dart`

```dart
case AppRoutes.privateMap:   // '/private-map'
  final args = settings.arguments as Map<String, dynamic>? ?? {};
  return _slide(PrivateMapScreen(reportData: args));
```

`args` carries `{ 'reportId': pin.reportId }`.

---

### Step 11 — PrivateMapScreen

**File:** `lib/screens/map_preview/private_map_screen.dart`

```
PrivateMapScreen (StatelessWidget)
  reportData: { reportId: '...', readOnly?: true }
```

**Data resolution:**

```dart
IncidentReport? _getReport() {
  final id = reportData['reportId'] as String?;
  if (id != null) return AppState().getById(id);         // checks myReports + communityReports
  return AppState().reports.isNotEmpty ? AppState().reports.first : null;
}
```

`AppState.getById()` searches `_reports` first, then `_communityReports`.

**Widget tree:**

```
Scaffold
├── AppBar  ("Report Location", back arrow)
└── body: Column
    ├── [Conditional] Pending warning banner
    │     (shown when !readOnly && status is Pending/Submitted)
    │
    ├── Expanded
    │   └── Stack
    │       ├── FlutterMap
    │       │   ├── MapOptions(
    │       │   │     initialCenter: LatLng(report.latitude, report.longitude),
    │       │   │     initialZoom: 15.5,
    │       │   │     interactionOptions: InteractiveFlag.all  ← fully interactive
    │       │   │   )
    │       │   ├── TileLayer (same OSM URL as CommunityMap)
    │       │   └── MarkerLayer
    │       │         markers: [ single Marker at reportLatLng ]
    │       │           child: Column
    │       │             ├── Popup bubble (Container with report.issue label)
    │       │             ├── Pin circle (status color, issue icon, white border, glow)
    │       │             └── Triangle tail (_TailPainter, status color)
    │       │
    │       └── Positioned (bottom: 0, full width)
    │             Bottom info sheet
    │               ├── _InfoRow: Barangay + "Digos City"
    │               ├── _InfoRow: Coordinates (lat, lng to 4 decimals)
    │               └── _InfoRow: Submitted date (AppHelpers.formatDateTime)
    │
    └── Container (white, bottom bar)
          ElevatedButton.icon → Navigator.pop(context)
          "Back to Report" with arrow icon
```

---

### Step 12 — Static Map Preview (Non-Route Path)

**File:** `lib/widgets/map/map_preview.dart` — `MapPreviewWidget`

Used in `_PinDetailSheet` (step 9) and inside `TrackReportScreen` / `ReportReviewScreen`.  
This is **not a real map** — it is a `CustomPainter`-drawn simulation:

```
MapPreviewWidget
└── ClipRRect(borderRadius: 16)
    └── SizedBox(height: configurable)
        └── Stack
            ├── _SimulatedMapBackground
            │   └── CustomPaint(_MapPainter)
            │       Draws: beige background, white roads (horizontal + vertical + diagonal),
            │              blue curved river (quadratic bezier), green block fills
            │
            ├── [if isBlurred] BackdropFilter(blur: 3)
            │
            ├── Center
            │   └── Column
            │       ├── [if showPopup] _PinPopup(issue, status)
            │       └── _MapPin(status, issue)
            │           ├── Colored circle (AppHelpers.getStatusColor)
            │           ├── Issue icon (AppHelpers.getIssueIcon)
            │           └── Triangle tail (_PinTailPainter)
            │
            └── Positioned (right: 10, bottom: 10)
                  Column [ _MapButton(+), _MapButton(-) ]  ← decorative zoom buttons
```

---

## 5. Filter Flow — Category Filtering

```
User taps filter chip
  └── _FilterRow.onChanged(filter)
        └── setState(() {
              _activeFilter = filter;    // e.g. 'Infrastructure'
              _selectedPin  = null;      // clear any open detail sheet
            })
            → Flutter rebuild triggered
            → _filteredPins getter re-evaluates
            → MarkerLayer re-maps only matching pins
            → _StatsBar always shows global counts (not filtered)
```

Filter options and their `AppColors`:

| Filter | Color | Icon |
|--------|-------|------|
| All | Navy (`AppColors.navy`) | `grid_view_rounded` |
| Infrastructure | Orange (`AppColors.infrastructure`) | `construction_rounded` |
| Environment | Green (`AppColors.environment`) | `eco_rounded` |
| Others | Blue-grey (`AppColors.statusSubmitted`) | `more_horiz_rounded` |
| Filters (no-op) | Outlined, never filled | `tune_rounded` |

---

## 6. State Management Summary

The app uses **no BLoC, Cubit, or Provider**. State is a plain singleton `ChangeNotifier`:

```
AppState (singleton)
  _reports           : List<IncidentReport>   ← from DummyData.myReports
  _communityReports  : List<IncidentReport>   ← from DummyData.communityReports
  _notifications     : List<AppNotification>

  getById(id)        → searches both lists, returns IncidentReport?
  addReport(r)       → inserts into _reports, fires notifyListeners()
  updateStatus(id)   → mutates status + activityLog, fires notifyListeners()
```

`CommunityMapScreen` does **not** listen to `AppState` — it reads `DummyData.communityPins` directly (static data).  
`PrivateMapScreen` reads from `AppState().getById()` — so it always reflects the latest status.

---

## 7. Navigation Map (All Routes)

```
/                   → SplashScreen
/login              → LoginScreen
/otp                → OtpScreen(phoneNumber)
/register           → RegisterScreen
/home               → HomeScreen  (IndexedStack shell)

/report/category    → ReportCategoryScreen
/report/issue       → ReportIssueScreen(category)
/report/photo       → ReportPhotoScreen(reportData)
/report/details     → ReportDetailsScreen(reportData)
/report/review      → ReportReviewScreen(reportData)
/report/submitted   → ReportSubmittedScreen(reportData)

/my-reports         → MyReportsScreen
/track-report       → TrackReportScreen(reportData)
/status-update      → StatusUpdateScreen(reportData)

/community-map  ──► CommunityMapScreen()               ← MAP 1
/private-map    ──► PrivateMapScreen(reportData)        ← MAP 2

/notifications      → NotificationScreen
/profile            → ProfileScreen
```

---

## 8. Key Dependencies (Map-Specific)

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_map` | (pubspec) | Real interactive OSM tile map widget (`FlutterMap`, `TileLayer`, `MarkerLayer`, `MapController`) |
| `latlong2` | (pubspec) | `LatLng` coordinate type used for pin positions and map center |
| `google_fonts` | (pubspec) | `GoogleFonts.inter(...)` — all text inside map screens |

Tile source: **OpenStreetMap** — `https://tile.openstreetmap.org/{z}/{x}/{y}.png`  
No API key required. No caching layer. Tiles fetched at runtime.

---

## 9. End-to-End Flow Summary (Shortest Path)

```
1.  main.dart            → runApp(CivilWatchApp)
2.  app.dart             → MaterialApp, AppRoutes.splash initial route
3.  splash_screen.dart   → auto-navigates to /login
4.  login_screen.dart    → pushNamed('/otp')
5.  otp_screen.dart      → pushNamed('/home')
6.  home_screen.dart     → IndexedStack loads CommunityMapScreen (tab 2, embedded)
                           OR user taps "View Map" / MiniMapCard → pushNamed('/community-map')
7.  route_generator.dart → builds CommunityMapScreen()
8.  community_map_screen.dart
      a. State init: _activeFilter='All', _mapController created
      b. DummyData.communityPins loaded (7 MapPin objects)
      c. FlutterMap renders with TileLayer (OSM tiles fetched over network)
      d. MarkerLayer.markers = _filteredPins.map((pin) → Marker(_TeardropPin))
      e. User taps filter chip → setState → _filteredPins rebuilt → markers rebuilt
      f. User taps pin → _onPinTap → _selectedPin set → AnimatedSwitcher shows _PinDetailSheet
9.  _PinDetailSheet
      a. Shows image, issue, status, reference number, description, location, map preview
      b. "View on Map" → pushNamed('/private-map', args: {reportId})
      c. "View Full Details" → pushNamed('/track-report', args: {reportId, readOnly: true})
10. route_generator.dart → builds PrivateMapScreen(reportData: {reportId: '...'})
11. private_map_screen.dart
      a. AppState().getById(reportId) → resolves IncidentReport (lat, lng, issue, status)
      b. FlutterMap at zoom 15.5, centered on report.latitude / report.longitude
      c. Single Marker: popup label + colored pin circle + triangle tail
      d. Bottom sheet: barangay, coordinates, submitted date
      e. "Back to Report" → Navigator.pop()
```
