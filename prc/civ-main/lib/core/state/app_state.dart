import 'package:flutter/material.dart';
import '../../models/report.dart';
import '../../models/notification_model.dart';
import '../utils/dummy_data.dart';
import '../utils/helpers.dart';

/// Simple in-memory ChangeNotifier state manager.
/// No backend — all data lives here for the prototype.
class AppState extends ChangeNotifier {
  // ── Singleton ─────────────────────────────────────────────────────────────
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal() {
    _reports = List.from(DummyData.myReports);
    _communityReports = List.from(DummyData.communityReports);
    _notifications = List.from(DummyData.notifications);
  }

  // ── Reports ───────────────────────────────────────────────────────────────
  late List<IncidentReport> _reports;

  // Community reports are read-only — never shown in My Reports list.
  late List<IncidentReport> _communityReports;

  List<IncidentReport> get reports => List.unmodifiable(_reports);

  /// Looks up by ID in both own reports and community reports.
  IncidentReport? getById(String id) {
    try {
      return _reports.firstWhere((r) => r.id == id);
    } catch (_) {}
    try {
      return _communityReports.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Called when resident submits a new report.
  void addReport(IncidentReport report) {
    _reports.insert(0, report);
    // Auto-add notifications for submission
    _notifications.insert(
      0,
      AppNotification(
        id: 'n-${DateTime.now().millisecondsSinceEpoch}-a',
        title: 'Concern Submitted',
        message:
            'Your concern ${report.referenceNumber} has been submitted successfully.',
        referenceNumber: report.referenceNumber,
        status: 'Submitted',
        timestamp: DateTime.now(),
        isRead: false,
      ),
    );
    _notifications.insert(
      0,
      AppNotification(
        id: 'n-${DateTime.now().millisecondsSinceEpoch}-b',
        title: 'Pending Validation',
        message:
            '${report.referenceNumber} is now under review by the Super Administrator.',
        referenceNumber: report.referenceNumber,
        status: 'Pending Validation',
        timestamp: DateTime.now().add(const Duration(minutes: 1)),
        isRead: false,
      ),
    );
    notifyListeners();
  }

  /// Update status of an existing report (used by demo status cycling).
  void updateStatus(String reportId, String newStatus) {
    final idx = _reports.indexWhere((r) => r.id == reportId);
    if (idx == -1) return;
    final report = _reports[idx];
    final newLog = List<ActivityEntry>.from(report.activityLog)
      ..add(
        ActivityEntry(
          title: newStatus,
          description: _statusDescription(newStatus),
          timestamp: DateTime.now(),
          status: newStatus,
        ),
      );
    _reports[idx] = report.copyWith(
      status: newStatus,
      activityLog: newLog,
      resolvedAt: newStatus == 'Resolved' ? DateTime.now() : report.resolvedAt,
    );
    // Add notification
    _notifications.insert(
      0,
      AppNotification(
        id: 'n-${DateTime.now().millisecondsSinceEpoch}',
        title: newStatus,
        message: '${report.referenceNumber} — ${_statusDescription(newStatus)}',
        referenceNumber: report.referenceNumber,
        status: newStatus,
        timestamp: DateTime.now(),
        isRead: false,
      ),
    );
    notifyListeners();
  }

  // ── Notifications ─────────────────────────────────────────────────────────
  late List<AppNotification> _notifications;

  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  int get unreadCount => _notifications.where((n) => !n.isRead).length;

  void markAllRead() {
    _notifications = _notifications
        .map((n) => n.copyWith(isRead: true))
        .toList();
    notifyListeners();
  }

  void markRead(String id) {
    final idx = _notifications.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    _notifications[idx] = _notifications[idx].copyWith(isRead: true);
    notifyListeners();
  }

  // ── Summary counts ────────────────────────────────────────────────────────
  int get pendingCount => _reports.where((r) => r.isPending).length;
  int get inProgressCount =>
      _reports.where((r) => r.status == 'In Progress').length;
  int get resolvedCount => _reports.where((r) => r.status == 'Resolved').length;
  int get totalCount => _reports.length;

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _statusDescription(String status) {
    switch (status) {
      case 'Pending Validation':
        return 'Your report is now waiting for validation.';
      case 'Assigned to Office':
        return 'Assigned to the appropriate government office.';
      case 'In Progress':
        return 'Work is currently in progress.';
      case 'Resolved':
        return 'The issue has been successfully resolved.';
      default:
        return 'Status updated.';
    }
  }

  /// Build a new IncidentReport from the report flow form data.
  static IncidentReport buildFromFormData(Map<String, dynamic> data) {
    final refNumber =
        data['referenceNumber'] as String? ?? AppHelpers.generateRefNumber();
    final now = DateTime.now();

    // Support both new field names and legacy field names
    final issue = data['concern'] as String? ??
        data['issue'] as String? ?? 'Others';
    final description = data['additionalDetails'] as String? ??
        data['description'] as String? ?? '';
    final barangay = data['barangay'] as String? ?? 'Unknown Barangay';
    final rawSeverity = data['severity'] as String? ?? 'Medium';
    final severity = AppHelpers.normaliseSeverity(rawSeverity);
    final lat = (data['latitude'] as num?)?.toDouble() ?? 6.7498;
    final lng = (data['longitude'] as num?)?.toDouble() ?? 125.3572;

    return IncidentReport(
      id: 'r-${now.millisecondsSinceEpoch}',
      referenceNumber: refNumber,
      category: data['category'] as String? ?? 'Infrastructure',
      issue: issue,
      description: description,
      barangay: barangay,
      status: 'Pending Validation',
      severity: severity,
      submittedAt: now,
      imageUrl: null,
      latitude: lat,
      longitude: lng,
      assignedOffice: null,
      activityLog: [
        ActivityEntry(
          title: 'Concern Submitted',
          description: 'Your concern has been successfully submitted.',
          timestamp: now,
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Your concern is now waiting for validation.',
          timestamp: now.add(const Duration(minutes: 1)),
          status: 'Pending Validation',
        ),
      ],
    );
  }
}
