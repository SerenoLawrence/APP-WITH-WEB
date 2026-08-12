import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/navigation/app_bar.dart';
import '_report_stepper.dart';

class ReportPhotoScreen extends StatefulWidget {
  final Map<String, dynamic> reportData;
  const ReportPhotoScreen({super.key, required this.reportData});

  @override
  State<ReportPhotoScreen> createState() => _ReportPhotoScreenState();
}

class _ReportPhotoScreenState extends State<ReportPhotoScreen> {
  bool _hasPhoto = false; // simulates photo selection

  void _simulatePhoto() => setState(() => _hasPhoto = true);
  void _removePhoto() => setState(() => _hasPhoto = false);

  void _next() {
    Navigator.pushNamed(context, AppRoutes.reportLocation, arguments: {
      ...widget.reportData,
      'hasPhoto': _hasPhoto,
    });
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.reportData['category'] as String? ?? 'Infrastructure';
    final issue = widget.reportData['issue'] as String? ?? '';
    final catColor = AppHelpers.getCategoryColor(category);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CivilWatchAppBar(
        title: 'Report Concern',
        subtitle: 'Step 3 of 5',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: ReportStepper(currentStep: 2),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add a photo',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'A clear photo helps us verify\nthe concern faster.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Photo preview / picker
                  if (_hasPhoto) ...[
                    _PhotoPreview(
                      issue: issue,
                      catColor: catColor,
                      onRemove: _removePhoto,
                    ),
                  ] else ...[
                    // Take photo button
                    _PhotoOption(
                      icon: Icons.camera_alt_rounded,
                      title: 'Take Photo',
                      subtitle: 'Tap to capture',
                      color: catColor,
                      bg: AppHelpers.getCategoryBgColor(category),
                      onTap: _simulatePhoto,
                      isPrimary: true,
                    ),
                    const SizedBox(height: 12),

                    // Divider
                    Row(children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('or',
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textHint)),
                      ),
                      const Expanded(child: Divider()),
                    ]),
                    const SizedBox(height: 12),

                    // Gallery
                    _PhotoOption(
                      icon: Icons.photo_library_rounded,
                      title: 'Choose from Gallery',
                      subtitle: '',
                      color: AppColors.textSecondary,
                      bg: AppColors.background,
                      onTap: _simulatePhoto,
                      isPrimary: false,
                    ),
                  ],

                  const SizedBox(height: 20),

                  // Tip
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb_outline_rounded,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Tip: Make sure the concern is clearly visible in the photo.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          _ReportPhotoFooter(
            onNext: _next,
            canSkip: !_hasPhoto,
            catColor: catColor,
          ),
        ],
      ),
    );
  }
}

class _PhotoOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final Color bg;
  final VoidCallback onTap;
  final bool isPrimary;

  const _PhotoOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.bg,
    required this.onTap,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: isPrimary ? bg : AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary ? color.withOpacity(0.3) : AppColors.divider,
            width: isPrimary ? 1.5 : 1,
            style: isPrimary ? BorderStyle.solid : BorderStyle.solid,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(height: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textHint),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  final String issue;
  final Color catColor;
  final VoidCallback onRemove;

  const _PhotoPreview({
    required this.issue,
    required this.catColor,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF1A2A3A),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.image_rounded,
                    color: AppColors.white.withOpacity(0.4), size: 50),
                const SizedBox(height: 8),
                Text(
                  issue,
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.white.withOpacity(0.6)),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFDC2626),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded,
                  color: AppColors.white, size: 16),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.fullscreen_rounded,
                    color: AppColors.white, size: 14),
                const SizedBox(width: 4),
                Text('View Photo',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ReportPhotoFooter extends StatelessWidget {
  final VoidCallback onNext;
  final bool canSkip;
  final Color catColor;

  const _ReportPhotoFooter({
    required this.onNext,
    required this.canSkip,
    required this.catColor,
  });

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
                backgroundColor: catColor,
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
