import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/dummy_data.dart';
import '../../core/utils/helpers.dart';
import '../../models/report.dart';
import '../../widgets/inputs/search_field.dart';
import 'visitor_shell.dart';

class VisitorReportsScreen extends StatefulWidget {
  const VisitorReportsScreen({super.key});

  @override
  State<VisitorReportsScreen> createState() => _VisitorReportsScreenState();
}

class _VisitorReportsScreenState extends State<VisitorReportsScreen> {
  final _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _activeFilter = 'All';

  static const _filters = ['All', 'Infrastructure', 'Environment'];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<IncidentReport> get _filtered {
    var list = List<IncidentReport>.from(DummyData.communityReports);
    if (_activeFilter != 'All') {
      list = list.where((r) => r.category == _activeFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((r) =>
              r.issue.toLowerCase().contains(q) ||
              r.barangay.toLowerCase().contains(q) ||
              r.referenceNumber.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void _onLoginTap() {
    AppState().exitGuest();
    Navigator.pushReplacementNamed(context, AppRoutes.login,
        arguments: {'fromVisitor': true});
  }

  @override
  Widget build(BuildContext context) {
    final reports = _filtered;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Guest banner ───────────────────────────────────────────────
          GuestBanner(onLoginTap: _onLoginTap),

          // ── Header ────────────────────────────────────────────────────
          Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Reports',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Browse the latest community concerns.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Track by reference
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(
                          context, AppRoutes.trackByReference),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.navy,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.search_rounded,
                                color: AppColors.white, size: 16),
                            const SizedBox(width: 5),
                            Text(
                              'Track',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // Search
                SearchField(
                  hint: 'Search reports...',
                  controller: _searchCtrl,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  onClear: () => setState(() => _searchQuery = ''),
                ),
                const SizedBox(height: 12),

                // Filter chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filters.map((f) {
                      final active = _activeFilter == f;
                      Color chipColor = AppColors.navy;
                      if (f == 'Infrastructure')
                        chipColor = AppColors.infrastructure;
                      if (f == 'Environment')
                        chipColor = AppColors.environment;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _activeFilter = f),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: active ? chipColor : AppColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color:
                                    active ? chipColor : AppColors.divider,
                              ),
                            ),
                            child: Text(
                              f,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: active
                                    ? AppColors.white
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // ── Status legend ──────────────────────────────────────────────
          Container(
            color: AppColors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                _LegendDot(
                    color: AppColors.statusPending, label: 'Pending'),
                const SizedBox(width: 14),
                _LegendDot(
                    color: AppColors.statusInProgress,
                    label: 'In Progress'),
                const SizedBox(width: 14),
                _LegendDot(
                    color: AppColors.statusResolved, label: 'Resolved'),
                const Spacer(),
                Text(
                  '${reports.length} report${reports.length == 1 ? '' : 's'}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),

          // ── Report list ────────────────────────────────────────────────
          Expanded(
            child: reports.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded,
                            size: 56,
                            color: AppColors.textHint
                                .withValues(alpha: 0.5)),
                        const SizedBox(height: 12),
                        Text(
                          'No reports found',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Try a different search or filter.',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    physics: const BouncingScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (_, i) => _PublicReportCard(
                      report: reports[i],
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.trackReport,
                        arguments: {
                          'reportId': reports[i].id,
                          'readOnly': true,
                        },
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
// Public report card — read-only, no "update" actions
// ─────────────────────────────────────────────────────────────────────────────

class _PublicReportCard extends StatelessWidget {
  final IncidentReport report;
  final VoidCallback onTap;

  const _PublicReportCard({required this.report, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppHelpers.getCategoryColor(report.category);
    final categoryBg = AppHelpers.getCategoryBgColor(report.category);
    final statusColor = AppHelpers.getStatusColor(report.status);
    final statusBg = AppHelpers.getStatusBgColor(report.status);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
          boxShadow: const [
            BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 6,
                offset: Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category icon strip
            Container(
              width: 56,
              decoration: BoxDecoration(
                color: categoryBg,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Icon(
                AppHelpers.getIssueIcon(report.issue),
                color: categoryColor,
                size: 26,
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Issue + status
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            report.issue,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            report.status,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: statusColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Location
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          report.barangay,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Date + ref
                    Row(
                      children: [
                        Text(
                          AppHelpers.formatDate(report.submittedAt),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          report.referenceNumber,
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.navy,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Status legend dot
// ─────────────────────────────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
