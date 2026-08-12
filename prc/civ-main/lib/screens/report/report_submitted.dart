import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/helpers.dart';
import '../../widgets/buttons/primary_button.dart';

class ReportSubmittedScreen extends StatefulWidget {
  final Map<String, dynamic> reportData;
  const ReportSubmittedScreen({super.key, required this.reportData});

  @override
  State<ReportSubmittedScreen> createState() =>
      _ReportSubmittedScreenState();
}

class _ReportSubmittedScreenState extends State<ReportSubmittedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _scaleAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final refNumber = widget.reportData['referenceNumber'] as String? ??
        AppHelpers.generateRefNumber();
    final submittedAtStr =
        widget.reportData['submittedAt'] as String? ?? DateTime.now().toIso8601String();
    final submittedAt = DateTime.tryParse(submittedAtStr) ?? DateTime.now();

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: FadeTransition(
            opacity: _fadeAnim,
            child: Column(
              children: [
                const SizedBox(height: 32),

                // ── Success illustration ──────────────────────────────
                ScaleTransition(
                  scale: _scaleAnim,
                  child: _SuccessIllustration(),
                ),
                const SizedBox(height: 28),

                Text(
                  'Concern Submitted!',
                  style: GoogleFonts.inter(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Thank you for helping make\nDigos City a better place.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // ── Reference card ────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reference Number',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            refNumber,
                            style: GoogleFonts.robotoMono(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(
                                  ClipboardData(text: refNumber));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Reference number copied'),
                                  backgroundColor: AppColors.primary,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)),
                                  margin: const EdgeInsets.all(16),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: AppColors.divider),
                              ),
                              child: const Icon(Icons.copy_rounded,
                                  size: 16, color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Divider(color: AppColors.divider),
                      const SizedBox(height: 12),
                      Text(
                        'Submitted on',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        AppHelpers.formatDateTime(submittedAt),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ── Tracking tip ──────────────────────────────────────
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
                      const Icon(Icons.shield_outlined,
                          color: AppColors.primary, size: 18),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'You can track your concern status in My Reports.',
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
                const SizedBox(height: 32),

                // ── Actions ───────────────────────────────────────────
                PrimaryButton(
                  label: 'Go to My Reports',
                  backgroundColor: AppColors.primary,
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (r) => false,
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.home,
                    (r) => false,
                  ),
                  child: Text(
                    'Back to Home',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SuccessIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // City background
          CustomPaint(
            size: const Size(280, 180),
            painter: _SuccessCityPainter(),
          ),
          // Green circle + check
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.statusResolved,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.statusResolved.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.check_rounded,
                color: AppColors.white, size: 46),
          ),
        ],
      ),
    );
  }
}

class _SuccessCityPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final skyPaint = Paint()..color = const Color(0xFFEBF5F0);
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), skyPaint);

    final buildPaint = Paint()..color = const Color(0xFFC8DECE);
    final buildings = [
      [0.0, 0.45, 0.14, 0.4],
      [0.14, 0.3, 0.12, 0.55],
      [0.27, 0.38, 0.13, 0.47],
      [0.61, 0.4, 0.13, 0.45],
      [0.75, 0.28, 0.13, 0.57],
      [0.88, 0.42, 0.12, 0.43],
    ];
    for (final b in buildings) {
      canvas.drawRect(
          Rect.fromLTWH(size.width * b[0] + 2, size.height * b[1],
              size.width * b[2] - 4, size.height * b[3]),
          buildPaint);
    }

    // Trees
    final treePaint = Paint()..color = const Color(0xFF90C9A8);
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
          Offset(size.width * (0.1 + i * 0.25), size.height * 0.78),
          12,
          treePaint);
    }

    // Ground
    canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.82, size.width, size.height * 0.18),
        Paint()..color = const Color(0xFFB5D9C4));
  }

  @override
  bool shouldRepaint(_) => false;
}
