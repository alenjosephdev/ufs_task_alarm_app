import 'dart:developer';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  log("Alarm callback triggered");
  print("Alarm callback triggered");

  final notifications = FlutterLocalNotificationsPlugin();

  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  await notifications.initialize(
    const InitializationSettings(android: androidSettings),
  );

  await notifications.show(
    0,
    "Alarm",
    "Wake up!",
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'alarm_channel',
        'Alarm Channel',
        channelDescription: 'Alarm notifications',
        importance: Importance.max,
        priority: Priority.high,
        fullScreenIntent: true,
        // 🔥 THIS IS KEY
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        playSound: true,
      ),
    ),
  );
}
