class AppRoutes {
  AppRoutes._();

  static const String splash = '/';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';
  static const String home = '/home';

  // Report flow
  static const String reportCategory = '/report/category';
  static const String reportConcern = '/report/concern';
  static const String reportIssue = '/report/concern'; // alias kept for compatibility
  static const String reportPhoto = '/report/photo';
  static const String reportLocation = '/report/location';
  static const String reportDetails = '/report/location'; // alias kept for compatibility
  static const String reportReview = '/report/review';
  static const String reportSubmitted = '/report/submitted';

  // Main tabs
  static const String myReports = '/my-reports';
  static const String trackReport = '/track-report';
  static const String statusUpdate = '/status-update';
  static const String privateMap = '/private-map';
  static const String communityMap = '/community-map';
  static const String notifications = '/notifications';
  static const String profile = '/profile';
}
