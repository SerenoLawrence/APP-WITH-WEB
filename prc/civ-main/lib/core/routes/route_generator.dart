import 'package:flutter/material.dart';
import 'app_routes.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/landing/landing_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/otp_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/visitor/visitor_shell.dart';
import '../../screens/visitor/track_by_reference_screen.dart';
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

      case AppRoutes.landing:
        return _fade(const LandingScreen());

      // ── Visitor (guest) flow ─────────────────────────────────────────
      case AppRoutes.visitor:
        return _fade(const VisitorShell());

      case AppRoutes.trackByReference:
        return _slide(const TrackByReferenceScreen());

      // ── Auth flow ────────────────────────────────────────────────────
      case AppRoutes.login:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(LoginScreen(fromVisitor: args['fromVisitor'] == true));

      case AppRoutes.otp:
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

      // ── Report flow ──────────────────────────────────────────────────
      case AppRoutes.reportCategory:
        return _slide(const ReportCategoryScreen());

      case AppRoutes.reportConcern:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(
            ReportConcernScreen(category: args['category'] ?? 'Infrastructure'));

      case AppRoutes.reportPhoto:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(ReportPhotoScreen(reportData: args));

      case AppRoutes.reportLocation:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(ReportLocationScreen(reportData: args));

      case AppRoutes.reportReview:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _slide(ReportReviewScreen(reportData: args));

      case AppRoutes.reportSubmitted:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        return _fade(ReportSubmittedScreen(reportData: args));

      // ── Main tabs ────────────────────────────────────────────────────
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
