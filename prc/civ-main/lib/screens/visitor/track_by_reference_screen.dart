import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/routes/app_routes.dart';
import '../../core/state/app_state.dart';
import '../../core/utils/helpers.dart';
import '../../models/report.dart';

class TrackByReferenceScreen extends StatefulWidget {
  const TrackByReferenceScreen({super.key});

  @override
  State<TrackByReferenceScreen> createState() =>
      _TrackByReferenceScreenState();
}

class _TrackByReferenceScreenState extends State<TrackByReferenceScreen> {
  final _ctrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _searched = false;
  bool _notFound = false;
  IncidentReport? _result;

  @override
  void dispose() {
    _ctrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search() {
    final query = _ctrl.text.trim();
    if (query.isEmpty) return;
    FocusScope.of(context).unfocus();

    final found = AppState().getByReference(query);

    setState(() {
      _searched = true;
      _result = found;
      _notFound = found == null;
    });
  }

  void _viewDetail() {
    if (_result == null) return;
    Navigator.pushNamed(
      context,
      AppRoutes.trackReport,
      arguments: {
        'reportId': _result!.id,
        'readOnly': true,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              size: 20, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Track by Reference',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'No login required',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.divider),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Instruction card ────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.search_rounded,
                        color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Enter a reference number to view the status and details of any community report.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.primary,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),

            // ── Input label ─────────────────────────────────────────────
            Text(
              'Reference Number',
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // ── Text input ──────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _ctrl,
                    focusNode: _focusNode,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'[A-Za-z0-9\-]')),
                      LengthLimitingTextInputFormatter(16),
                      _RefNumberFormatter(),
                    ],
                    onFieldSubmitted: (_) => _search(),
                    style: GoogleFonts.robotoMono(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.navy,
                      letterSpacing: 1.2,
                    ),
                    decoration: InputDecoration(
                      hintText: 'CW-2026-00001',
                      hintStyle: GoogleFonts.robotoMono(
                        fontSize: 15,
                        color: AppColors.textHint,
                        letterSpacing: 1,
                      ),
                      filled: true,
                      fillColor: AppColors.white,
                      prefixIcon: const Icon(Icons.tag_rounded,
                          color: AppColors.textSecondary, size: 20),
                      suffixIcon: _ctrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear_rounded,
                                  size: 18,
                                  color: AppColors.textSecondary),
                              onPressed: () {
                                _ctrl.clear();
                                setState(() {
                                  _searched = false;
                                  _result = null;
                                  _notFound = false;
                                });
                              },
                            )
                          : null,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.inputBorder),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: AppColors.inputBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                            color: AppColors.navy, width: 2),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: _ctrl.text.trim().isNotEmpty ? _search : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: AppColors.white,
                      disabledBackgroundColor: AppColors.textDisabled,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: Text(
                      'Search',
                      style: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Format: CW-YYYY-#####  (e.g. CW-2026-00125)',
              style: GoogleFonts.inter(
                  fontSize: 11, color: AppColors.textHint),
            ),

            const SizedBox(height: 32),

            // ── Result area ─────────────────────────────────────────────
            if (_searched) ...[
              if (_notFound) _NotFoundCard() else _ResultCard(
                report: _result!,
                onViewDetail: _viewDetail,
              ),
            ] else
              _PlaceholderHint(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Result card — shows summary when found
// ─────────────────────────────────────────────────────────────────────────────

class _ResultCard extends StatelessWidget {
  final IncidentReport report;
  final VoidCallback onViewDetail;

  const _ResultCard({required this.report, required this.onViewDetail});

  @override
  Widget build(BuildContext context) {
    final categoryColor = AppHelpers.getCategoryColor(report.category);
    final categoryBg = AppHelpers.getCategoryBgColor(report.category);
    final statusColor = AppHelpers.getStatusColor(report.status);
    final statusBg = AppHelpers.getStatusBgColor(report.status);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Found badge ───────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(17)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.primary, size: 16),
                const SizedBox(width: 7),
                Text(
                  'Report Found',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category + issue
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: categoryBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        AppHelpers.getIssueIcon(report.issue),
                        color: categoryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            report.issue,
                            style: GoogleFonts.inter(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            report.category,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: categoryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: statusBg,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        report.status,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const Divider(color: AppColors.divider, height: 1),
                const SizedBox(height: 16),

                // Details grid
                _DetailRow(
                  icon: Icons.tag_rounded,
                  label: 'Reference No.',
                  value: report.referenceNumber,
                  valueStyle: GoogleFonts.robotoMono(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.navy,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.location_on_rounded,
                  label: 'Location',
                  value:
                      '${report.barangay}, Digos City',
                ),
                const SizedBox(height: 10),
                _DetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date Submitted',
                  value: AppHelpers.formatDate(report.submittedAt),
                ),
                if (report.assignedOffice != null) ...[
                  const SizedBox(height: 10),
                  _DetailRow(
                    icon: Icons.business_rounded,
                    label: 'Assigned To',
                    value: report.assignedOffice!,
                  ),
                ],
                const SizedBox(height: 18),

                // Progress timeline (compact)
                _CompactTimeline(status: report.status),
                const SizedBox(height: 18),

                // View full details button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onViewDetail,
                    icon: const Icon(Icons.open_in_new_rounded, size: 17),
                    label: const Text('View Full Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.navy,
                      foregroundColor: AppColors.white,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                      textStyle: GoogleFonts.inter(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
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
// Not found card
// ─────────────────────────────────────────────────────────────────────────────

class _NotFoundCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFCA5A5)),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              color: Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.search_off_rounded,
                color: Color(0xFFDC2626), size: 28),
          ),
          const SizedBox(height: 14),
          Text(
            'Report Not Found',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'No report matches that reference number.\nPlease check and try again.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Expected format: CW-2026-#####',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textHint,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Placeholder hint (before any search)
// ─────────────────────────────────────────────────────────────────────────────

class _PlaceholderHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Icon(
            Icons.receipt_long_rounded,
            size: 72,
            color: AppColors.textHint.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 14),
          Text(
            'Enter a reference number above',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Reference numbers are in the format\nCW-YYYY-##### and are shown\non your submitted report.',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textSecondary,
              height: 1.55,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Compact 5-step timeline strip
// ─────────────────────────────────────────────────────────────────────────────

class _CompactTimeline extends StatelessWidget {
  final String status;

  const _CompactTimeline({required this.status});

  static const _steps = [
    'Submitted',
    'Pending\nValidation',
    'Assigned',
    'In Progress',
    'Resolved',
  ];

  static const _statuses = [
    'Submitted',
    'Pending Validation',
    'Assigned to Office',
    'In Progress',
    'Resolved',
  ];

  int get _activeIndex {
    final idx = _statuses.indexWhere(
        (s) => s.toLowerCase() == status.toLowerCase());
    return idx == -1 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    final active = _activeIndex;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Progress',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: List.generate(_steps.length * 2 - 1, (i) {
            if (i.isOdd) {
              // Connector line
              final stepIndex = i ~/ 2;
              final isComplete = stepIndex < active;
              return Expanded(
                child: Container(
                  height: 2,
                  color: isComplete
                      ? AppColors.primary
                      : AppColors.divider,
                ),
              );
            }

            final stepIndex = i ~/ 2;
            final isDone = stepIndex < active;
            final isActive = stepIndex == active;

            return Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? AppColors.primary
                        : isActive
                            ? AppColors.navy
                            : AppColors.background,
                    border: Border.all(
                      color: isDone || isActive
                          ? (isDone ? AppColors.primary : AppColors.navy)
                          : AppColors.divider,
                      width: 2,
                    ),
                  ),
                  child: isDone
                      ? const Icon(Icons.check_rounded,
                          color: AppColors.white, size: 13)
                      : isActive
                          ? Container(
                              width: 10,
                              height: 10,
                              margin: const EdgeInsets.all(5),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.white,
                              ),
                            )
                          : null,
                ),
                const SizedBox(height: 5),
                Text(
                  _steps[stepIndex],
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: isActive || isDone
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: isDone
                        ? AppColors.primary
                        : isActive
                            ? AppColors.navy
                            : AppColors.textHint,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Detail row
// ─────────────────────────────────────────────────────────────────────────────

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: valueStyle ??
                GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Reference number formatter — auto-inserts CW- prefix and dashes
// ─────────────────────────────────────────────────────────────────────────────

class _RefNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue old, TextEditingValue next) {
    var raw = next.text
        .replaceAll('-', '')
        .replaceAll(' ', '')
        .toUpperCase();

    // Strip leading "CW" if user typed it — we'll add it back
    if (raw.startsWith('CW')) raw = raw.substring(2);

    // Limit: 2-letter prefix (CW) + 4-digit year + 5-digit seq = 11 raw digits
    // But we only enforce the structure for display
    final buffer = StringBuffer();
    if (raw.isNotEmpty) {
      buffer.write('CW');
      if (raw.isNotEmpty) buffer.write('-');
      buffer.write(raw.substring(0, raw.length.clamp(0, 4)));
      if (raw.length > 4) {
        buffer.write('-');
        buffer.write(raw.substring(4, raw.length.clamp(4, 9)));
      }
    }
    final str = buffer.toString();
    return next.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}
