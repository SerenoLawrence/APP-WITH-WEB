import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/report/report_category.dart';
import '../../screens/report/report_concern.dart';
import '../../screens/report/report_photo.dart';
import '../../screens/report/report_location.dart';
import '../../screens/report/report_review.dart';
import '../../screens/report/report_submitted.dart';
import '../../screens/my_reports/my_reports_screen.dart';
import '../../screens/track_report/track_report_screen.dart';
import '../../screens/map_preview/private_map_screen.dart';
import '../../screens/community_map/community_map_screen.dart';
import '../../screens/notifications/notification_screen.dart';
import '../../screens/profile/profile_screen.dart';
import '../../screens/track_report/status_update_screen.dart';

class RouteGenerator {
  RouteGenerator._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _fade(const SplashScreen());
      case AppRoutes.login:
        return _slide(const LoginScreen());
      case AppRoutes.otp:
        // Arguments can be a plain String (legacy) or a Map with phone + isNewUser
        final raw = settings.arguments;
        String phone;
        bool isNewUser;
        if (raw is Map<String, dynamic>) {
          phone = raw['phone'] as String? ?? '';
          isNewUser = raw['isNewUser'] as bool? ?? true;
        } else {
          phone = raw as String? ?? '';
          isNewUser = phone.isNotEmpty;
        }
        return _slide(OtpScreen(phoneNumber: phone, isNewUser: isNewUser));
      case AppRoutes.register:
        return _slide(const RegisterScreen());
      case AppRoutes.home:
        return _fade(const HomeScreen());
      case AppRoutes.reportCategory:
        return _slide(const ReportCategoryScreen());

      // Step 2 — Concern (replaces old Issue step)
      case AppRoutes.reportConcern: // '/report/concern'
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(
            ReportConcernScreen(category: args['category'] ?? 'Infrastructure'));

      // Step 3 — Photo
      case AppRoutes.reportPhoto:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(ReportPhotoScreen(reportData: args));

      // Step 4 — Location (replaces old Details step)
      case AppRoutes.reportLocation: // '/report/location'
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(ReportLocationScreen(reportData: args));

      // Step 5 — Review
      case AppRoutes.reportReview:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(ReportReviewScreen(reportData: args));

      // Success screen
      case AppRoutes.reportSubmitted:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _fade(ReportSubmittedScreen(reportData: args));

      case AppRoutes.myReports:
        return _slide(const MyReportsScreen());
      case AppRoutes.trackReport:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(TrackReportScreen(reportData: args));
      case AppRoutes.statusUpdate:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(StatusUpdateScreen(reportData: args));
      case AppRoutes.privateMap:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(PrivateMapScreen(reportData: args));
      case AppRoutes.communityMap:
        return _slide(const CommunityMapScreen());
      case AppRoutes.notifications:
        return _slide(const NotificationScreen());
      case AppRoutes.profile:
        return _slide(const ProfileScreen());
      default:
        return _fade(const SplashScreen());
    }
  }

  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 300),
      );

  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
        pageBuilder: (_, __, ___) => page,
        transitionsBuilder: (_, animation, __, child) {
          final tween = Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      );
}
