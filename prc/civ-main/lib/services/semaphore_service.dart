import 'dart:convert';
import 'package:http/http.dart' as http;

/// Semaphore SMS gateway service.
/// Philippine SMS only — https://semaphore.co/docs
///
/// IMPORTANT: Replace [_apiKey] and [_senderName] with your real credentials
/// from the Semaphore dashboard (https://semaphore.co).
/// In production, move the API key to a secure backend — never ship it inside
/// the APK.
class SemaphoreService {
  SemaphoreService._();

  static const String _baseUrl = 'https://api.semaphore.co/api/v4';

  // ── Replace these with your real Semaphore credentials ─────────────────────
  static const String _apiKey     = 'YOUR_SEMAPHORE_API_KEY'; // from semaphore.co dashboard
  static const String _senderName = 'CIVILWTCH';              // max 11 chars, register in dashboard
  // ───────────────────────────────────────────────────────────────────────────

  /// Sends an OTP SMS to [phoneNumber] via Semaphore's dedicated OTP route.
  ///
  /// Returns the auto-generated OTP code as a [String] on success.
  /// Returns [null] if the request failed (network error, bad API key, etc.).
  static Future<String?> sendOtp(String phoneNumber) async {
    final number = _toSemaphoreFormat(phoneNumber);

    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/otp'),
            body: {
              'apikey':     _apiKey,
              'number':     number,
              'message':    'Your CivilWatch verification code is: {otp}. '
                            'Valid for 5 minutes. Do not share this code.',
              'sendername': _senderName,
            },
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty && data[0]['code'] != null) {
          // Semaphore returns code as int — convert to String for comparison
          return data[0]['code'].toString();
        }
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  /// Normalises any Philippine phone number format to Semaphore's expected
  /// format: 639XXXXXXXXX (no + prefix, no leading 0).
  ///
  /// Examples:
  ///   09998887777   → 639998887777
  ///   +639998887777 → 639998887777
  ///   9998887777    → 639998887777
  static String _toSemaphoreFormat(String phone) {
    // Strip whitespace, dashes, parentheses
    phone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (phone.startsWith('+63')) return phone.substring(1); // +639... → 639...
    if (phone.startsWith('0'))   return '63${phone.substring(1)}'; // 09... → 639...
    if (phone.startsWith('9'))   return '63$phone'; // 9... → 639...

    return phone; // already in 639... format or unknown — pass through
  }
}
