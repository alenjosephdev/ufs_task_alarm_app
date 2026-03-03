import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'core/notification_service.dart';
import 'features/alarm/data/models/alarm_model.dart';
import 'features/alarm/presentation/alarm_bloc/alarm_bloc.dart';
import 'features/alarm/presentation/alarm_bloc/alarm_event.dart';
import 'features/alarm/presentation/screens/alarm_screen.dart';
import 'features/weather/data/data_source/remote_data_source.dart';
import 'features/weather/data/repository/weather_repository.dart';
import 'features/weather/presentation/weather_bloc/weather_bloc.dart';

final FlutterLocalNotificationsPlugin notifications =
    FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point')
Future<void> alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();

  log("Alarm callback triggered in main");
  print("Alarm callback triggered in main");

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

Future<void> requestLocationPermission() async {
  LocationPermission permission;

  // Check current permission
  permission = await Geolocator.checkPermission();

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  if (permission == LocationPermission.deniedForever) {
    await Geolocator.openAppSettings();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestLocationPermission();

  await Hive.initFlutter();
  Hive.registerAdapter(AlarmModelAdapter());
  await Hive.openBox<AlarmModel>('alarms');

  await AndroidAlarmManager.initialize();
  tz.initializeTimeZones();

  await NotificationService.initialize();

  // Android 13+
  await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AlarmBloc()..add(LoadAlarms())),
        BlocProvider(
          create: (_) => WeatherBloc(
            weatherRepository: WeatherRepository(
              remoteDataSource: WeatherRemoteDataSource(),
            ),
          )..add(FetchWeather()),
        ),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: AlarmScreen(),
      ),
    );
  }
}
