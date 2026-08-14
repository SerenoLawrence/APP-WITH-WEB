import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../widgets/inputs/otp_box.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Entry point — call this from the login screen
// ─────────────────────────────────────────────────────────────────────────────

void showForgotPasswordFlow(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _ForgotPasswordSheet(),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// STATE ENUM — drives which modal/screen is shown
// ─────────────────────────────────────────────────────────────────────────────

enum _FpState {
  enterPhone,     // 1. Enter phone number
  otpSent,        // 3. OTP Sent success
  enterOtp,       // 4. Enter OTP + verify
  pleaseWait,     // 6. Resend too soon error
  otpResent,      // 5. OTP Resent success
  invalidOtp,     // 7. Invalid OTP
  setNewPin,      // 8. Set new 6-digit PIN
  resetSuccess,   // 9. Password Reset success
  genericError,   // 10. Generic error
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SHEET — stateful, manages all transitions
// ─────────────────────────────────────────────────────────────────────────────

class _ForgotPasswordSheet extends StatefulWidget {
  const _ForgotPasswordSheet();

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  _FpState _state = _FpState.enterPhone;

  // phone step
  final _phoneCtrl = TextEditingController();
  final _phoneFormKey = GlobalKey<FormState>();
  bool _sendingOtp = false;
  String _phone = '';

  // otp step
  String _otp = '';
  bool _verifying = false;
  int _resendSeconds = 60;
  Timer? _resendTimer;

  // new pin step
  final _newPinCtrl = TextEditingController();
  final _confirmPinCtrl = TextEditingController();
  bool _newPinObscure = true;
  bool _confirmPinObscure = true;
  bool _resetting = false;
  bool _pinMismatch = false;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _newPinCtrl.dispose();
    _confirmPinCtrl.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  // ── Timer ─────────────────────────────────────────────────────────────────
  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendSeconds = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_resendSeconds <= 0) { t.cancel(); return; }
      setState(() => _resendSeconds--);
    });
  }

  // ── Actions ───────────────────────────────────────────────────────────────

  Future<void> _sendOtp() async {
    if (!_phoneFormKey.currentState!.validate()) return;
    _phone = '+63 ${_phoneCtrl.text.trim()}';
    setState(() => _sendingOtp = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _sendingOtp = false;
      _state = _FpState.otpSent;
    });
  }

  void _continueToEnterOtp() {
    setState(() => _state = _FpState.enterOtp);
    _startResendTimer();
  }

  Future<void> _resendOtp() async {
    if (_resendSeconds > 0) {
      setState(() => _state = _FpState.pleaseWait);
      return;
    }
    setState(() => _sendingOtp = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _sendingOtp = false;
      _state = _FpState.otpResent;
    });
    _startResendTimer();
  }

  Future<void> _verifyOtp() async {
    if (_otp.length != 6) return;
    setState(() => _verifying = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _verifying = false);

    // Simulate: wrong OTP if it's all same digits (demo only)
    if (_otp == '000000') {
      setState(() => _state = _FpState.invalidOtp);
    } else {
      setState(() => _state = _FpState.setNewPin);
    }
  }

  Future<void> _resetPassword() async {
    final newPin = _newPinCtrl.text.trim();
    final confirmPin = _confirmPinCtrl.text.trim();
    if (newPin.length != 6) return;
    if (newPin != confirmPin) {
      setState(() => _pinMismatch = true);
      return;
    }
    setState(() { _resetting = true; _pinMismatch = false; });
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _resetting = false;
      _state = _FpState.resetSuccess;
    });
  }

  void _goToLogin() {
    Navigator.of(context).pop(); // close sheet
    // Login screen is already underneath — no navigation needed
  }

  String get _timerText {
    final mm = (_resendSeconds ~/ 60).toString().padLeft(2, '0');
    final ss = (_resendSeconds % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: _buildCurrentState(),
    );
  }

  Widget _buildCurrentState() {
    switch (_state) {
      case _FpState.enterPhone:
        return _EnterPhoneModal(
          key: const ValueKey('enterPhone'),
          formKey: _phoneFormKey,
          controller: _phoneCtrl,
          isSending: _sendingOtp,
          onSend: _sendOtp,
          onCancel: () => Navigator.pop(context),
        );

      case _FpState.otpSent:
        return _StatusModal(
          key: const ValueKey('otpSent'),
          isSuccess: true,
          title: 'OTP Sent!',
          message:
              'We\'ve sent a 6-digit OTP\nto your mobile number\n$_phone.',
          primaryLabel: 'Continue',
          onPrimary: _continueToEnterOtp,
          secondaryLabel: 'Resend OTP (60s)',
          onSecondary: null, // disabled until timer runs out
          onClose: () => Navigator.pop(context),
        );

      case _FpState.enterOtp:
        return _EnterOtpModal(
          key: const ValueKey('enterOtp'),
          phone: _phone,
          resendSeconds: _resendSeconds,
          timerText: _timerText,
          isSending: _sendingOtp,
          isVerifying: _verifying,
          onOtpChanged: (v) => setState(() => _otp = v),
          onVerify: _verifyOtp,
          onResend: _resendOtp,
          onBack: () => setState(() => _state = _FpState.enterPhone),
        );

      case _FpState.pleaseWait:
        return _StatusModal(
          key: const ValueKey('pleaseWait'),
          isSuccess: false,
          isWarning: true,
          title: 'Please wait',
          message:
              'You can request a new OTP\nin $_resendSeconds seconds.',
          primaryLabel: 'OK',
          onPrimary: () => setState(() => _state = _FpState.enterOtp),
          onClose: () => setState(() => _state = _FpState.enterOtp),
        );

      case _FpState.otpResent:
        return _StatusModal(
          key: const ValueKey('otpResent'),
          isSuccess: true,
          title: 'OTP Resent!',
          message:
              'A new 6-digit OTP has been sent\nto your mobile number\n$_phone.',
          primaryLabel: 'OK',
          onPrimary: () => setState(() => _state = _FpState.enterOtp),
          onClose: () => setState(() => _state = _FpState.enterOtp),
        );

      case _FpState.invalidOtp:
        return _StatusModal(
          key: const ValueKey('invalidOtp'),
          isSuccess: false,
          title: 'Invalid OTP',
          message:
              'The code you entered is incorrect.\nPlease check and try again.',
          primaryLabel: 'Try Again',
          onPrimary: () => setState(() => _state = _FpState.enterOtp),
          primaryIsDestructive: true,
          onClose: () => setState(() => _state = _FpState.enterOtp),
        );

      case _FpState.setNewPin:
        return _SetNewPinModal(
          key: const ValueKey('setNewPin'),
          newPinCtrl: _newPinCtrl,
          confirmPinCtrl: _confirmPinCtrl,
          newPinObscure: _newPinObscure,
          confirmPinObscure: _confirmPinObscure,
          onToggleNewPin: () =>
              setState(() => _newPinObscure = !_newPinObscure),
          onToggleConfirmPin: () =>
              setState(() => _confirmPinObscure = !_confirmPinObscure),
          isResetting: _resetting,
          pinMismatch: _pinMismatch,
          onReset: _resetPassword,
          onBack: () => setState(() => _state = _FpState.enterOtp),
        );

      case _FpState.resetSuccess:
        return _StatusModal(
          key: const ValueKey('resetSuccess'),
          isSuccess: true,
          title: 'Password Reset!',
          message:
              'Your password has been updated\nsuccessfully. You can now log in\nwith your new password.',
          primaryLabel: 'Go to Login',
          onPrimary: _goToLogin,
          onClose: _goToLogin,
        );

      case _FpState.genericError:
        return _StatusModal(
          key: const ValueKey('genericError'),
          isSuccess: false,
          title: 'Something went wrong',
          message: 'An unexpected error occurred.\nPlease try again later.',
          primaryLabel: 'Try Again',
          primaryIsDestructive: true,
          onPrimary: () => setState(() => _state = _FpState.enterPhone),
          onClose: () => Navigator.pop(context),
        );
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL 1 — Enter Phone Number
// ─────────────────────────────────────────────────────────────────────────────

class _EnterPhoneModal extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController controller;
  final bool isSending;
  final VoidCallback onSend;
  final VoidCallback onCancel;

  const _EnterPhoneModal({
    super.key,
    required this.formKey,
    required this.controller,
    required this.isSending,
    required this.onSend,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return _SheetWrapper(
      onClose: onCancel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(Icons.mark_email_unread_rounded,
                    color: AppColors.primary, size: 36),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border:
                          Border.all(color: AppColors.white, width: 2),
                    ),
                    child: const Icon(Icons.lock_outline_rounded,
                        color: AppColors.white, size: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Forgot Password?',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Enter your mobile number and we\'ll\nsend you a 6-digit OTP to reset\nyour password.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Phone field
          Form(
            key: formKey,
            child: _PhoneField(controller: controller),
          ),
          const SizedBox(height: 20),

          // Send OTP button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isSending ? null : onSend,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: isSending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white),
                    )
                  : const Text('Send OTP'),
            ),
          ),
          const SizedBox(height: 10),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onCancel,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                minimumSize: const Size(0, 48),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL 4 — Enter OTP + Verify
// ─────────────────────────────────────────────────────────────────────────────

class _EnterOtpModal extends StatelessWidget {
  final String phone;
  final int resendSeconds;
  final String timerText;
  final bool isSending;
  final bool isVerifying;
  final void Function(String) onOtpChanged;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onBack;

  const _EnterOtpModal({
    super.key,
    required this.phone,
    required this.resendSeconds,
    required this.timerText,
    required this.isSending,
    required this.isVerifying,
    required this.onOtpChanged,
    required this.onVerify,
    required this.onResend,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return _SheetWrapper(
      onClose: onBack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Back button row
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_ios_new_rounded,
                      size: 14, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text('Back',
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Enter OTP',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary, height: 1.6),
              children: [
                const TextSpan(text: 'We\'ve sent a 6-digit code to\n'),
                TextSpan(
                  text: phone,
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // OTP input boxes
          OtpInputRow(
            length: 6,
            onChanged: onOtpChanged,
            onCompleted: onOtpChanged,
          ),
          const SizedBox(height: 20),

          // Resend
          Text(
            "Didn't receive the code?",
            style: GoogleFonts.inter(
                fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 4),
          GestureDetector(
            onTap: onResend,
            child: Text(
              resendSeconds > 0
                  ? 'Resend OTP ($timerText)'
                  : 'Resend OTP',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: resendSeconds > 0
                    ? AppColors.textSecondary
                    : AppColors.primary,
                decoration: resendSeconds == 0
                    ? TextDecoration.underline
                    : TextDecoration.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Verify button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isVerifying ? null : onVerify,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: isVerifying
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white),
                    )
                  : const Text('Verify'),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MODAL 8 — Set New PIN
// ─────────────────────────────────────────────────────────────────────────────

class _SetNewPinModal extends StatelessWidget {
  final TextEditingController newPinCtrl;
  final TextEditingController confirmPinCtrl;
  final bool newPinObscure;
  final bool confirmPinObscure;
  final VoidCallback onToggleNewPin;
  final VoidCallback onToggleConfirmPin;
  final bool isResetting;
  final bool pinMismatch;
  final VoidCallback onReset;
  final VoidCallback onBack;

  const _SetNewPinModal({
    super.key,
    required this.newPinCtrl,
    required this.confirmPinCtrl,
    required this.newPinObscure,
    required this.confirmPinObscure,
    required this.onToggleNewPin,
    required this.onToggleConfirmPin,
    required this.isResetting,
    required this.pinMismatch,
    required this.onReset,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final hasNewPin = newPinCtrl.text.length == 6;
    final hasConfirm = confirmPinCtrl.text.length == 6;
    final canReset = hasNewPin && hasConfirm && !isResetting;

    return _SheetWrapper(
      onClose: onBack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back
          GestureDetector(
            onTap: onBack,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('Back',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Set New Password',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Create a new password for your account.',
            style: GoogleFonts.inter(
                fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),

          // New PIN
          _PinField(
            controller: newPinCtrl,
            hint: 'New Password',
            obscure: newPinObscure,
            onToggle: onToggleNewPin,
            isError: pinMismatch,
          ),
          const SizedBox(height: 12),

          // Confirm PIN
          _PinField(
            controller: confirmPinCtrl,
            hint: 'Confirm Password',
            obscure: confirmPinObscure,
            onToggle: onToggleConfirmPin,
            isError: pinMismatch,
          ),

          // Mismatch error
          if (pinMismatch) ...[
            const SizedBox(height: 8),
            Text(
              'Passwords do not match. Please try again.',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFFDC2626),
                  fontWeight: FontWeight.w500),
            ),
          ],

          const SizedBox(height: 20),

          // Reset button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: canReset ? onReset : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.textDisabled,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: isResetting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.white),
                    )
                  : const Text('Reset Password'),
            ),
          ),
          const SizedBox(height: 14),

          // Password hint
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline_rounded,
                    size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Password must be exactly 6 digits (numbers only).',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.primary, height: 1.5),
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

// ─────────────────────────────────────────────────────────────────────────────
// REUSABLE STATUS MODAL (success / error / warning)
// Used for: OTP Sent, OTP Resent, Invalid OTP, Please Wait,
//           Password Reset, Generic Error
// ─────────────────────────────────────────────────────────────────────────────

class _StatusModal extends StatelessWidget {
  final bool isSuccess;
  final bool isWarning;
  final String title;
  final String message;
  final String primaryLabel;
  final VoidCallback? onPrimary;
  final bool primaryIsDestructive;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;
  final VoidCallback onClose;

  const _StatusModal({
    super.key,
    required this.isSuccess,
    this.isWarning = false,
    required this.title,
    required this.message,
    required this.primaryLabel,
    required this.onPrimary,
    this.primaryIsDestructive = false,
    this.secondaryLabel,
    this.onSecondary,
    required this.onClose,
  });

  Color get _iconBg => isSuccess
      ? const Color(0xFFDCFCE7)
      : isWarning
          ? const Color(0xFFFEF3C7)
          : const Color(0xFFFEE2E2);

  Color get _iconColor => isSuccess
      ? const Color(0xFF16A34A)
      : isWarning
          ? const Color(0xFFD97706)
          : const Color(0xFFDC2626);

  IconData get _icon => isSuccess
      ? Icons.check_circle_rounded
      : isWarning
          ? Icons.warning_amber_rounded
          : Icons.error_rounded;

  @override
  Widget build(BuildContext context) {
    return _SheetWrapper(
      onClose: onClose,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Status icon
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: _iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: _iconColor, size: 38),
          ),
          const SizedBox(height: 16),

          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Primary button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPrimary,
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryIsDestructive
                    ? const Color(0xFFDC2626)
                    : AppColors.primary,
                foregroundColor: AppColors.white,
                minimumSize: const Size(0, 52),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
                textStyle: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700),
              ),
              child: Text(primaryLabel),
            ),
          ),

          // Optional secondary
          if (secondaryLabel != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: onSecondary,
                style: TextButton.styleFrom(
                  foregroundColor: onSecondary != null
                      ? AppColors.navy
                      : AppColors.textDisabled,
                  minimumSize: const Size(0, 44),
                ),
                child: Text(
                  secondaryLabel!,
                  style: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED SHEET WRAPPER — white card with handle + close button
// ─────────────────────────────────────────────────────────────────────────────

class _SheetWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;

  const _SheetWrapper({required this.child, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 60, 0, 0),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Close button
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 4, 8, 0),
              child: IconButton(
                icon: const Icon(Icons.close_rounded,
                    color: AppColors.textSecondary, size: 22),
                onPressed: onClose,
              ),
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: child,
            ),
          ),

          // Bottom safe area
          SizedBox(height: MediaQuery.of(context).viewInsets.bottom + 8),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED PHONE INPUT FIELD
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;

  const _PhoneField({required this.controller});

  String? _validate(String? v) {
    final digits = (v ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return 'Mobile number is required';
    if (digits.length < 10) return 'Enter a valid 10-digit mobile number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,
      validator: _validate,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
        _PhoneFmt(),
      ],
      style: GoogleFonts.inter(
          fontSize: 15,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: 'Mobile Number',
        hintStyle:
            GoogleFonts.inter(fontSize: 14, color: AppColors.textHint),
        filled: true,
        fillColor: AppColors.inputFill,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.phone_android_rounded,
                  color: AppColors.textSecondary, size: 18),
              const SizedBox(width: 6),
              Text('+63',
                  style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary)),
            ],
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.navy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDC2626)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              const BorderSide(color: Color(0xFFDC2626), width: 2),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARED PIN FIELD (for Set New Password modal)
// ─────────────────────────────────────────────────────────────────────────────

class _PinField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final VoidCallback onToggle;
  final bool isError;

  const _PinField({
    required this.controller,
    required this.hint,
    required this.obscure,
    required this.onToggle,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      obscureText: obscure,
      obscuringCharacter: '●',
      maxLength: 6,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      style: GoogleFonts.inter(
          fontSize: 18,
          color: isError ? const Color(0xFFDC2626) : AppColors.navy,
          fontWeight: FontWeight.w700,
          letterSpacing: 4),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        counterText: '',
        hintText: hint,
        hintStyle: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textHint,
            fontWeight: FontWeight.w400,
            letterSpacing: 0),
        filled: true,
        fillColor: AppColors.inputFill,
        prefixIcon: const Icon(Icons.lock_outline_rounded,
            color: AppColors.textSecondary, size: 18),
        suffixIcon: IconButton(
          icon: Icon(
            obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textSecondary,
            size: 18,
          ),
          onPressed: onToggle,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isError
                  ? const Color(0xFFDC2626)
                  : AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isError
                  ? const Color(0xFFDC2626)
                  : AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
              color: isError ? const Color(0xFFDC2626) : AppColors.navy,
              width: 2),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Phone formatter
// ─────────────────────────────────────────────────────────────────────────────

class _PhoneFmt extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue o, TextEditingValue n) {
    final d = n.text.replaceAll(RegExp(r'\D'), '');
    final buf = StringBuffer();
    for (var i = 0; i < d.length && i < 10; i++) {
      if (i == 3 || i == 6) buf.write(' ');
      buf.write(d[i]);
    }
    final s = buf.toString();
    return n.copyWith(
        text: s, selection: TextSelection.collapsed(offset: s.length));
  }
}
