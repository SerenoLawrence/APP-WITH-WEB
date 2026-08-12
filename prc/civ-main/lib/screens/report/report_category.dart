import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../widgets/navigation/app_bar.dart';
import '_report_stepper.dart';

class ReportCategoryScreen extends StatefulWidget {
  const ReportCategoryScreen({super.key});

  @override
  State<ReportCategoryScreen> createState() => _ReportCategoryScreenState();
}

class _ReportCategoryScreenState extends State<ReportCategoryScreen> {
  String? _selected;

  void _next() {
    if (_selected == null) return;
    Navigator.pushNamed(context, AppRoutes.reportConcern,
        arguments: {'category': _selected});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CivilWatchAppBar(
        title: 'Report Concern',
        subtitle: 'Step 1 of 5',
      ),
      body: Column(
        children: [
          // ── Progress stepper ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: ReportStepper(currentStep: 0),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What type of concern\nwould you like to report?',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Select the category that best describes your community concern.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Infrastructure card ───────────────────────────────
                  _CategoryCard(
                    title: 'Infrastructure (CEO)',
                    subtitle:
                        'Road repairs, streetlights, canals, and other public infrastructure managed by the City Engineering Office.',
                    icon: Icons.construction_rounded,
                    color: AppColors.infrastructure,
                    bg: AppColors.infrastructureBg,
                    isSelected: _selected == 'Infrastructure',
                    onTap: () =>
                        setState(() => _selected = 'Infrastructure'),
                  ),
                  const SizedBox(height: 16),

                  // ── Environment card ──────────────────────────────────
                  _CategoryCard(
                    title: 'Environment (CENRO)',
                    subtitle:
                        'Illegal dumping and garbage collection concerns managed by the City Environment and Natural Resources Office.',
                    icon: Icons.eco_rounded,
                    color: AppColors.environment,
                    bg: AppColors.environmentBg,
                    isSelected: _selected == 'Environment',
                    onTap: () => setState(() => _selected = 'Environment'),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom navigation ─────────────────────────────────────────
          _ReportNavBar(
            showBack: false,
            onNext: _selected != null ? _next : null,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color bg;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.bg,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? color : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? color.withOpacity(0.14)
                  : const Color(0x0C000000),
              blurRadius: isSelected ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // ── Icon badge ─────────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSelected ? color : bg,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    icon,
                    color: isSelected ? AppColors.white : color,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                // ── Title + selection indicator ────────────────────────
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color:
                              isSelected ? color : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isSelected ? 'Selected' : 'Tap to select',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: isSelected
                              ? color.withOpacity(0.8)
                              : AppColors.textHint,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                // ── Radio indicator ────────────────────────────────────
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? color : AppColors.white,
                    border: Border.all(
                      color: isSelected ? color : AppColors.inputBorder,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.white, size: 14)
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(color: AppColors.divider, height: 1),
            const SizedBox(height: 14),
            // ── Description ────────────────────────────────────────────
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared bottom navigation bar — used across the entire report flow
// ─────────────────────────────────────────────────────────────────────────────

class _ReportNavBar extends StatelessWidget {
  final bool showBack;
  final VoidCallback? onBack;
  final VoidCallback? onNext;
  final String nextLabel;
  final Color? nextColor;

  const _ReportNavBar({
    this.showBack = true,
    this.onBack,
    this.onNext,
    this.nextLabel = 'Next →',
    this.nextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          if (showBack) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onBack ?? () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: const Text('Back'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.divider),
                  minimumSize: const Size(0, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  textStyle: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            flex: showBack ? 2 : 1,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: onNext != null
                    ? (nextColor ?? AppColors.primary)
                    : AppColors.textDisabled,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: onNext != null ? 2 : 0,
                shadowColor: (nextColor ?? AppColors.primary).withOpacity(0.3),
                textStyle: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(nextLabel.replaceAll(' →', '')),
                  if (onNext != null) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward_rounded, size: 18),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
