import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/app_state.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _exploreAsVisitor() {
    AppState().enterAsGuest();
    Navigator.pushReplacementNamed(context, AppRoutes.visitor);
  }

  void _loginOrRegister() {
    Navigator.pushNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // ── Background gradient ───────────────────────────────────────
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFEAF4EE), AppColors.white, AppColors.white],
                  stops: [0.0, 0.45, 1.0],
                ),
              ),
            ),
          ),

          // ── Top decorative circles ────────────────────────────────────
          Positioned(
            top: -70,
            right: -70,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.07),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: -50,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.navy.withValues(alpha: 0.04),
              ),
            ),
          ),

          // ── City skyline (bottom decoration) ─────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomPaint(
              size: Size(size.width, 170),
              painter: _LandingSkylinePainter(),
            ),
          ),

          // ── Main content ──────────────────────────────────────────────
          SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 0, 28, 200),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 52),

                      // ── Logo ───────────────────────────────────────
                      _CivilWatchLogo(size: 96),
                      const SizedBox(height: 20),

                      // ── App name ───────────────────────────────────
                      Text(
                        'CIVILWATCH',
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.navy,
                          letterSpacing: 2.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Community Reporting for a\nBetter Digos City',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          height: 1.55,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),

                      // ── Feature highlights ─────────────────────────
                      _FeatureRow(),
                      const SizedBox(height: 44),

                      // ── Divider label ──────────────────────────────
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(color: AppColors.divider)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'How would you like to continue?',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textHint,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const Expanded(
                              child: Divider(color: AppColors.divider)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Explore as Visitor button ──────────────────
                      _LandingButton(
                        icon: Icons.explore_rounded,
                        label: 'Explore as Visitor',
                        sublabel:
                            'Browse the map and view reports without an account.',
                        color: AppColors.primary,
                        bg: AppColors.primarySurface,
                        border: AppColors.primary,
                        textColor: AppColors.primary,
                        filled: true,
                        onTap: _exploreAsVisitor,
                      ),
                      const SizedBox(height: 14),

                      // ── Login / Register button ────────────────────
                      _LandingButton(
                        icon: Icons.person_rounded,
                        label: 'Login / Register',
                        sublabel:
                            'Login or register to submit reports and track your concerns.',
                        color: AppColors.navy,
                        bg: AppColors.navy,
                        border: AppColors.navy,
                        textColor: AppColors.white,
                        filled: false,
                        onTap: _loginOrRegister,
                      ),

                      const SizedBox(height: 28),

                      // ── Note ──────────────────────────────────────
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 13, color: AppColors.textHint),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              'Anyone can view reports and the map without an account.',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: AppColors.textHint,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Bottom credit ─────────────────────────────────────────────
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fade,
              child: Column(
                children: [
                  Text(
                    'Digos City, Davao del Sur',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'University of Mindanao — Digos Branch',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature highlights row
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  static const _features = [
    (Icons.map_rounded, 'Interactive\nMap'),
    (Icons.push_pin_rounded, 'Location\nPins'),
    (Icons.filter_alt_rounded, 'Filter &\nNavigate'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _features.map((f) {
        return Expanded(
          child: Column(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.15)),
                ),
                child: Icon(f.$1, color: AppColors.primary, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                f.$2,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Big option button
// ─────────────────────────────────────────────────────────────────────────────

class _LandingButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sublabel;
  final Color color;
  final Color bg;
  final Color border;
  final Color textColor;
  final bool filled; // true = outlined style, false = solid
  final VoidCallback onTap;

  const _LandingButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.color,
    required this.bg,
    required this.border,
    required this.textColor,
    required this.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSolid = !filled; // navy button is solid

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: double.infinity,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSolid ? bg : AppColors.primarySurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSolid
                ? border
                : AppColors.primary.withValues(alpha: 0.35),
            width: isSolid ? 2 : 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: border.withValues(alpha: isSolid ? 0.22 : 0.10),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon circle
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSolid
                    ? AppColors.white.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSolid ? AppColors.white : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    sublabel,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: isSolid
                          ? AppColors.white.withValues(alpha: 0.75)
                          : AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: isSolid
                  ? AppColors.white.withValues(alpha: 0.7)
                  : AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo widget
// ─────────────────────────────────────────────────────────────────────────────

class _CivilWatchLogo extends StatelessWidget {
  final double size;
  const _CivilWatchLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.navy,
        boxShadow: [
          BoxShadow(
            color: AppColors.navy.withValues(alpha: 0.28),
            blurRadius: 26,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.shield_rounded,
            color: AppColors.white.withValues(alpha: 0.12),
            size: size * 0.85,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_rounded,
                  color: AppColors.white, size: size * 0.28),
              Icon(Icons.eco_rounded,
                  color: AppColors.primary, size: size * 0.22),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Skyline painter (bottom decoration)
// ─────────────────────────────────────────────────────────────────────────────

class _LandingSkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final buildPaint = Paint()..color = const Color(0xFFCFDDE8);
    final treePaint = Paint()..color = const Color(0xFFB5D4C0);
    final groundPaint = Paint()..color = const Color(0xFFD8EAF0);

    canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.72, size.width, size.height * 0.28),
        groundPaint);

    final buildings = [
      [0.0, 0.38, 0.11, 0.34],
      [0.12, 0.22, 0.09, 0.50],
      [0.22, 0.30, 0.10, 0.42],
      [0.34, 0.12, 0.12, 0.60],
      [0.47, 0.32, 0.09, 0.40],
      [0.58, 0.18, 0.11, 0.54],
      [0.71, 0.36, 0.08, 0.36],
      [0.81, 0.26, 0.10, 0.46],
      [0.92, 0.40, 0.08, 0.32],
    ];
    for (final b in buildings) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * b[0], size.height * b[1],
            size.width * b[2], size.height * b[3]),
        buildPaint,
      );
    }

    final winPaint = Paint()..color = const Color(0xFFE8F4FD).withValues(alpha: 0.8);
    for (final b in buildings) {
      final bx = size.width * b[0];
      final by = size.height * b[1];
      final bw = size.width * b[2];
      final bh = size.height * b[3];
      for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 2; col++) {
          canvas.drawRect(
            Rect.fromLTWH(bx + bw * 0.2 + col * bw * 0.45,
                by + bh * 0.15 + row * bh * 0.25, bw * 0.2, bh * 0.12),
            winPaint,
          );
        }
      }
    }

    final trunkPaint = Paint()..color = const Color(0xFFB5A08A);
    for (final tx in [0.06, 0.29, 0.53, 0.70, 0.87]) {
      final x = size.width * tx;
      final y = size.height * 0.60;
      canvas.drawRect(Rect.fromLTWH(x + 8, y + 20, 6, 16), trunkPaint);
      canvas.drawCircle(Offset(x + 11, y + 14), 15, treePaint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
