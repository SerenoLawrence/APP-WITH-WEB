import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/utils/validators.dart';
import '../../widgets/buttons/primary_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.12), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _animController, curve: Curves.easeOutCubic),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isLoading = false);
    final phone = '+63 ${_phoneController.text.trim()}';
    // isNewUser: true → after OTP goes to Register
    // isNewUser: false → after OTP goes straight to Home
    Navigator.pushNamed(context, AppRoutes.otp, arguments: {
      'phone': phone,
      'isNewUser': true,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBg,
      body: Stack(
        children: [
          // ── Background decorations ────────────────────────────────────
          Positioned(
            top: -90,
            right: -90,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.loginBgDark.withOpacity(0.35),
              ),
            ),
          ),
          Positioned(
            top: -30,
            left: -70,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 130,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.loginBgDark.withOpacity(0.15),
              ),
            ),
          ),

          // ── City skyline (bottom) ─────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _CitySkyline(),
          ),

          // ── Main content ──────────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),

                        // ── Logo + title ───────────────────────────────
                        Center(
                          child: Column(
                            children: [
                              _LogoBadge(size: 88),
                              const SizedBox(height: 16),
                              Text(
                                'CIVILWATCH',
                                style: GoogleFonts.inter(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.navy,
                                  letterSpacing: 2.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Community Reporting for a\nBetter Digos City',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                  height: 1.55,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ── Hero tagline ───────────────────────────────
                        Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primary.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppColors.primary
                                      .withOpacity(0.2)),
                            ),
                            child: Text(
                              'Report community concerns and help make\nDigos City better for everyone.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Form card ──────────────────────────────────
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.navy.withOpacity(0.09),
                                blurRadius: 28,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ── Header ─────────────────────────────
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.navy
                                          .withOpacity(0.08),
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                        Icons.phone_android_rounded,
                                        color: AppColors.navy,
                                        size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Enter your phone number',
                                        style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        "We'll send a 6-digit OTP to verify.",
                                        style: GoogleFonts.inter(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),

                              // ── Mobile number label ────────────────
                              Text(
                                'Mobile Number',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // ── Phone input ────────────────────────
                              TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                validator: AppValidators.phoneNumber,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                  _PhoneNumberFormatter(),
                                ],
                                style: GoogleFonts.inter(
                                  fontSize: 15,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                ),
                                decoration: InputDecoration(
                                  hintText: '9XX XXX XXXX',
                                  hintStyle: GoogleFonts.inter(
                                      fontSize: 14,
                                      color: AppColors.textHint),
                                  filled: true,
                                  fillColor: AppColors.inputFill,
                                  prefixIcon: _PhonePrefixWidget(),
                                  suffixIcon: const Icon(
                                      Icons.phone_rounded,
                                      color: AppColors.textHint,
                                      size: 20),
                                  contentPadding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 16),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: AppColors.inputBorder),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: AppColors.inputBorder),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: AppColors.navy, width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDC2626)),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                    borderSide: const BorderSide(
                                        color: Color(0xFFDC2626),
                                        width: 2),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 22),

                              // ── Send OTP button ────────────────────
                              PrimaryButton(
                                label: 'Send OTP',
                                icon: Icons.send_rounded,
                                isLoading: _isLoading,
                                onPressed: _sendOtp,
                                backgroundColor: AppColors.primary,
                                borderRadius: 14,
                                height: 52,
                              ),
                              const SizedBox(height: 18),

                              // ── Privacy note ───────────────────────
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.lock_outline_rounded,
                                        size: 13,
                                        color: AppColors.textSecondary),
                                    const SizedBox(width: 5),
                                    Text(
                                      "We'll never share your number with anyone.",
                                      style: GoogleFonts.inter(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Already have an account ────────────────────
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                const TextSpan(
                                    text: 'Already have an account? '),
                                WidgetSpan(
                                  alignment:
                                      PlaceholderAlignment.baseline,
                                  baseline: TextBaseline.alphabetic,
                                  child: GestureDetector(
                                    onTap: () => Navigator.pushNamed(
                                        context, AppRoutes.otp,
                                        arguments: {
                                          'phone': '',
                                          'isNewUser': false,
                                        }),
                                    child: Text(
                                      'Login',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.navy,
                                        decoration:
                                            TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ── Trust badges ───────────────────────────────
                        _TrustBadgeRow(),

                        const SizedBox(height: 180),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone prefix widget (+63 flag)
// ─────────────────────────────────────────────────────────────────────────────

class _PhonePrefixWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 12, right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(color: AppColors.inputBorder),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '🇵🇭',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(width: 4),
          Text(
            '+63',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 2),
          const Icon(Icons.keyboard_arrow_down_rounded,
              size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone number formatter: 9XX XXX XXXX
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 10; i++) {
      if (i == 3 || i == 6) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return newValue.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Trust badge row
// ─────────────────────────────────────────────────────────────────────────────

class _TrustBadgeRow extends StatelessWidget {
  static const _badges = [
    (Icons.shield_rounded, 'Secure'),
    (Icons.visibility_off_rounded, 'Private'),
    (Icons.verified_rounded, 'Trusted'),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: _badges.map((b) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              Icon(b.$1, size: 20, color: AppColors.primary),
              const SizedBox(height: 4),
              Text(
                b.$2,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Logo Badge
// ─────────────────────────────────────────────────────────────────────────────

class _LogoBadge extends StatelessWidget {
  final double size;
  const _LogoBadge({required this.size});

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
            color: AppColors.navy.withOpacity(0.3),
            blurRadius: 22,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.shield_rounded,
              color: AppColors.white.withOpacity(0.10), size: size * 0.82),
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
// City Skyline illustration (bottom decoration)
// ─────────────────────────────────────────────────────────────────────────────

class _CitySkyline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(MediaQuery.of(context).size.width, 160),
      painter: _SkylinePainter(),
    );
  }
}

class _SkylinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final buildingPaint = Paint()..color = const Color(0xFFCFDDE8);
    final treePaint = Paint()..color = const Color(0xFFB5D4C0);
    final groundPaint = Paint()..color = const Color(0xFFD8EAF0);

    canvas.drawRect(
        Rect.fromLTWH(0, size.height * 0.7, size.width, size.height * 0.3),
        groundPaint);

    final buildings = [
      [0.0, 0.4, 0.12, 0.3],
      [0.1, 0.25, 0.08, 0.45],
      [0.2, 0.3, 0.1, 0.4],
      [0.35, 0.15, 0.12, 0.55],
      [0.48, 0.35, 0.09, 0.35],
      [0.6, 0.2, 0.11, 0.5],
      [0.73, 0.38, 0.08, 0.32],
      [0.82, 0.28, 0.1, 0.42],
      [0.93, 0.4, 0.07, 0.3],
    ];

    for (final b in buildings) {
      canvas.drawRect(
        Rect.fromLTWH(size.width * b[0], size.height * b[1],
            size.width * b[2], size.height * b[3]),
        buildingPaint,
      );
    }

    final windowPaint = Paint()
      ..color = const Color(0xFFE8F4FD).withOpacity(0.8);
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
            windowPaint,
          );
        }
      }
    }

    final treeTrunkPaint = Paint()..color = const Color(0xFFB5A08A);
    final treePositions = [0.05, 0.28, 0.52, 0.68, 0.88];
    for (final tx in treePositions) {
      final x = size.width * tx;
      final y = size.height * 0.58;
      canvas.drawRect(
          Rect.fromLTWH(x + 8, y + 22, 6, 16), treeTrunkPaint);
      canvas.drawCircle(Offset(x + 11, y + 16), 16, treePaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
