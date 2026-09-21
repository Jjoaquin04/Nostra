abstract class NotificationLocalService {
  Future<void> init();
  Future<void> requestPermissions();
  Future<void> showInstantNotifications(int id, String title, String body);
  Future<void> scheduleReminder(int id, String title, String body);
  Future<void> cancelAllNotifications();
}
