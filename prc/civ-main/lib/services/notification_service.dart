import '../models/notification_model.dart';
import '../core/utils/dummy_data.dart';

class NotificationService {
  static List<AppNotification> getNotifications() => DummyData.notifications;

  static int getUnreadCount() =>
      DummyData.notifications.where((n) => !n.isRead).length;

  static Future<void> markAllRead() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  static Future<void> markRead(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}
