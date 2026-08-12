import '../../models/report.dart';
import '../../models/notification_model.dart';
import '../../models/user.dart';
import '../../models/office.dart';

class DummyData {
  DummyData._();

  // ── Current User ──────────────────────────────────────────────────────────
  static final AppUser currentUser = AppUser(
    id: 'u-001',
    fullName: 'Lawrence Santos',
    phoneNumber: '+63 912 345 6789',
    barangay: 'Aplaya',
    joinedDate: DateTime(2026, 1, 15),
    totalReports: 8,
    resolvedReports: 5,
  );

  // ── Government Offices ────────────────────────────────────────────────────
  static final List<GovernmentOffice> offices = [
    GovernmentOffice(
      id: 'o-001',
      name: 'City Engineering Office',
      abbreviation: 'CEO',
      handles: ['Infrastructure'],
      contactNumber: '+63 82 553 0001',
    ),
    GovernmentOffice(
      id: 'o-002',
      name: 'City Environment and Natural Resources Office',
      abbreviation: 'CENRO',
      handles: ['Environment'],
      contactNumber: '+63 82 553 0002',
    ),
    GovernmentOffice(
      id: 'o-003',
      name: 'City Public Works Department',
      abbreviation: 'CPWD',
      handles: ['Infrastructure', 'Environment'],
      contactNumber: '+63 82 553 0003',
    ),
    GovernmentOffice(
      id: 'o-004',
      name: 'Digos City Disaster Risk Reduction Office',
      abbreviation: 'CDRRMO',
      handles: ['Infrastructure', 'Environment'],
      contactNumber: '+63 82 553 0004',
    ),
  ];

  // ── Reports ───────────────────────────────────────────────────────────────
  static final List<IncidentReport> myReports = [
    IncidentReport(
      id: 'r-001',
      referenceNumber: 'CW-2026-00125',
      category: 'Infrastructure',
      issue: 'Broken Streetlight',
      description:
          'The streetlight near the covered court is not working during nighttime, making the area dark and unsafe for residents.',
      barangay: 'Aplaya',
      status: 'Pending Validation',
      severity: 'Moderate',
      submittedAt: DateTime(2026, 7, 17, 10, 32),
      imageUrl: null,
      latitude: 6.7498,
      longitude: 125.3572,
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Your report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 17, 10, 32),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Your report is now waiting for validation.',
          timestamp: DateTime(2026, 7, 17, 10, 33),
          status: 'Pending Validation',
        ),
      ],
    ),
    IncidentReport(
      id: 'r-002',
      referenceNumber: 'CW-2026-00118',
      category: 'Environment',
      issue: 'Blocked Drainage',
      description:
          'The drainage along the main road is completely blocked with debris, causing flooding during heavy rain.',
      barangay: 'San Miguel',
      status: 'In Progress',
      severity: 'Severe',
      submittedAt: DateTime(2026, 7, 16, 16, 15),
      imageUrl: null,
      latitude: 6.7510,
      longitude: 125.3590,
      assignedOffice: 'City Engineering Office',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Your report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 16, 16, 15),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Your report is now waiting for validation.',
          timestamp: DateTime(2026, 7, 16, 16, 20),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to City Engineering Office.',
          timestamp: DateTime(2026, 7, 16, 18, 00),
          status: 'Assigned to Office',
        ),
        ActivityEntry(
          title: 'In Progress',
          description: 'Work is currently in progress.',
          timestamp: DateTime(2026, 7, 17, 8, 30),
          status: 'In Progress',
        ),
      ],
    ),
    IncidentReport(
      id: 'r-003',
      referenceNumber: 'CW-2026-00098',
      category: 'Environment',
      issue: 'Illegal Dumping',
      description:
          'Large pile of household and construction waste illegally dumped near the river bank.',
      barangay: 'Tres de Mayo',
      status: 'Resolved',
      severity: 'Severe',
      submittedAt: DateTime(2026, 7, 10, 9, 21),
      resolvedAt: DateTime(2026, 7, 14, 14, 0),
      imageUrl: null,
      latitude: 6.7465,
      longitude: 125.3545,
      assignedOffice: 'City Environment and Natural Resources Office',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Your report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 10, 9, 21),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Waiting for review.',
          timestamp: DateTime(2026, 7, 10, 9, 30),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to CENRO.',
          timestamp: DateTime(2026, 7, 11, 9, 0),
          status: 'Assigned to Office',
        ),
        ActivityEntry(
          title: 'In Progress',
          description: 'Cleanup operation started.',
          timestamp: DateTime(2026, 7, 12, 8, 0),
          status: 'In Progress',
        ),
        ActivityEntry(
          title: 'Resolved',
          description: 'The illegal dumping site has been cleared.',
          timestamp: DateTime(2026, 7, 14, 14, 0),
          status: 'Resolved',
        ),
      ],
    ),
    IncidentReport(
      id: 'r-004',
      referenceNumber: 'CW-2026-00087',
      category: 'Infrastructure',
      issue: 'Damaged Sidewalk',
      description:
          'Sidewalk tiles are broken and displaced, posing a tripping hazard especially for elderly residents.',
      barangay: 'Matti',
      status: 'Resolved',
      severity: 'Moderate',
      submittedAt: DateTime(2026, 7, 8, 14, 40),
      resolvedAt: DateTime(2026, 7, 13, 10, 0),
      imageUrl: null,
      latitude: 6.7480,
      longitude: 125.3560,
      assignedOffice: 'City Public Works Department',
      activityLog: [],
    ),
    IncidentReport(
      id: 'r-005',
      referenceNumber: 'CW-2026-00080',
      category: 'Environment',
      issue: 'Overgrown Vegetation',
      description:
          'Tree branches are overgrown and blocking street signs and power lines along the road.',
      barangay: 'Badiang',
      status: 'Resolved',
      severity: 'Minor',
      submittedAt: DateTime(2026, 7, 7, 8, 5),
      resolvedAt: DateTime(2026, 7, 11, 16, 0),
      imageUrl: null,
      latitude: 6.7520,
      longitude: 125.3600,
      assignedOffice: 'City Environment and Natural Resources Office',
      activityLog: [],
    ),
  ];

  // ── Community Reports — full IncidentReport objects for validated pins ──────
  // IDs use 'cr-' prefix; AppState merges these with myReports for getById().
  static final List<IncidentReport> communityReports = [
    IncidentReport(
      id: 'cr-001',
      referenceNumber: 'CW-2026-00125',
      category: 'Infrastructure',
      issue: 'Broken Streetlight',
      description:
          'The streetlight is not working. It\'s been dark in this area for nights, making it unsafe for pedestrians.',
      barangay: 'San Miguel',
      status: 'Pending Validation',
      severity: 'Moderate',
      submittedAt: DateTime(2026, 7, 17, 10, 32),
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      latitude: 6.7498,
      longitude: 125.3572,
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 17, 10, 32),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Report is now waiting for validation.',
          timestamp: DateTime(2026, 7, 17, 10, 33),
          status: 'Pending Validation',
        ),
      ],
    ),
    IncidentReport(
      id: 'cr-002',
      referenceNumber: 'CW-2026-00080',
      category: 'Environment',
      issue: 'Overgrown Vegetation',
      description:
          'Tree branches are overgrown and blocking street signs and power lines along the road.',
      barangay: 'Badiang',
      status: 'Resolved',
      severity: 'Minor',
      submittedAt: DateTime(2026, 7, 7, 8, 5),
      resolvedAt: DateTime(2026, 7, 11, 16, 0),
      imageUrl:
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400',
      latitude: 6.7560,
      longitude: 125.3620,
      assignedOffice: 'City Environment and Natural Resources Office',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 7, 8, 5),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Waiting for review.',
          timestamp: DateTime(2026, 7, 7, 9, 0),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to CENRO.',
          timestamp: DateTime(2026, 7, 8, 8, 0),
          status: 'Assigned to Office',
        ),
        ActivityEntry(
          title: 'In Progress',
          description: 'Tree trimming operation started.',
          timestamp: DateTime(2026, 7, 10, 7, 0),
          status: 'In Progress',
        ),
        ActivityEntry(
          title: 'Resolved',
          description: 'Overgrown vegetation has been cleared.',
          timestamp: DateTime(2026, 7, 11, 16, 0),
          status: 'Resolved',
        ),
      ],
    ),
    IncidentReport(
      id: 'cr-003',
      referenceNumber: 'CW-2026-00112',
      category: 'Infrastructure',
      issue: 'Damaged Road',
      description:
          'Large potholes along the main road causing traffic slowdowns and vehicle damage.',
      barangay: 'Aplaya',
      status: 'In Progress',
      severity: 'Severe',
      submittedAt: DateTime(2026, 7, 14, 9, 0),
      imageUrl:
          'https://images.unsplash.com/photo-1615729947596-a598e5de0ab3?w=400',
      latitude: 6.7510,
      longitude: 125.3590,
      assignedOffice: 'City Public Works Department',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 14, 9, 0),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Waiting for review.',
          timestamp: DateTime(2026, 7, 14, 9, 15),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to City Public Works Department.',
          timestamp: DateTime(2026, 7, 15, 8, 0),
          status: 'Assigned to Office',
        ),
        ActivityEntry(
          title: 'In Progress',
          description: 'Road repair crew has been dispatched.',
          timestamp: DateTime(2026, 7, 16, 7, 30),
          status: 'In Progress',
        ),
      ],
    ),
    IncidentReport(
      id: 'cr-004',
      referenceNumber: 'CW-2026-00098',
      category: 'Environment',
      issue: 'Illegal Dumping',
      description:
          'Large pile of household and construction waste illegally dumped near the river bank.',
      barangay: 'Tres de Mayo',
      status: 'Assigned to Office',
      severity: 'Severe',
      submittedAt: DateTime(2026, 7, 10, 9, 21),
      imageUrl:
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400',
      latitude: 6.7465,
      longitude: 125.3545,
      assignedOffice: 'City Environment and Natural Resources Office',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 10, 9, 21),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Waiting for review.',
          timestamp: DateTime(2026, 7, 10, 9, 30),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to CENRO for cleanup.',
          timestamp: DateTime(2026, 7, 11, 9, 0),
          status: 'Assigned to Office',
        ),
      ],
    ),
    IncidentReport(
      id: 'cr-005',
      referenceNumber: 'CW-2026-00118',
      category: 'Infrastructure',
      issue: 'Blocked Drainage',
      description:
          'Drainage is clogged with debris, causing flooding along the road during heavy rain.',
      barangay: 'Matti',
      status: 'In Progress',
      severity: 'Severe',
      submittedAt: DateTime(2026, 7, 16, 16, 15),
      imageUrl:
          'https://images.unsplash.com/photo-1504701954957-2010ec3bcec1?w=400',
      latitude: 6.7480,
      longitude: 125.3560,
      assignedOffice: 'City Engineering Office',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 16, 16, 15),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Waiting for review.',
          timestamp: DateTime(2026, 7, 16, 16, 20),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to City Engineering Office.',
          timestamp: DateTime(2026, 7, 16, 18, 0),
          status: 'Assigned to Office',
        ),
        ActivityEntry(
          title: 'In Progress',
          description: 'Drainage clearing operation is underway.',
          timestamp: DateTime(2026, 7, 17, 8, 30),
          status: 'In Progress',
        ),
      ],
    ),
    IncidentReport(
      id: 'cr-006',
      referenceNumber: 'CW-2026-00072',
      category: 'Others',
      issue: 'Stray Animals',
      description:
          'Multiple stray dogs spotted near the public market, posing a risk to pedestrians.',
      barangay: 'New Visayas',
      status: 'Resolved',
      severity: 'Minor',
      submittedAt: DateTime(2026, 7, 5, 11, 0),
      resolvedAt: DateTime(2026, 7, 8, 14, 0),
      imageUrl: null,
      latitude: 6.7440,
      longitude: 125.3530,
      assignedOffice: 'City Veterinary Office',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 5, 11, 0),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Waiting for review.',
          timestamp: DateTime(2026, 7, 5, 11, 10),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to City Veterinary Office.',
          timestamp: DateTime(2026, 7, 6, 8, 0),
          status: 'Assigned to Office',
        ),
        ActivityEntry(
          title: 'In Progress',
          description: 'Animal control team dispatched.',
          timestamp: DateTime(2026, 7, 7, 9, 0),
          status: 'In Progress',
        ),
        ActivityEntry(
          title: 'Resolved',
          description: 'Stray animals have been collected and relocated.',
          timestamp: DateTime(2026, 7, 8, 14, 0),
          status: 'Resolved',
        ),
      ],
    ),
    IncidentReport(
      id: 'cr-007',
      referenceNumber: 'CW-2026-00087',
      category: 'Infrastructure',
      issue: 'Road Sign Damage',
      description:
          'Traffic signage is damaged and unreadable, causing confusion for motorists.',
      barangay: 'Rizal',
      status: 'Assigned to Office',
      severity: 'Moderate',
      submittedAt: DateTime(2026, 7, 8, 14, 40),
      imageUrl: null,
      latitude: 6.7505,
      longitude: 125.3610,
      assignedOffice: 'City Engineering Office',
      activityLog: [
        ActivityEntry(
          title: 'Report Submitted',
          description: 'Report has been successfully submitted.',
          timestamp: DateTime(2026, 7, 8, 14, 40),
          status: 'Submitted',
        ),
        ActivityEntry(
          title: 'Pending Validation',
          description: 'Waiting for review.',
          timestamp: DateTime(2026, 7, 8, 14, 50),
          status: 'Pending Validation',
        ),
        ActivityEntry(
          title: 'Assigned to Office',
          description: 'Assigned to City Engineering Office.',
          timestamp: DateTime(2026, 7, 9, 8, 0),
          status: 'Assigned to Office',
        ),
      ],
    ),
  ];

  // ── Community Map Pins ────────────────────────────────────────────────────
  static final List<MapPin> communityPins = [
    MapPin(
      id: 'p-001',
      reportId: 'cr-001',
      category: 'Infrastructure',
      issue: 'Broken Streetlight',
      description:
          'The streetlight is not working.\nIt\'s been dark in this area for nights.',
      barangay: 'Barangay San Miguel, Digos City',
      status: 'Pending Validation',
      referenceNumber: 'CW-2026-00125',
      lat: 6.7498,
      lng: 125.3572,
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    ),
    MapPin(
      id: 'p-002',
      reportId: 'cr-002',
      category: 'Environment',
      issue: 'Overgrown Vegetation',
      description: 'Tree branches are overgrown and blocking street signs.',
      barangay: 'Barangay Badiang, Digos City',
      status: 'Resolved',
      referenceNumber: 'CW-2026-00080',
      lat: 6.7560,
      lng: 125.3620,
      imageUrl:
          'https://images.unsplash.com/photo-1542601906990-b4d3fb778b09?w=400',
    ),
    MapPin(
      id: 'p-003',
      reportId: 'cr-003',
      category: 'Infrastructure',
      issue: 'Damaged Road',
      description: 'Large potholes along the main road causing traffic.',
      barangay: 'Barangay Aplaya, Digos City',
      status: 'In Progress',
      referenceNumber: 'CW-2026-00112',
      lat: 6.7510,
      lng: 125.3590,
      imageUrl:
          'https://images.unsplash.com/photo-1615729947596-a598e5de0ab3?w=400',
    ),
    MapPin(
      id: 'p-004',
      reportId: 'cr-004',
      category: 'Environment',
      issue: 'Illegal Dumping',
      description: 'Large pile of waste dumped near the river bank.',
      barangay: 'Barangay Tres de Mayo, Digos City',
      status: 'Assigned to Office',
      referenceNumber: 'CW-2026-00098',
      lat: 6.7465,
      lng: 125.3545,
      imageUrl:
          'https://images.unsplash.com/photo-1532996122724-e3c354a0b15b?w=400',
    ),
    MapPin(
      id: 'p-005',
      reportId: 'cr-005',
      category: 'Infrastructure',
      issue: 'Blocked Drainage',
      description: 'Drainage is clogged with debris causing flooding.',
      barangay: 'Barangay Matti, Digos City',
      status: 'In Progress',
      referenceNumber: 'CW-2026-00118',
      lat: 6.7480,
      lng: 125.3560,
      imageUrl:
          'https://images.unsplash.com/photo-1504701954957-2010ec3bcec1?w=400',
    ),
    MapPin(
      id: 'p-006',
      reportId: 'cr-006',
      category: 'Others',
      issue: 'Stray Animals',
      description: 'Multiple stray dogs spotted near the public market.',
      barangay: 'Barangay New Visayas, Digos City',
      status: 'Resolved',
      referenceNumber: 'CW-2026-00072',
      lat: 6.7440,
      lng: 125.3530,
      imageUrl: null,
    ),
    MapPin(
      id: 'p-007',
      reportId: 'cr-007',
      category: 'Infrastructure',
      issue: 'Road Sign Damage',
      description: 'Traffic signage is damaged and unreadable.',
      barangay: 'Barangay Rizal, Digos City',
      status: 'Assigned to Office',
      referenceNumber: 'CW-2026-00087',
      lat: 6.7505,
      lng: 125.3610,
      imageUrl: null,
    ),
  ];

  // ── Notifications ─────────────────────────────────────────────────────────
  static final List<AppNotification> notifications = [
    AppNotification(
      id: 'n-001',
      title: 'Report Submitted',
      message: 'Your report CW-2026-00125 has been submitted successfully.',
      referenceNumber: 'CW-2026-00125',
      status: 'Submitted',
      timestamp: DateTime(2026, 7, 17, 10, 32),
      isRead: false,
    ),
    AppNotification(
      id: 'n-002',
      title: 'Pending Validation',
      message: 'CW-2026-00125 is now under review by the Super Administrator.',
      referenceNumber: 'CW-2026-00125',
      status: 'Pending Validation',
      timestamp: DateTime(2026, 7, 17, 10, 33),
      isRead: false,
    ),
    AppNotification(
      id: 'n-003',
      title: 'In Progress',
      message:
          'CW-2026-00118 — Work is now in progress by the City Engineering Office.',
      referenceNumber: 'CW-2026-00118',
      status: 'In Progress',
      timestamp: DateTime(2026, 7, 17, 8, 30),
      isRead: true,
    ),
    AppNotification(
      id: 'n-004',
      title: 'Assigned to Office',
      message: 'CW-2026-00118 has been assigned to City Engineering Office.',
      referenceNumber: 'CW-2026-00118',
      status: 'Assigned to Office',
      timestamp: DateTime(2026, 7, 16, 18, 0),
      isRead: true,
    ),
    AppNotification(
      id: 'n-005',
      title: 'Resolved',
      message:
          'CW-2026-00098 — Illegal Dumping in Barangay Tres has been resolved.',
      referenceNumber: 'CW-2026-00098',
      status: 'Resolved',
      timestamp: DateTime(2026, 7, 14, 14, 0),
      isRead: true,
    ),
    AppNotification(
      id: 'n-006',
      title: 'Resolved',
      message:
          'CW-2026-00087 — Damaged Sidewalk in Barangay Matti has been resolved.',
      referenceNumber: 'CW-2026-00087',
      status: 'Resolved',
      timestamp: DateTime(2026, 7, 13, 10, 0),
      isRead: true,
    ),
  ];

  // ── Announcements ─────────────────────────────────────────────────────────
  static final List<Announcement> announcements = [
    Announcement(
      id: 'a-001',
      title: 'Keep Digos City Clean and Safe!',
      body: "Let's work together for a better community.",
      date: DateTime(2026, 7, 15),
    ),
    Announcement(
      id: 'a-002',
      title: 'Road Repair Schedule — Barangay San Miguel',
      body: 'Road repairs will be conducted from July 18–20, 2026.',
      date: DateTime(2026, 7, 13),
    ),
  ];
}

// ── Simple Map Pin ────────────────────────────────────────────────────────────
class MapPin {
  final String id;
  final String reportId; // links to IncidentReport.id in AppState
  final String category;
  final String issue;
  final String description;
  final String barangay;
  final String status;
  final String referenceNumber;
  final double lat;
  final double lng;
  final String? imageUrl;

  const MapPin({
    required this.id,
    required this.reportId,
    required this.category,
    required this.issue,
    required this.description,
    required this.barangay,
    required this.status,
    required this.referenceNumber,
    required this.lat,
    required this.lng,
    this.imageUrl,
  });
}

// ── Announcement ──────────────────────────────────────────────────────────────
class Announcement {
  final String id;
  final String title;
  final String body;
  final DateTime date;

  const Announcement({
    required this.id,
    required this.title,
    required this.body,
    required this.date,
  });
}
