/// Image sources for CivilWatch.
/// All images use network URLs so the app runs without local asset files.
class AppImages {
  AppImages._();

  // ── Logos ─────────────────────────────────────────────────────────────────
  // Shield/location pin icon on dark background – represents the app identity
  static const String logo =
      'https://img.icons8.com/ios-filled/100/1a3a5c/shield.png';
  static const String logoWhite =
      'https://img.icons8.com/ios-filled/100/ffffff/shield.png';

  // ── Illustrations ─────────────────────────────────────────────────────────
  // City skyline for login/home background
  static const String cityscape =
      'https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?w=800&q=80';

  // Success checkmark illustration
  static const String successIllustration =
      'https://img.icons8.com/bubbles/200/000000/checkmark.png';

  // Empty state – no reports yet
  static const String emptyReports =
      'https://img.icons8.com/bubbles/200/000000/nothing-found.png';

  // Map placeholder
  static const String mapPlaceholder =
      'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80';
}
