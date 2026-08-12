class AppNotification {
  final String id;
  final String title;
  final String message;
  final String referenceNumber;
  final String status;
  final DateTime timestamp;
  final bool isRead;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.referenceNumber,
    required this.status,
    required this.timestamp,
    required this.isRead,
  });

  AppNotification copyWith({bool? isRead}) => AppNotification(
        id: id,
        title: title,
        message: message,
        referenceNumber: referenceNumber,
        status: status,
        timestamp: timestamp,
        isRead: isRead ?? this.isRead,
      );
}
