class AppUser {
  final String id;
  final String fullName;
  final String phoneNumber;
  final String barangay;
  final DateTime joinedDate;
  final int totalReports;
  final int resolvedReports;
  final String? avatarUrl;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.phoneNumber,
    required this.barangay,
    required this.joinedDate,
    required this.totalReports,
    required this.resolvedReports,
    this.avatarUrl,
  });

  String get firstName => fullName.split(' ').first;

  String get initials {
    final parts = fullName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  int get pendingReports => totalReports - resolvedReports;
}
