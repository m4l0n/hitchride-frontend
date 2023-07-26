// Programmer's Name: Ang Ru Xian
// Program Name: local_notification.dart
// Description: This is a file that contains the LocalNotification class that is used to show local notifications when receiving a notification from Firebase Cloud Messaging.
// Last Modified: 22 July 2023

import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotification {
  // Singleton pattern implementation
  factory LocalNotification() {
    return _instance;
  }

  LocalNotification._internal();

  // Create a FlutterLocalNotificationsPlugin instance
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Create a singleton instance of LocalNotification
  static final LocalNotification _instance = LocalNotification._internal();

  // Create an AndroidNotificationChannel instance
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.max,
  );

  // Initialize the LocalNotification plugin
  static void init(Function onDidReceiveNotificationResponse) {
    _setupForegroundNotificationAction(onDidReceiveNotificationResponse);
  }

  // Show a local notification
  static void showNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = notification?.android;

    // If `onMessage` is triggered with a notification, construct our own
    // local notification to show to users using the created channel.
    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/launcher_icon',
            ),
          ),
          payload: json.encode(message.data));
    }
  }

  // Setup the foreground notification action
  static void _setupForegroundNotificationAction(
      Function onDidReceiveNotificationResponse) {
    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const android = AndroidInitializationSettings('@mipmap/launcher_icon');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: android,
      iOS: ios,
    );

    _flutterLocalNotificationsPlugin.initialize(settings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      onDidReceiveNotificationResponse(notificationResponse.payload);
    });
  }
}