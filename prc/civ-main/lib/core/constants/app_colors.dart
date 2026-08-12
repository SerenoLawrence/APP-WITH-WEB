import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Primary Palette ─────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF1B5E20);        // deep green
  static const Color primaryLight = Color(0xFF2E7D32);   // green
  static const Color primaryMid = Color(0xFF388E3C);
  static const Color primarySurface = Color(0xFFE8F5E9); // light green tint

  // ── Navy / Dark ──────────────────────────────────────────────────────────────
  static const Color navy = Color(0xFF0D2137);            // dark navy (CTAs)
  static const Color navyLight = Color(0xFF1A3A5C);

  // ── Status Colors ────────────────────────────────────────────────────────────
  static const Color statusPending = Color(0xFFF59E0B);   // amber/yellow
  static const Color statusPendingBg = Color(0xFFFFFBEB);
  static const Color statusPendingBorder = Color(0xFFFDE68A);

  static const Color statusInProgress = Color(0xFFEA580C); // orange
  static const Color statusInProgressBg = Color(0xFFFFF7ED);
  static const Color statusInProgressBorder = Color(0xFFFED7AA);

  static const Color statusResolved = Color(0xFF16A34A);  // green
  static const Color statusResolvedBg = Color(0xFFF0FDF4);
  static const Color statusResolvedBorder = Color(0xFFBBF7D0);

  static const Color statusAssigned = Color(0xFF2563EB);  // blue
  static const Color statusAssignedBg = Color(0xFFEFF6FF);
  static const Color statusAssignedBorder = Color(0xFFBFDBFE);

  static const Color statusSubmitted = Color(0xFF7C3AED); // purple
  static const Color statusSubmittedBg = Color(0xFFF5F3FF);

  // ── Neutral ──────────────────────────────────────────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // ── Category Colors ──────────────────────────────────────────────────────────
  static const Color infrastructure = Color(0xFFF59E0B);
  static const Color infrastructureBg = Color(0xFFFFFBEB);
  static const Color environment = Color(0xFF16A34A);
  static const Color environmentBg = Color(0xFFF0FDF4);

  // ── Input / Card ─────────────────────────────────────────────────────────────
  static const Color inputBorder = Color(0xFFE2E8F0);
  static const Color inputFill = Color(0xFFF8FAFC);
  static const Color cardShadow = Color(0x0F000000);

  // ── Login screen background ───────────────────────────────────────────────
  static const Color loginBg = Color(0xFFE8F4FD);
  static const Color loginBgDark = Color(0xFFBFDBFE);
}
