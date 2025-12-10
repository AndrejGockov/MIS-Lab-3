import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../services/meal_service.dart';

class NotificationService{
  // ------ LOCAL NOTIFICATIONS ------
  static GlobalKey<NavigatorState>? navigatorKey;
  static void Function(String)? onNotificationTap;
  static final localNotifications = FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'daily_recipe_channel',
    'Daily Recipe Reminder',
    channelDescription: 'Daily reminder to check recipes',
    importance: Importance.max,
    priority: Priority.high,
  );

  static Future<void> initialize() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Icon & Settings
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await localNotifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (response) {
          print('Random meals id: ${response.payload}');

          if (response.payload != null && response.payload!.isNotEmpty) {
            navigatorKey!.currentState?.pushNamed(
              "/meal", arguments: response.payload!,
            );
          }
        }
    );

    // Request permissions
    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: false,
    );

    // Handle background messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification();
    });

    // Handle when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      showNotification();
    });

    await scheduleDailyNotification();
  }

  static Future<void> showNotification({String? payload}) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    return localNotifications.show(
      0,
      'Food App',
      'Check out today\'s random recipe!',
      platformChannelSpecifics,
      payload: payload,
    );
  }

  static Future<void> scheduleDailyNotification() async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    final location = tz.local;

    // Scheduled for 12:00 PM daily
    final scheduledTime = tz.TZDateTime(
      location,
      tz.TZDateTime.now(location).year,
      tz.TZDateTime.now(location).month,
      tz.TZDateTime.now(location).day,
      12,
      0,
    );

    // Cancel any existing notification with the same ID
    await localNotifications.cancel(1);

    await localNotifications.zonedSchedule(
      1,
      'Recipe Reminder',
      'Time to check today\'s random recipe!',
      scheduledTime,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: 'daily_reminder',
    );

    print('Daily notification scheduled for 12:00 PM daily in local timezone');
  }

  // ------ FIREBASE NOTIFICATIONS ------
  final firebaseNotification = FirebaseMessaging.instance;

  initFCM() async{
    await firebaseNotification.requestPermission();
    final fcmToken = await firebaseNotification.getToken();

    // asks for perms
    NotificationSettings settings = await firebaseNotification.requestPermission(
      alert: true,
      badge: true,
      sound: true,);

    messageHandlers();
  }

  void messageHandlers() {
    // When app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    });

    // When app is in background and user taps notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleNotificationTap(message);
    });

    initMessage();
  }

  Future<void> initMessage() async {
    // Check if app was opened from a terminated state via notification
    RemoteMessage? initialMessage =
    await firebaseNotification.getInitialMessage();

    if (initialMessage != null) {
      print('App launched from terminated state via notification');
      _handleNotificationTap(initialMessage);
    }
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    String mealId = await MealService.getRandomMeal();
    navigatorKey!.currentState?.pushNamed("/meal", arguments: mealId);
  }

  void handleScheduledNotification(Map<String, dynamic> data) {
    print('Received scheduled notification: $data');
  }
}