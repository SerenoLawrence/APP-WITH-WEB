import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/app_state.dart';
import 'visitor_shell.dart';

class VisitorAboutScreen extends StatelessWidget {
  const VisitorAboutScreen({super.key});

  void _onLoginTap(BuildContext context) {
    AppState().exitGuest();
    Navigator.pushReplacementNamed(context, AppRoutes.login,
        arguments: {'fromVisitor': true});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Guest banner ─────────────────────────────────────────────
          GuestBanner(onLoginTap: () => _onLoginTap(context)),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.navy,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.navy.withValues(alpha: 0.25),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.shield_rounded,
                            color: AppColors.white.withValues(alpha: 0.12),
                            size: 68),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.location_on_rounded,
                                color: AppColors.white, size: 22),
                            Icon(Icons.eco_rounded,
                                color: AppColors.primary, size: 18),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'CIVILWATCH',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: AppColors.navy,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Community Reporting for a Better Digos City',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // ── What is CIVILWATCH ──────────────────────────────
                  _SectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'What is CIVILWATCH?',
                    body:
                        'CIVILWATCH is a geotagged community incident reporting system for Digos City. Citizens can submit infrastructure and environmental concerns directly to the relevant government offices — with photo, GPS location, and real-time status tracking.',
                  ),
                  const SizedBox(height: 16),

                  // ── What you can do as a visitor ────────────────────
                  _SectionCard(
                    icon: Icons.explore_rounded,
                    title: 'What you can do as a Visitor',
                    child: Column(
                      children: [
                        _FeatureItem(
                          icon: Icons.map_rounded,
                          color: AppColors.infrastructure,
                          title: 'Browse the Community Map',
                          subtitle:
                              'View all validated community reports as pins on the map.',
                        ),
                        _FeatureItem(
                          icon: Icons.list_alt_rounded,
                          color: AppColors.environment,
                          title: 'View Recent Reports',
                          subtitle:
                              'Browse the latest infrastructure and environmental concerns.',
                        ),
                        _FeatureItem(
                          icon: Icons.search_rounded,
                          color: AppColors.statusAssigned,
                          title: 'Track by Reference Number',
                          subtitle:
                              'Look up any report by its reference number — no login needed.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Why register ────────────────────────────────────
                  _SectionCard(
                    icon: Icons.person_add_rounded,
                    title: 'Why register?',
                    child: Column(
                      children: [
                        _FeatureItem(
                          icon: Icons.add_circle_outline_rounded,
                          color: AppColors.primary,
                          title: 'Submit Reports',
                          subtitle:
                              'Report road damage, blocked canals, illegal dumping, and more.',
                        ),
                        _FeatureItem(
                          icon: Icons.track_changes_rounded,
                          color: AppColors.statusInProgress,
                          title: 'Track Your Reports',
                          subtitle:
                              'Follow the status of your submitted reports in real time.',
                        ),
                        _FeatureItem(
                          icon: Icons.notifications_outlined,
                          color: AppColors.statusPending,
                          title: 'Get Notifications',
                          subtitle:
                              'Receive alerts when your report status changes.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Login / Register CTA ────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _onLoginTap(context),
                      icon: const Icon(Icons.login_rounded, size: 18),
                      label: const Text('Login / Register'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                        textStyle: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(
                          context, AppRoutes.trackByReference),
                      icon: const Icon(Icons.search_rounded, size: 18),
                      label: const Text('Track by Reference No.'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.navy,
                        side: const BorderSide(color: AppColors.divider),
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        textStyle: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── System info ─────────────────────────────────────
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 20),
                  Text(
                    'A Capstone Project',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'University of Mindanao — Digos Branch\nBS Information Technology · 2026',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textHint,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Borinaga · Mag-Usara · Sereno',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textHint,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adviser: Cyvil Dave Dasargo, MIT',
                    style: GoogleFonts.inter(
                      fontSize: 11,
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
// Section card
// ─────────────────────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? body;
  final Widget? child;

  const _SectionCard({
    required this.icon,
    required this.title,
    this.body,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
        boxShadow: const [
          BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          if (body != null) ...[
            const SizedBox(height: 12),
            Text(
              body!,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
          if (child != null) ...[
            const SizedBox(height: 14),
            child!,
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Feature item row
// ─────────────────────────────────────────────────────────────────────────────

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
