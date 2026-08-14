# CIVILWATCH — Recent Changes Log

> Last Updated: August 14, 2026
> Session: Auth Flow Redesign + Visitor Mode + Forgot Password

---

## Summary

This session redesigned the entire Flutter app entry flow. The app now launches to a **Landing Screen** instead of going straight to login. Visitors can browse the map and reports without an account. The auth flow was rebuilt from scratch: Login uses phone + 6-digit PIN (no OTP), and Register collects details then verifies phone via OTP. A full 10-state Forgot Password flow was added as a bottom sheet modal.

---

## 1. New Files Created

### `lib/screens/landing/landing_screen.dart`
The new app launch screen (replaces going straight to login).

- CIVILWATCH logo + city name + tagline
- Three feature highlight icons (Interactive Map, Location Pins, Filter & Navigate)
- **Explore as Visitor** button — sets `AppState.isGuest = true`, routes to `VisitorShell`
- **Login / Register** button — routes to `LoginScreen`
- City skyline bottom illustration
- University credit footer
- Entrance fade + slide animation

---

### `lib/screens/visitor/visitor_shell.dart`
Guest mode container with bottom navigation.

- Three tabs: **Map** (community map), **Reports** (public list), **About**
- **Login** shortcut button in bottom nav (4th item, navy)
- Persistent **GuestBanner** at top of non-map tabs — "Browsing as Guest" + "Login / Register" pill
- `GuestBanner` exported as public widget so other visitor screens can reuse it
- Tapping Login calls `AppState().exitGuest()` then routes to `LoginScreen(fromVisitor: true)`

---

### `lib/screens/visitor/visitor_reports_screen.dart`
Public read-only report list for guests.

- Header: "Recent Reports" + **Track** button (top right) → `TrackByReferenceScreen`
- Search field (searches issue, barangay, reference number)
- Filter chips: All · Infrastructure · Environment
- Status legend (Pending · In Progress · Resolved dots)
- Report cards: category icon strip, issue title, status badge, barangay, date, reference number
- Tapping a card → `TrackReportScreen` with `readOnly: true`
- Empty state when no results

---

### `lib/screens/visitor/visitor_about_screen.dart`
System info screen for guests.

- Logo + app name
- "What is CIVILWATCH?" section card
- "What you can do as a Visitor" — Map, Reports, Track by Reference
- "Why register?" — Submit Reports, Track, Notifications
- Login / Register CTA button
- Track by Reference No. outlined button
- University / capstone credits footer

---

### `lib/screens/visitor/track_by_reference_screen.dart`
Look up any report by reference number — **no login required**.

- Instruction card (green tinted)
- Monospace text input with `CW-YYYY-#####` auto-formatter
- Search button (disabled until input is non-empty)
- **Result card** when found:
  - Category icon, issue title, status badge
  - Reference number (Roboto Mono), location, date, assigned office
  - Compact 5-step progress timeline (Submitted → Pending → Assigned → In Progress → Resolved)
  - "View Full Details" button → `TrackReportScreen`
- **Not Found card** (red) when reference doesn't exist
- **Placeholder hint** before any search

---

### `lib/screens/auth/forgot_password_flow.dart`
Full forgot password flow as a bottom sheet. 10 modal states driven by one `_FpState` enum.

| State | Description |
|---|---|
| `enterPhone` | Enter mobile number + Send OTP button + Cancel |
| `otpSent` | ✅ "OTP Sent!" success modal + Continue + Resend (disabled) |
| `enterOtp` | 6-box OTP input + resend timer + Verify button |
| `pleaseWait` | ⚠️ "Please wait X seconds" warning modal |
| `otpResent` | ✅ "OTP Resent!" success modal |
| `invalidOtp` | ❌ "Invalid OTP" error modal + Try Again (red) |
| `setNewPin` | Two 6-digit PIN fields + Reset Password button + hint |
| `resetSuccess` | ✅ "Password Reset!" success + Go to Login |
| `genericError` | ❌ "Something went wrong" + Try Again (red) |

- All states share `_SheetWrapper` (white card, drag handle, × close button)
- `AnimatedSwitcher` fade between states
- `showForgotPasswordFlow(context)` is the public entry point called from login

---

## 2. Files Modified

### `lib/screens/auth/login_screen.dart` — **Full rewrite**

**Before:** Phone number entry → Send OTP → OTP screen

**After:** Phone number + **Password** (6-digit PIN) → Login button

Changes:
- Removed OTP send logic entirely from login
- Added `_PinPasswordField` — single obscured numeric input (6 digits), show/hide toggle
- "Forgot Password?" now calls `showForgotPasswordFlow(context)` (was a TODO comment)
- "Don't have an account? **Register**" link at bottom → `AppRoutes.register`
- Removed "Already have an account? Login" link (reversed — login is now the default screen)
- Added `fromVisitor` bool param — shows "Continue Browsing" back button when `true`
- All `withOpacity()` replaced with `withValues(alpha:)` (deprecation fix)
- Duplicate `import 'package:flutter/material.dart'` removed

---

### `lib/screens/auth/register_screen.dart` — **Updated**

Changes:
- Added **Mobile Number** field at top of form (phone + +63 prefix)
- Register button now navigates to `OtpScreen` (to verify phone) instead of directly to Home
- Header step label changed from "Step 4 of 4 · Registration" → "Step 1 of 2 · Create Account"
- Added `_PhonePrefixWidget` and `_PhoneFormatter` helper classes at bottom of file
- Added `_phoneCtrl` controller with proper `dispose()`
- Removed unused `_currentPin` getter
- Removed unused `isFocused` local variable

---

### `lib/screens/auth/otp_screen.dart` — **Minor update**

Changes:
- Subtitle text updated: "Enter the 6-digit code we sent to verify your phone for registration."
- `withOpacity()` replaced with `withValues(alpha:)` (deprecation fix)

---

### `lib/screens/splash/splash_screen.dart` — **Route target changed**

Before: `Navigator.pushReplacementNamed(context, AppRoutes.login)`
After: `Navigator.pushReplacementNamed(context, AppRoutes.landing)`

---

### `lib/core/routes/app_routes.dart` — **New route constants added**

```dart
static const String landing          = '/landing';
static const String visitor          = '/visitor';
static const String trackByReference = '/track-by-reference';
```

---

### `lib/core/routes/route_generator.dart` — **New routes wired**

Added:
- `AppRoutes.landing` → `LandingScreen`
- `AppRoutes.visitor` → `VisitorShell`
- `AppRoutes.trackByReference` → `TrackByReferenceScreen`
- `AppRoutes.login` now passes `fromVisitor` bool from route args to `LoginScreen`
- Cleaned up inline comments, removed legacy step comments

---

### `lib/core/state/app_state.dart` — **Guest mode added**

New fields and methods:
```dart
bool get isGuest
void enterAsGuest()
void exitGuest()
List<IncidentReport> get communityReportsPublic
IncidentReport? getByReference(String refNumber)
```

- `enterAsGuest()` — sets `_isGuest = true`, notifies listeners
- `exitGuest()` — sets `_isGuest = false`, notifies listeners
- `communityReportsPublic` — exposes `_communityReports` to visitor screens
- `getByReference()` — searches both `_reports` and `_communityReports` by reference number (case-insensitive)

---

### `lib/screens/report/report_category.dart` — **Bug fixes**

Fixed errors from previous session:
- `_ReportNavBar` constructor syntax was broken (used `:` chaining instead of named params)
- `nextLabel`, `nextColor`, `onBack` fields were non-`final` (broke `const` constructor)
- Removed unused params `onBack`, `nextLabel`, `nextColor` (were never passed at call site)
- Hardcoded defaults inline: "Next" label, `AppColors.primary` color, `Navigator.pop` back action
- 3× `withOpacity()` → `withValues(alpha:)` (deprecation fix)

---

## 3. New App Flow (After This Session)

```
Splash (3s)
    │
    ▼
Landing Screen
    │
    ├── Explore as Visitor
    │       │
    │       ▼
    │   VisitorShell  ──── Map tab (community map, read-only)
    │       │         ──── Reports tab (public list + track by ref)
    │       │         ──── About tab (system info + register CTA)
    │       │
    │       └── Login / Register button → LoginScreen(fromVisitor: true)
    │
    └── Login / Register
            │
            ▼
        LoginScreen
            │ phone + 6-digit PIN → Login → Home
            │
            ├── Forgot Password? → ForgotPasswordFlow (bottom sheet)
            │       │
            │       ├── Enter Phone → Send OTP
            │       ├── OTP Sent modal → Continue
            │       ├── Enter OTP → Verify
            │       │   ├── Too soon → Please Wait modal
            │       │   ├── Resend → OTP Resent modal
            │       │   └── Wrong → Invalid OTP modal
            │       ├── Set New PIN (6-digit)
            │       └── Password Reset! modal → Go to Login
            │
            └── Don't have an account? Register
                    │
                    ▼
                RegisterScreen
                (phone + name + barangay + create PIN + confirm PIN)
                    │
                    ▼
                OtpScreen (Step 2 of 2 · verify phone)
                    │
                    ▼
                  Home
```

---

## 4. Diagnostic Status (All Clean)

| File | Errors | Warnings |
|---|---|---|
| `login_screen.dart` | 0 | 0 |
| `register_screen.dart` | 0 | 0 |
| `otp_screen.dart` | 0 | 0 |
| `forgot_password_flow.dart` | 0 | 0 |
| `landing_screen.dart` | 0 | 0 |
| `visitor_shell.dart` | 0 | 0 |
| `visitor_reports_screen.dart` | 0 | 0 |
| `visitor_about_screen.dart` | 0 | 0 |
| `track_by_reference_screen.dart` | 0 | 0 |
| `report_category.dart` | 0 | 0 |
| `route_generator.dart` | 0 | 0 |
| `app_routes.dart` | 0 | 0 |
| `app_state.dart` | 0 | 0 |

---

## 5. Pending (Next Session)

| # | Task | Notes |
|---|---|---|
| 1 | Setup Laravel `.env` + run migrations + seed + serve | Backend is fully built, just needs DB setup |
| 2 | Wire Flutter auth to Laravel API | Replace all `Future.delayed` mocks with real HTTP calls |
| 3 | Add `flutter_secure_storage` for token persistence | Sanctum token from Laravel |
| 4 | Add `image_picker` for real photo capture | Step 3 of report flow |
| 5 | Add `geolocator` + `permission_handler` for real GPS | Step 4 of report flow |
| 6 | Wire report submission to `POST /api/mobile/reports` | Multipart with photo |
| 7 | Wire My Reports, Track Report, Community Map to API | Replace AppState dummy data |
| 8 | Wire Notifications to API | Replace dummy notifications |
| 9 | Connect Web Admin to Laravel API | Replace static JSON |
| 10 | CEO + CENRO Settings pages | Currently placeholder |
| 11 | After photo upload on report-details (web admin) | UI shell exists |
| 12 | SMS OTP via Semaphore (real provider) | OTP currently returned in API response |

---

*CIVILWATCH — University of Mindanao Digos Branch | BS Information Technology Capstone 2026*
*Proponents: Borinaga · Mag-Usara · Sereno | Adviser: Cyvil Dave Dasargo, MIT*
