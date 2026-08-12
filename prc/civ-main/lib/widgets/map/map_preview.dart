import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/utils/helpers.dart';

/// A static map preview widget that simulates a map using a colored container
/// with grid lines and a marker. Used for the private map and location previews.
class MapPreviewWidget extends StatelessWidget {
  final double? latitude;
  final double? longitude;
  final String? issueLabel;
  final String? status;
  final bool isBlurred;
  final bool showPopup;
  final double height;
  final VoidCallback? onTap;

  const MapPreviewWidget({
    super.key,
    this.latitude,
    this.longitude,
    this.issueLabel,
    this.status,
    this.isBlurred = false,
    this.showPopup = false,
    this.height = 220,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: height,
          child: Stack(
            children: [
              // ── Simulated map background ─────────────────────────────────
              _SimulatedMapBackground(isBlurred: isBlurred),

              // ── Blur overlay ─────────────────────────────────────────────
              if (isBlurred)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(color: Colors.black.withOpacity(0.08)),
                ),

              // ── Pin ───────────────────────────────────────────────────────
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showPopup && issueLabel != null) ...[
                      _PinPopup(issue: issueLabel!, status: status ?? 'Pending'),
                      const SizedBox(height: 4),
                    ],
                    _MapPin(status: status ?? 'In Progress', issue: issueLabel),
                  ],
                ),
              ),

              // ── Controls overlay (right side) ─────────────────────────────
              Positioned(
                right: 10,
                bottom: 10,
                child: Column(
                  children: [
                    _MapButton(icon: Icons.add_rounded),
                    const SizedBox(height: 4),
                    _MapButton(icon: Icons.remove_rounded),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SimulatedMapBackground extends StatelessWidget {
  final bool isBlurred;
  const _SimulatedMapBackground({this.isBlurred = false});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: Container(
        color: const Color(0xFFE8EFF5),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFEEF2F7),
    );

    // Roads
    final roadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final minorRoadPaint = Paint()
      ..color = const Color(0xFFFFFFFF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // Horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.45),
      Offset(size.width, size.height * 0.45),
      roadPaint,
    );
    // Vertical road
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      roadPaint,
    );
    // Diagonal road
    canvas.drawLine(
      Offset(0, size.height * 0.3),
      Offset(size.width * 0.6, size.height),
      minorRoadPaint,
    );
    // River / water body
    final waterPaint = Paint()
      ..color = const Color(0xFFB3D4E8)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(size.width * 0.2, 0);
    path.quadraticBezierTo(
      size.width * 0.5, size.height * 0.5,
      size.width, size.height * 0.55,
    );
    canvas.drawPath(path, waterPaint);

    // Block fills
    final blockPaint = Paint()..color = const Color(0xFFD8E2DC).withOpacity(0.5);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.05, size.height * 0.05, 60, 40),
        blockPaint);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.1, 70, 30),
        blockPaint);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.1, size.height * 0.6, 50, 50),
        blockPaint);
    canvas.drawRect(
        Rect.fromLTWH(size.width * 0.6, size.height * 0.65, 65, 40),
        blockPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapPin extends StatelessWidget {
  final String status;
  final String? issue;

  const _MapPin({required this.status, this.issue});

  @override
  Widget build(BuildContext context) {
    final color = AppHelpers.getStatusColor(status);
    final icon = AppHelpers.getIssueIcon(issue ?? '');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 3))
            ],
          ),
          child: Icon(icon, color: AppColors.white, size: 22),
        ),
        CustomPaint(
          size: const Size(12, 8),
          painter: _PinTailPainter(color: color),
        ),
      ],
    );
  }
}

class _PinTailPainter extends CustomPainter {
  final Color color;
  const _PinTailPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _PinPopup extends StatelessWidget {
  final String issue;
  final String status;

  const _PinPopup({required this.issue, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = AppHelpers.getStatusColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: AppHelpers.getStatusBgColor(status),
              shape: BoxShape.circle,
            ),
            child: Icon(
              AppHelpers.getIssueIcon(issue),
              size: 14,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                issue,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapButton extends StatelessWidget {
  final IconData icon;
  const _MapButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 4),
        ],
      ),
      child: Icon(icon, size: 18, color: AppColors.textPrimary),
    );
  }
}
