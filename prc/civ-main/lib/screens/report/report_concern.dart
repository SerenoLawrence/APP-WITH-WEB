import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/navigation/app_bar.dart';
import '_report_stepper.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Concern type data
// ─────────────────────────────────────────────────────────────────────────────

class _ConcernType {
  final String label;
  final IconData icon;
  final String hint;
  const _ConcernType(this.label, this.icon, this.hint);
}

const _infrastructureConcerns = <_ConcernType>[
  _ConcernType(
    'Road Repair',
    Icons.add_road_rounded,
    'Potholes, damaged road surface needing repair',
  ),
  _ConcernType(
    'Road Graveling',
    Icons.terrain_rounded,
    'Unpaved or gravel road needs improvement',
  ),
  _ConcernType(
    'Streetlight / Light Pole Concern',
    Icons.light_rounded,
    'Broken, flickering, or missing streetlight',
  ),
  _ConcernType(
    'Blocked Canal',
    Icons.water_damage_rounded,
    'Canal blocked by debris or sediment',
  ),
  _ConcernType(
    'Others',
    Icons.more_horiz_rounded,
    'Other infrastructure concerns not listed above',
  ),
];

const _environmentConcerns = <_ConcernType>[
  _ConcernType(
    'Illegal Dumping',
    Icons.delete_sweep_rounded,
    'Waste illegally dumped in public areas',
  ),
  _ConcernType(
    'Garbage Collection',
    Icons.recycling_rounded,
    'Missed or irregular garbage collection schedule',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class ReportConcernScreen extends StatefulWidget {
  final String category;
  const ReportConcernScreen({super.key, required this.category});

  @override
  State<ReportConcernScreen> createState() => _ReportConcernScreenState();
}

class _ReportConcernScreenState extends State<ReportConcernScreen> {
  String? _selected;

  List<_ConcernType> get _concerns =>
      widget.category == 'Environment'
          ? _environmentConcerns
          : _infrastructureConcerns;

  void _next() {
    if (_selected == null) return;
    Navigator.pushNamed(context, AppRoutes.reportPhoto, arguments: {
      'category': widget.category,
      'concern': _selected,
      // keep 'issue' key for backward-compat with AppState / review screens
      'issue': _selected,
    });
  }

  @override
  Widget build(BuildContext context) {
    final catColor = AppHelpers.getCategoryColor(widget.category);
    final catBg = AppHelpers.getCategoryBgColor(widget.category);
    final catIcon = AppHelpers.getCategoryIcon(widget.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CivilWatchAppBar(
        title: 'Report Concern',
        subtitle: 'Step 2 of 5',
      ),
      body: Column(
        children: [
          // ── Stepper ───────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: ReportStepper(currentStep: 1),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Category badge ────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: catBg,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: catColor.withOpacity(0.25), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(catIcon, size: 16, color: catColor),
                        const SizedBox(width: 6),
                        Text(
                          widget.category,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: catColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Select the concern',
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Choose the specific concern you want\nto report.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Concern cards ─────────────────────────────────────
                  ...List.generate(_concerns.length, (i) {
                    final concern = _concerns[i];
                    final isSelected = _selected == concern.label;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ConcernCard(
                        concern: concern,
                        isSelected: isSelected,
                        catColor: catColor,
                        catBg: catBg,
                        onTap: () =>
                            setState(() => _selected = concern.label),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          // ── Bottom navigation ─────────────────────────────────────────
          _ConcernNavBar(
            onNext: _selected != null ? _next : null,
            catColor: catColor,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Concern card with radio selection
// ─────────────────────────────────────────────────────────────────────────────

class _ConcernCard extends StatelessWidget {
  final _ConcernType concern;
  final bool isSelected;
  final Color catColor;
  final Color catBg;
  final VoidCallback onTap;

  const _ConcernCard({
    required this.concern,
    required this.isSelected,
    required this.catColor,
    required this.catBg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? catColor.withOpacity(0.04) : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? catColor : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? catColor.withOpacity(0.10)
                  : const Color(0x08000000),
              blurRadius: isSelected ? 12 : 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Icon container ─────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected ? catColor : catBg,
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                concern.icon,
                color: isSelected ? AppColors.white : catColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // ── Label + hint ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concern.label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? catColor : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    concern.hint,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // ── Radio button ───────────────────────────────────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? catColor : AppColors.white,
                border: Border.all(
                  color: isSelected ? catColor : AppColors.inputBorder,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded,
                      color: AppColors.white, size: 13)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom nav bar for concern step
// ─────────────────────────────────────────────────────────────────────────────

class _ConcernNavBar extends StatelessWidget {
  final VoidCallback? onNext;
  final Color catColor;

  const _ConcernNavBar({this.onNext, required this.catColor});

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
          // ── Back ──────────────────────────────────────────────────────
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
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

          // ── Next ──────────────────────────────────────────────────────
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    onNext != null ? catColor : AppColors.textDisabled,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                elevation: onNext != null ? 2 : 0,
                shadowColor: catColor.withOpacity(0.3),
                textStyle: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text('Next'),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
