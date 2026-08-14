class IncidentReport {
  final String id;
  final String referenceNumber;
  final String category;
  final String issue;
  final String description;
  final String barangay;
  final String status;
  final String severity;
  final DateTime submittedAt;
  final DateTime? resolvedAt;
  final String? imageUrl;       // before photo (citizen submitted)
  final String? afterImageUrl;  // after photo (office uploaded on resolve)
  final double latitude;
  final double longitude;
  final String? assignedOffice;
  final List<ActivityEntry> activityLog;

  const IncidentReport({
    required this.id,
    required this.referenceNumber,
    required this.category,
    required this.issue,
    required this.description,
    required this.barangay,
    required this.status,
    required this.severity,
    required this.submittedAt,
    this.resolvedAt,
    this.imageUrl,
    this.afterImageUrl,
    required this.latitude,
    required this.longitude,
    this.assignedOffice,
    required this.activityLog,
  });

  /// All possible statuses in order
  static const List<String> statusOrder = [
    'Submitted',
    'Pending Validation',
    'Assigned to Office',
    'In Progress',
    'Resolved',
  ];

  int get statusIndex => statusOrder.indexWhere(
        (s) => s.toLowerCase() == status.toLowerCase(),
      );

  bool get isPending =>
      status.toLowerCase() == 'pending validation' ||
      status.toLowerCase() == 'submitted';

  bool get isResolved => status.toLowerCase() == 'resolved';

  IncidentReport copyWith({
    String? status,
    String? assignedOffice,
    DateTime? resolvedAt,
    List<ActivityEntry>? activityLog,
    String? afterImageUrl,
  }) =>
      IncidentReport(
        id: id,
        referenceNumber: referenceNumber,
        category: category,
        issue: issue,
        description: description,
        barangay: barangay,
        status: status ?? this.status,
        severity: severity,
        submittedAt: submittedAt,
        resolvedAt: resolvedAt ?? this.resolvedAt,
        imageUrl: imageUrl,
        afterImageUrl: afterImageUrl ?? this.afterImageUrl,
        latitude: latitude,
        longitude: longitude,
        assignedOffice: assignedOffice ?? this.assignedOffice,
        activityLog: activityLog ?? this.activityLog,
      );
}

class ActivityEntry {
  final String title;
  final String description;
  final DateTime timestamp;
  final String status;

  const ActivityEntry({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.status,
  });
}
