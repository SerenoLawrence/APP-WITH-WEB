import '../models/user.dart';
import '../core/utils/dummy_data.dart';

class AuthService {
  static AppUser? _currentUser;

  static AppUser get currentUser => _currentUser ?? DummyData.currentUser;

  static Future<bool> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    return true;
  }

  static Future<bool> verifyOtp(String phoneNumber, String otp) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _currentUser = DummyData.currentUser;
    return true;
  }

  static Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _currentUser = null;
  }

  static bool get isLoggedIn => _currentUser != null;
}
