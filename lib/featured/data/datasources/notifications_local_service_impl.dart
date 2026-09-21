import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:nostra/featured/data/datasources/notification_local_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsLocalServiceImpl extends NotificationLocalService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final TimezoneInfo currentTimeZone =
          await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(currentTimeZone.identifier));
    } catch (e) {
      tz.setLocalLocation(tz.getLocation('Europe/Madrid'));
    }
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/track_expenses_icon',
    );
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);
    await notificationsPlugin.initialize(settings: initializationSettings);
  }

  @override
  Future<void> scheduleReminder(int id, String title, String body) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      28, // Día 28 de cada mes
      10, // A las 10:00 AM
      0,
    );
    // Si el día 28 de este mes ya pasó
    if (scheduledDate.isBefore(now)) {
      scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month + 1,
        28,
        10,
        0,
      );
    }
    await notificationsPlugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'monthly_reminder_channel',
          'Recordatorios Mensuales',
          channelDescription: 'Canal para recordatorios a fin de mes',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
    );
  }

  @override
  Future<void> showInstantNotifications(
    int id,
    String title,
    String body,
  ) async {
    await notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          channelDescription: 'Instant notification channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  @override
  Future<void> requestPermissions() async {
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  @override
  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
  }
}
