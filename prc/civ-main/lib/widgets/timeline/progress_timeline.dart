import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../models/report.dart';

class ProgressTimeline extends StatelessWidget {
  final IncidentReport report;

  const ProgressTimeline({super.key, required this.report});

  static const _steps = [
    'Submitted',
    'Pending Validation',
    'Assigned to Office',
    'In Progress',
    'Resolved',
  ];

  @override
  Widget build(BuildContext context) {
    final currentIdx = report.statusIndex;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_steps.length, (i) {
          final isDone = i <= currentIdx;
          final isCurrent = i == currentIdx;
          final isLast = i == _steps.length - 1;
          final color = isDone
              ? AppHelpers.getStatusColor(_steps[i])
              : AppColors.textDisabled;
          final icon = AppHelpers.getStatusIcon(_steps[i]);

          return Row(
            children: [
              SizedBox(
                width: 72,
                child: Column(
                  children: [
                    // Circle
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppHelpers.getStatusBgColor(_steps[i])
                            : AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone ? color : AppColors.divider,
                          width: isCurrent ? 2 : 1.5,
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 18,
                        color: isDone ? color : AppColors.textDisabled,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _steps[i],
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight:
                            isCurrent ? FontWeight.w700 : FontWeight.w400,
                        color: isDone ? AppColors.textPrimary : AppColors.textHint,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                    if (isCurrent) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Current',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 28,
                  height: 2,
                  margin: const EdgeInsets.only(bottom: 28),
                  decoration: BoxDecoration(
                    color: i < currentIdx ? AppColors.primary : AppColors.divider,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}
