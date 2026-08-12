# Semaphore SMS OTP — Production Integration Guide

> **Status: Future Task** — OTP screen is currently mocked (fake delay + auto-navigate).  
> This document covers everything needed to wire up real SMS OTP via [Semaphore](https://semaphore.co/docs) when going to production.  
> Semaphore is a Philippine SMS gateway — perfect for this app since it targets Digos City residents.

---

## 1. What the Current OTP Screen Does (Mock)

**File:** `lib/screens/auth/otp_screen.dart`

| What it does now | What it should do in production |
|-----------------|--------------------------------|
| Shows a 28-second countdown timer | Same — driven by real SMS delivery |
| `_verify()` waits 1.4s then navigates to `/home` | Must call Semaphore to generate OTP, then verify the code the user typed |
| `_resend()` just resets the timer | Must call Semaphore `/api/v4/otp` again |
| No real SMS is sent | Real SMS sent to `widget.phoneNumber` |
| Any 6-digit input passes | Must match the code returned by Semaphore |

---

## 2. Semaphore API Overview

**Base URL:** `https://api.semaphore.co/api/v4`  
**Auth:** API key passed as a POST body parameter (`apikey`)  
**Philippine numbers only**

### Key Endpoints

| Endpoint | Method | Purpose | Rate Limit |
|----------|--------|---------|-----------|
| `/messages` | POST | Send a regular SMS | 120 calls/min |
| `/otp` | POST | Send OTP SMS (dedicated OTP route) | **Not rate limited** |
| `/priority` | POST | Send time-sensitive SMS (bypasses queue) | Not rate limited |
| `/messages` | GET | Retrieve sent messages | 30 calls/min |
| `/account` | GET | Check credit balance | 2 calls/min |

> **Use `/api/v4/otp` for the OTP screen** — it routes through a dedicated SMS lane that stays up even when telcos are under heavy load. Costs 2 credits per SMS (vs 1 credit for regular).

---

## 3. The OTP Endpoint

**POST** `https://api.semaphore.co/api/v4/otp`

### Request Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `apikey` | Yes | Your Semaphore API key (from dashboard) |
| `number` | Yes | Recipient phone number (e.g. `639998887777`) |
| `message` | Yes | Message body — use `{otp}` as placeholder for the auto-generated code |
| `sendername` | No | What the recipient sees as sender (defaults to your registered sender name) |
| `code` | No | Provide your own OTP code — skip this to let Semaphore auto-generate one |

### Message Placeholder

```
"Your CivilWatch OTP is: {otp}. Valid for 5 minutes. Do not share this code."
```

Semaphore replaces `{otp}` with a 6-digit code automatically. The actual code used is returned in the response.

### Response

```json
[
  {
    "message_id": 12345,
    "user_id": 54321,
    "user": "you@email.com",
    "account_id": 987654,
    "account": "CivilWatch",
    "recipient": "639998887777",
    "message": "Your CivilWatch OTP is: 332200. Valid for 5 minutes.",
    "code": 332200,
    "sender_name": "CIVILWTCH",
    "network": "Globe",
    "status": "Pending",
    "type": "Single",
    "source": "Api",
    "created_at": "2026-01-01 10:00:00",
    "updated_at": "2026-01-01 10:00:00"
  }
]
```

**The `code` field is the OTP to verify against what the user types.**

### Message Status Values

| Status | Meaning |
|--------|---------|
| `Queued` | Message is queued to be sent |
| `Pending` | Message is in transit to the network |
| `Sent` | Successfully delivered to the network |
| `Failed` | Rejected by network — will be refunded |
| `Refunded` | Credits returned to your balance |

---

## 4. Phone Number Format

Semaphore expects **Philippine international format**:

| Input from user | Convert to |
|----------------|-----------|
| `09998887777` | `639998887777` |
| `+639998887777` | `639998887777` |
| `9998887777` | `639998887777` |

```dart
// Utility to normalize PH numbers for Semaphore
String toSemaphoreFormat(String phone) {
  phone = phone.replaceAll(RegExp(r'\s+|-|\(|\)'), ''); // strip spaces/dashes
  if (phone.startsWith('+63')) return phone.substring(1); // +639... → 639...
  if (phone.startsWith('0'))   return '63${phone.substring(1)}'; // 09... → 639...
  if (phone.startsWith('9'))   return '63$phone'; // 9... → 639...
  return phone;
}
```

---

## 5. What to Build — Step by Step

### Step 1 — Add `http` package

Add to `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.2.2
```

Then run `flutter pub get`.

---

### Step 2 — Create the Semaphore Service

Create `lib/services/semaphore_service.dart`:

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class SemaphoreService {
  static const String _baseUrl = 'https://api.semaphore.co/api/v4';

  // TODO: Move API key to a secure backend — never hardcode in app
  // For production, call YOUR backend which holds the key and calls Semaphore
  static const String _apiKey = 'YOUR_SEMAPHORE_API_KEY';
  static const String _senderName = 'CIVILWTCH'; // max 11 chars, registered in dashboard

  /// Sends an OTP SMS and returns the generated code.
  /// Returns null if the request failed.
  static Future<String?> sendOtp(String phoneNumber) async {
    final normalizedNumber = _toSemaphoreFormat(phoneNumber);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/otp'),
        body: {
          'apikey': _apiKey,
          'number': normalizedNumber,
          'message': 'Your CivilWatch verification code is: {otp}. '
              'Valid for 5 minutes. Do not share this code.',
          'sendername': _senderName,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          // code is returned as int — convert to String for comparison
          return data[0]['code'].toString();
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  static String _toSemaphoreFormat(String phone) {
    phone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (phone.startsWith('+63')) return phone.substring(1);
    if (phone.startsWith('0'))   return '63${phone.substring(1)}';
    if (phone.startsWith('9'))   return '63$phone';
    return phone;
  }
}
```

---

### Step 3 — Update OtpScreen State

Replace the mock `_verify()` and `_resend()` logic in `otp_screen.dart`:

```dart
// Add to state variables:
String? _expectedOtp;   // stores the code returned by Semaphore
bool _sendFailed = false;

// Call this on initState instead of just _startTimer():
@override
void initState() {
  super.initState();
  _sendOtp();            // ← real SMS send on screen open
  _startTimer();
  // ... animation setup unchanged
}

Future<void> _sendOtp() async {
  final code = await SemaphoreService.sendOtp(widget.phoneNumber);
  if (mounted) {
    setState(() {
      _expectedOtp = code;
      _sendFailed = code == null;
    });
  }
}

// Replace the mock _resend():
void _resend() async {
  setState(() {
    _resendSeconds = 60;   // give more time on resend
    _sendFailed = false;
  });
  _startTimer();
  final code = await SemaphoreService.sendOtp(widget.phoneNumber);
  if (mounted) {
    setState(() {
      _expectedOtp = code;
      _sendFailed = code == null;
    });
  }
}

// Replace the mock _verify():
void _verify() async {
  if (_otp.length != 6) {
    // show "enter 6 digits" snackbar — same as current
    return;
  }

  if (_expectedOtp == null) {
    // OTP was never sent or failed
    AppHelpers.showSnack(context, 'OTP not received. Please resend.', isError: true);
    return;
  }

  if (_otp != _expectedOtp) {
    AppHelpers.showSnack(context, 'Incorrect OTP. Please try again.', isError: true);
    return;
  }

  // ── OTP matched ──────────────────────────────────────────────────
  setState(() => _isLoading = true);
  await Future.delayed(const Duration(milliseconds: 400)); // brief UX delay
  if (mounted) {
    setState(() => _isLoading = false);
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
  }
}
```

---

### Step 4 — Handle Send Failure in UI

Add an error banner to the build method when `_sendFailed == true`:

```dart
if (_sendFailed)
  Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: const Color(0xFFFEE2E2),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color(0xFFFCA5A5)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline_rounded, color: Color(0xFFDC2626), size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            'Failed to send OTP. Check your connection and tap Resend.',
            style: GoogleFonts.inter(fontSize: 12, color: Color(0xFFDC2626)),
          ),
        ),
      ],
    ),
  ),
```

---

## 6. Security Checklist for Production

> **Never ship the API key inside the Flutter app.** Anyone can decompile the APK and extract it.

### Recommended Architecture

```
Flutter App
    │
    │  POST { phoneNumber }
    ▼
Your Backend (Node.js / Laravel / Django)
    │  Holds SEMAPHORE_API_KEY in environment variable
    │  Generates OTP, stores hash in DB with expiry
    │  Calls Semaphore /api/v4/otp
    │
    ▼
Semaphore API → SMS to user
    │
    └── Flutter app sends { phoneNumber, otpCode } to your backend
        Backend verifies hash, issues auth token
        Flutter receives token, navigates to /home
```

### Checklist

- [ ] API key stored in backend environment variable (not in app)
- [ ] OTP has expiry (5 minutes recommended)
- [ ] OTP is single-use — invalidate after successful verify
- [ ] Rate limit OTP requests per phone number on your backend (e.g. max 3 per 10 minutes)
- [ ] Log all OTP requests with timestamps for audit
- [ ] Use HTTPS for all API calls (Semaphore enforces this)
- [ ] Register your Sender Name in Semaphore dashboard before going live
- [ ] Test on both Globe and Smart numbers before launch

---

## 7. Rate Limits Reference

| Endpoint | Limit |
|----------|-------|
| `/api/v4/messages` POST | 120 requests/minute |
| `/api/v4/otp` POST | **No rate limit** |
| `/api/v4/priority` POST | **No rate limit** |
| `/api/v4/messages` GET | 30 requests/minute |
| `/api/v4/account` GET | 2 requests/minute |

Rate limit info is returned in response headers:
```
X-RateLimit-Limit     → 30
X-RateLimit-Remaining → 28
Retry-After           → 40
```

---

## 8. Credits Cost

| Message Type | Credits per 160-char SMS |
|-------------|--------------------------|
| Regular (`/messages`) | 1 credit |
| OTP (`/otp`) | 2 credits |
| Priority (`/priority`) | 2 credits |

Check balance before going live:
```
GET https://api.semaphore.co/api/v4/account?apikey=YOUR_KEY
```
Returns `credit_balance` — each credit = 1 SMS.

---

## 9. Quick Test with cURL

Before touching Flutter code, test your API key works:

```bash
# Test OTP send
curl --data "apikey=YOUR_API_KEY&number=639998887777&message=Your CivilWatch OTP is: {otp}." https://api.semaphore.co/api/v4/otp

# Check account balance
curl "https://api.semaphore.co/api/v4/account?apikey=YOUR_API_KEY"
```

---

## 10. Files to Modify When Implementing

| File | Change |
|------|--------|
| `lib/services/semaphore_service.dart` | **Create** — SMS sending logic |
| `lib/screens/auth/otp_screen.dart` | Replace `_verify()` and `_resend()` mock with real calls |
| `pubspec.yaml` | Add `http: ^1.2.2` |
| `android/app/src/main/AndroidManifest.xml` | Already has `INTERNET` permission ✓ |
| Backend (new) | Hold API key, verify OTP server-side |

---

## 11. Useful Links

- [Semaphore API Docs](https://semaphore.co/docs) — official reference
- [Semaphore Dashboard](https://semaphore.co) — get API key, buy credits, manage sender names
- [http package (pub.dev)](https://pub.dev/packages/http) — Flutter HTTP client
