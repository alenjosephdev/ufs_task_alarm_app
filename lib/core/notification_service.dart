import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
  FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await _notifications.initialize(
      const InitializationSettings(android: android),
    );
  }

  static Future<void> showNotification(
      int id, String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Channel',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    const notificationDetails =
    NotificationDetails(android: androidDetails);

    await _notifications.show(id, title, body, notificationDetails);
  }
}