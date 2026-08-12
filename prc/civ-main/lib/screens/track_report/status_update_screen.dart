import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/helpers.dart';
import '../../models/report.dart';

/// Matches the "Status Update" reference image:
/// ─ App bar: "Status Update / Track the latest progress"
/// ─ Top info card: photo | issue/category/location/ref/submitted | status chip
/// ─ Horizontal progress timeline with "Current" badge
/// ─ Status message banner (yellow for pending, orange for in-progress, etc.)
/// ─ Full vertical "Status Updates" activity log
/// ─ Notification bar + View on Map button
class StatusUpdateScreen extends StatelessWidget {
  final Map<String, dynamic> reportData;
  const StatusUpdateScreen({super.key, required this.reportData});

  IncidentReport? _getReport() {
    final id = reportData['reportId'] as String?;
    if (id != null) return AppState().getById(id);
    return AppState().reports.isNotEmpty ? AppState().reports.first : null;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppState(),
      builder: (context, _) {
        final report = _getReport();
        if (report == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Status Update'),
              backgroundColor: AppColors.white,
              foregroundColor: AppColors.textPrimary,
              elevation: 0,
            ),
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Report not found — Go Back'),
              ),
            ),
          );
        }
        return _StatusUpdateBody(report: report);
      },
    );
  }
}

class _StatusUpdateBody extends StatelessWidget {
  final IncidentReport report;
  const _StatusUpdateBody({required this.report});

  static const _steps = [
    'Submitted',
    'Pending\nValidation',
    'Assigned to\nOffice',
    'In Progress',
    'Resolved',
  ];
  static const _stepsRaw = [
    'Submitted',
    'Pending Validation',
    'Assigned to Office',
    'In Progress',
    'Resolved',
  ];

  @override
  Widget build(BuildContext context) {
    final catColor = AppHelpers.getCategoryColor(report.category);
    final catBg = AppHelpers.getCategoryBgColor(report.category);
    final catIcon = AppHelpers.getCategoryIcon(report.category);
    final statusColor = AppHelpers.getStatusColor(report.status);
    final statusBg = AppHelpers.getStatusBgColor(report.status);
    final statusIcon = AppHelpers.getStatusIcon(report.status);
    final currentIdx = report.statusIndex;
    final unread = AppState().unreadCount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status Update',
                style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary)),
            Text('Track the latest progress of your report.',
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
        actions: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textPrimary, size: 26),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
              ),
              if (unread > 0)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                        color: AppColors.statusResolved,
                        shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top info card ─────────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Photo
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomLeft: Radius.circular(16),
                    ),
                    child: Container(
                      width: 110,
                      height: 130,
                      color: const Color(0xFF1A2A3A),
                      child: Center(
                        child: Icon(catIcon,
                            color: AppColors.white.withValues(alpha: 0.3),
                            size: 36),
                      ),
                    ),
                  ),
                  // Info
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(report.issue,
                              style: GoogleFonts.inter(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 5),
                          // Category chip
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: catBg,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(catIcon, size: 10, color: catColor),
                                const SizedBox(width: 4),
                                Text(report.category,
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: catColor)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  size: 11, color: AppColors.textSecondary),
                              const SizedBox(width: 3),
                              Expanded(
                                child: Text(
                                    'Barangay ${report.barangay}, Digos City',
                                    style: GoogleFonts.inter(
                                        fontSize: 10,
                                        color: AppColors.textSecondary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text('Reference No.  ${report.referenceNumber}',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.navy)),
                          const SizedBox(height: 3),
                          Text(
                              'Submitted  ${AppHelpers.formatDateTime(report.submittedAt)}',
                              style: GoogleFonts.inter(
                                  fontSize: 10,
                                  color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                  // Status chip (right side)
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: statusColor.withValues(alpha: 0.3)),
                          ),
                          child: Column(
                            children: [
                              Text(report.status,
                                  style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: statusColor)),
                              Text('Current Status',
                                  style: GoogleFonts.inter(
                                      fontSize: 9,
                                      color: AppColors.textHint)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded,
                                size: 10, color: AppColors.textHint),
                            const SizedBox(width: 3),
                            Text(
                                'Submitted\n${AppHelpers.formatDate(report.submittedAt)}',
                                style: GoogleFonts.inter(
                                    fontSize: 9,
                                    color: AppColors.textHint)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Horizontal Progress Timeline ───────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Progress Timeline',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  _HorizontalTimeline(
                      steps: _steps,
                      stepsRaw: _stepsRaw,
                      currentIdx: currentIdx,
                      activityLog: report.activityLog),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Status message banner ─────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: statusColor.withValues(alpha: 0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(report.status,
                            style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: statusColor)),
                        const SizedBox(height: 3),
                        Text(_statusMessage(report.status),
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                                height: 1.4)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Status Updates (full activity log) ────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status Updates',
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 16),
                  // Completed entries from activityLog
                  ...report.activityLog.map((entry) {
                    final isCurrentEntry =
                        entry == report.activityLog.last;
                    final entryColor =
                        AppHelpers.getStatusColor(entry.status);
                    final entryBg =
                        AppHelpers.getStatusBgColor(entry.status);
                    final entryIcon =
                        AppHelpers.getStatusIcon(entry.status);
                    final isLast = entry == report.activityLog.last;

                    return _ActivityRow(
                      icon: entryIcon,
                      iconColor: entryColor,
                      iconBg: entryBg,
                      title: entry.title,
                      titleColor: isCurrentEntry
                          ? entryColor
                          : AppColors.textPrimary,
                      description: entry.description,
                      timeLabel: AppHelpers.formatDateTime(entry.timestamp),
                      isCurrent: isCurrentEntry,
                      showLine: !isLast,
                      isHighlighted: isCurrentEntry,
                      highlightBg: entryBg,
                      highlightBorder: entryColor.withValues(alpha: 0.3),
                    );
                  }),
                  // Future pending steps (greyed out)
                  ..._buildPendingSteps(report),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── Notification bar ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.navy,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.notifications_outlined,
                      color: AppColors.white, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'You will be notified whenever there is an update on your report.',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.white.withValues(alpha: 0.9),
                          height: 1.4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.settings_rounded,
                              size: 12, color: AppColors.white),
                          const SizedBox(width: 4),
                          Text('Manage\nNotifications',
                              style: GoogleFonts.inter(
                                  fontSize: 9,
                                  color: AppColors.white,
                                  fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // ── View on Map ───────────────────────────────────────────
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(
                    context, AppRoutes.privateMap,
                    arguments: {'reportId': report.id}),
                icon: const Icon(Icons.map_rounded, size: 20),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('View on Map'),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded, size: 16),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.navy,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                  textStyle: GoogleFonts.inter(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // ── Demo: Advance status ──────────────────────────────────
            if (report.status != 'Resolved')
              _AdvanceStatusButton(report: report),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildPendingSteps(IncidentReport report) {
    const allSteps = [
      'Submitted',
      'Pending Validation',
      'Assigned to Office',
      'In Progress',
      'Resolved',
    ];
    const descriptions = {
      'Assigned to Office':
          'This report will be assigned to the appropriate office after validation.',
      'In Progress': 'Work is currently in progress.',
      'Resolved': 'The issue has been resolved.',
    };

    final completedStatuses =
        report.activityLog.map((e) => e.status).toSet();
    final pending = allSteps
        .where((s) => !completedStatuses.contains(s))
        .toList();

    return pending.asMap().entries.map((entry) {
      final step = entry.value;
      final isLast = entry.key == pending.length - 1;
      return _ActivityRow(
        icon: AppHelpers.getStatusIcon(step),
        iconColor: AppColors.textDisabled,
        iconBg: AppColors.background,
        title: step,
        titleColor: AppColors.textHint,
        description: descriptions[step] ?? '',
        timeLabel: null,
        isCurrent: false,
        showLine: !isLast,
        isHighlighted: false,
        highlightBg: Colors.transparent,
        highlightBorder: Colors.transparent,
      );
    }).toList();
  }

  String _statusMessage(String status) {
    switch (status.toLowerCase()) {
      case 'submitted':
        return 'Your report has been submitted successfully.';
      case 'pending validation':
        return 'Your report is currently being reviewed by the Super Administrator. Please wait for updates.';
      case 'assigned to office':
        return 'Your report has been assigned to the appropriate government office.';
      case 'in progress':
        return 'The assigned office is currently working on resolving this issue.';
      case 'resolved':
        return 'This issue has been successfully resolved. Thank you for your report.';
      default:
        return 'Status updated.';
    }
  }
}

// ── Horizontal timeline widget ────────────────────────────────────────────────
class _HorizontalTimeline extends StatelessWidget {
  final List<String> steps;
  final List<String> stepsRaw;
  final int currentIdx;
  final List<ActivityEntry> activityLog;

  const _HorizontalTimeline({
    required this.steps,
    required this.stepsRaw,
    required this.currentIdx,
    required this.activityLog,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(steps.length, (i) {
          final isDone = i <= currentIdx;
          final isCurrent = i == currentIdx;
          final isLast = i == steps.length - 1;
          final color = isDone
              ? AppHelpers.getStatusColor(stepsRaw[i])
              : AppColors.textDisabled;
          final icon = AppHelpers.getStatusIcon(stepsRaw[i]);
          final timeLabel = i < activityLog.length
              ? AppHelpers.formatDateShort(activityLog[i].timestamp) +
                  ', ' +
                  AppHelpers.formatTime(activityLog[i].timestamp)
              : null;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 68,
                child: Column(
                  children: [
                    // Circle icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDone
                            ? AppHelpers.getStatusBgColor(stepsRaw[i])
                            : AppColors.background,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDone ? color : AppColors.divider,
                          width: isCurrent ? 2.5 : 1.5,
                        ),
                      ),
                      child: Icon(icon,
                          size: 18,
                          color: isDone ? color : AppColors.textDisabled),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      steps[i],
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: isCurrent
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: isDone
                            ? AppColors.textPrimary
                            : AppColors.textHint,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (timeLabel != null) ...[
                      const SizedBox(height: 3),
                      Text(
                        timeLabel,
                        style: GoogleFonts.inter(
                            fontSize: 9, color: AppColors.textHint),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    if (isCurrent) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('Current',
                            style: GoogleFonts.inter(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: color)),
                      ),
                    ],
                  ],
                ),
              ),
              if (!isLast)
                Padding(
                  padding: const EdgeInsets.only(top: 18),
                  child: Container(
                    width: 28,
                    height: 2.5,
                    decoration: BoxDecoration(
                      color: i < currentIdx
                          ? AppColors.primary
                          : AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }
}

// ── Single activity row with connecting line ──────────────────────────────────
class _ActivityRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final Color titleColor;
  final String description;
  final String? timeLabel;
  final bool isCurrent;
  final bool showLine;
  final bool isHighlighted;
  final Color highlightBg;
  final Color highlightBorder;

  const _ActivityRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.titleColor,
    required this.description,
    required this.timeLabel,
    required this.isCurrent,
    required this.showLine,
    required this.isHighlighted,
    required this.highlightBg,
    required this.highlightBorder,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: EdgeInsets.only(
          left: 12, right: 8, top: 2, bottom: showLine ? 0 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: titleColor)),
              ),
              if (isCurrent)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('Current',
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: iconColor)),
                ),
            ],
          ),
          if (description.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(description,
                style: GoogleFonts.inter(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
          if (timeLabel != null) ...[
            const SizedBox(height: 4),
            Text(timeLabel!,
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textHint)),
          ],
          if (showLine) const SizedBox(height: 12),
        ],
      ),
    );

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 18),
            ),
            if (showLine)
              Container(
                  width: 2, height: 40, color: AppColors.divider),
          ],
        ),
        Expanded(child: content),
      ],
    );

    if (isHighlighted) {
      return Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: highlightBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: highlightBorder),
        ),
        child: row,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: row,
    );
  }
}

// ── Demo: Advance status button ───────────────────────────────────────────────
class _AdvanceStatusButton extends StatelessWidget {
  final IncidentReport report;
  const _AdvanceStatusButton({required this.report});

  static const _order = [
    'Submitted',
    'Pending Validation',
    'Assigned to Office',
    'In Progress',
    'Resolved',
  ];

  String? get _nextStatus {
    final idx = _order.indexOf(report.status);
    if (idx == -1 || idx >= _order.length - 1) return null;
    return _order[idx + 1];
  }

  @override
  Widget build(BuildContext context) {
    final next = _nextStatus;
    if (next == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        AppState().updateStatus(report.id, next);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status advanced to: $next'),
            backgroundColor: AppColors.statusResolved,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.all(16),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.primarySurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: AppColors.primary.withOpacity(0.3), width: 1.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.play_circle_outline_rounded,
                color: AppColors.primary, size: 20),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demo: Advance Status',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary),
                ),
                Text(
                  'Next: $next',
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
            const Spacer(),
            const Icon(Icons.arrow_forward_rounded,
                color: AppColors.primary, size: 18),
          ],
        ),
      ),
    );
  }
}
