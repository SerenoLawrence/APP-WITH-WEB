import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';

class ReportStepper extends StatelessWidget {
  final int currentStep; // 0=Category, 1=Concern, 2=Photo, 3=Location, 4=Review

  const ReportStepper({super.key, required this.currentStep});

  static const _labels = [
    'Category',
    'Concern',
    'Photo',
    'Location',
    'Review',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length, (i) {
        final isDone = i < currentStep;
        final isCurrent = i == currentStep;
        final isLast = i == _labels.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // ── Step circle ───────────────────────────────────────
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppColors.primary
                            : isCurrent
                                ? AppColors.primary
                                : AppColors.divider,
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.30),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: isDone
                          ? const Icon(Icons.check_rounded,
                              color: AppColors.white, size: 14)
                          : Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: isCurrent ? 10 : 8,
                                height: isCurrent ? 10 : 8,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? AppColors.white
                                      : AppColors.textDisabled,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 5),
                    // ── Step label ────────────────────────────────────────
                    Text(
                      _labels[i],
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: isCurrent || isDone
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isDone || isCurrent
                            ? AppColors.primary
                            : AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    decoration: BoxDecoration(
                      color: i < currentStep
                          ? AppColors.primary
                          : AppColors.divider,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}
