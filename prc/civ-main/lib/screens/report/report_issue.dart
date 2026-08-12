import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/navigation/app_bar.dart';
import '_report_stepper.dart';

class ReportIssueScreen extends StatefulWidget {
  final String category;
  const ReportIssueScreen({super.key, required this.category});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selected;

  static const Map<String, List<Map<String, dynamic>>> _issues = {
    'Infrastructure': [
      {'label': 'Broken Streetlight', 'icon': Icons.light_rounded},
      {'label': 'Damaged Road', 'icon': Icons.add_road_rounded},
      {'label': 'Damaged Sidewalk', 'icon': Icons.directions_walk_rounded},
      {'label': 'Blocked Drainage', 'icon': Icons.water_rounded},
      {'label': 'Damaged Bridge', 'icon': Icons.directions_rounded},
      {'label': 'Road Sign Damage', 'icon': Icons.signpost_rounded},
      {'label': 'Others', 'icon': Icons.more_horiz_rounded},
    ],
    'Environment': [
      {'label': 'Illegal Dumping', 'icon': Icons.delete_rounded},
      {'label': 'Blocked Canal', 'icon': Icons.water_damage_rounded},
      {'label': 'Overgrown Vegetation', 'icon': Icons.grass_rounded},
      {'label': 'Soil Erosion', 'icon': Icons.terrain_rounded},
      {'label': 'Others', 'icon': Icons.more_horiz_rounded},
    ],
  };

  void _next() {
    if (_selected == null) return;
    Navigator.pushNamed(context, AppRoutes.reportPhoto, arguments: {
      'category': widget.category,
      'issue': _selected,
    });
  }

  @override
  Widget build(BuildContext context) {
    final issues = _issues[widget.category] ?? [];
    final catColor = AppHelpers.getCategoryColor(widget.category);
    final catBg = AppHelpers.getCategoryBgColor(widget.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CivilWatchAppBar(
        title: 'Report Concern',
        subtitle: 'Step 2 of 5',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: ReportStepper(currentStep: 1),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select the issue',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Choose the specific issue you want\nto report.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  ...issues.map((issue) {
                    final label = issue['label'] as String;
                    final icon = issue['icon'] as IconData;
                    final isSelected = _selected == label;

                    return GestureDetector(
                      onTap: () => setState(() => _selected = label),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isSelected ? catColor : AppColors.divider,
                            width: isSelected ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: isSelected
                                  ? catColor.withOpacity(0.1)
                                  : AppColors.cardShadow,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? catBg : AppColors.background,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                icon,
                                color: isSelected
                                    ? catColor
                                    : AppColors.textSecondary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                label,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.textPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Radio<String>(
                              value: label,
                              groupValue: _selected,
                              onChanged: (v) =>
                                  setState(() => _selected = v),
                              activeColor: catColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
          _ReportNavFooter(
            onNext: _selected != null ? _next : null,
            catColor: AppHelpers.getCategoryColor(widget.category),
          ),
        ],
      ),
    );
  }
}

class _ReportNavFooter extends StatelessWidget {
  final VoidCallback? onNext;
  final Color catColor;

  const _ReportNavFooter({this.onNext, required this.catColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                side: const BorderSide(color: AppColors.divider),
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                textStyle: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Next'),
              style: ElevatedButton.styleFrom(
                backgroundColor: onNext != null ? catColor : AppColors.textDisabled,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 0,
                textStyle: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
