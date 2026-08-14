import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/app_state.dart';
import '../community_map/community_map_screen.dart';
import 'visitor_reports_screen.dart';
import 'visitor_about_screen.dart';

class VisitorShell extends StatefulWidget {
  const VisitorShell({super.key});

  @override
  State<VisitorShell> createState() => _VisitorShellState();
}

class _VisitorShellState extends State<VisitorShell> {
  int _index = 0;

  final List<Widget> _pages = const [
    CommunityMapScreen(embedded: true),
    VisitorReportsScreen(),
    VisitorAboutScreen(),
  ];

  void _onLoginTap() {
    AppState().exitGuest();
    Navigator.pushReplacementNamed(context, AppRoutes.login,
        arguments: {'fromVisitor': true});
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppColors.background,
      // ── Guest banner ──────────────────────────────────────────────────
      appBar: _index == 0
          ? null // map fills the whole screen — banner is inside map header
          : PreferredSize(
              preferredSize: const Size.fromHeight(0),
              child: const SizedBox.shrink(),
            ),
      body: Stack(
        children: [
          IndexedStack(index: _index, children: _pages),
          // Persistent guest banner at top (only when not on map tab,
          // because map has its own header)
          if (_index != 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _GuestBanner(onLoginTap: _onLoginTap),
            ),
        ],
      ),
      bottomNavigationBar: _VisitorBottomNav(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        onLoginTap: _onLoginTap,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Guest banner — "You're browsing as a guest"
// ─────────────────────────────────────────────────────────────────────────────

class GuestBanner extends StatelessWidget {
  final VoidCallback onLoginTap;
  const GuestBanner({super.key, required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return _GuestBanner(onLoginTap: onLoginTap);
  }
}

class _GuestBanner extends StatelessWidget {
  final VoidCallback onLoginTap;
  const _GuestBanner({required this.onLoginTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.navy,
      child: SafeArea(
        bottom: false,
        child: InkWell(
          onTap: onLoginTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.visibility_rounded,
                      color: AppColors.white, size: 15),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Browsing as Guest',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      Text(
                        'Login or register to submit reports.',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Login / Register',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom navigation
// ─────────────────────────────────────────────────────────────────────────────

class _VisitorBottomNav extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;
  final VoidCallback onLoginTap;

  const _VisitorBottomNav({
    required this.currentIndex,
    required this.onTap,
    required this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Map tab
            _NavItem(
              icon: Icons.map_rounded,
              label: 'Map',
              isActive: currentIndex == 0,
              onTap: () => onTap(0),
            ),
            // Reports tab
            _NavItem(
              icon: Icons.list_alt_rounded,
              label: 'Reports',
              isActive: currentIndex == 1,
              onTap: () => onTap(1),
            ),
            // About tab
            _NavItem(
              icon: Icons.info_outline_rounded,
              label: 'About',
              isActive: currentIndex == 2,
              onTap: () => onTap(2),
            ),
            // Login shortcut
            _NavItemLogin(onTap: onLoginTap),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primarySurface
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  icon,
                  size: 22,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive
                      ? AppColors.primary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItemLogin extends StatelessWidget {
  final VoidCallback onTap;
  const _NavItemLogin({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.login_rounded,
                    size: 20, color: AppColors.white),
              ),
              const SizedBox(height: 2),
              Text(
                'Login',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.navy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
