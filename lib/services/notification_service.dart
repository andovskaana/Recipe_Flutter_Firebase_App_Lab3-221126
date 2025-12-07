import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;


class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  /// The plugin used to display local notifications.
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    debugPrint('[NotificationService] init() starting');

    tzdata.initializeTimeZones();
    final String timeZoneName = await _localTimeZone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    debugPrint('[NotificationService] time zone: $timeZoneName');

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
    DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
    debugPrint('[NotificationService] plugin initialized');

    await _requestPermissions();
    debugPrint('[NotificationService] permissions requested');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('[NotificationService] onMessage: ${message.messageId}');
      _showFcmNotification(message);
    });
    FirebaseMessaging.onBackgroundMessage(
        NotificationService.firebaseMessagingBackgroundHandler);

    debugPrint('[NotificationService] FCM handlers registered');
  }

  /// Dali treba da se otvara random recipe pri klik? mislam ne
  void _onNotificationResponse(NotificationResponse response) {
    // TODO: Dodadi otvaranje do random recept iako mislam dovolno e da go potsetime userot sam da otvori.
  }


  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      final iosPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();
      await iosPlugin?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

    if (Platform.isAndroid) {
      final androidPlugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.requestNotificationsPermission();
    }
  }


  Future<void> _showFcmNotification(RemoteMessage message) async {
    final notification = message.notification;
    if (notification == null) return;

    const androidDetails = AndroidNotificationDetails(
      'fcm_channel',
      'FCM Notifications',
      channelDescription: 'Notifications from Firebase Cloud Messaging',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      details,
      payload: message.data.toString(),
    );
  }

  ///Sending a notifiation every 10 seconds the app is on , for quick testing (za proverka brza deka mi raboti, slobodno)
  void startDevSpamNotifications({int seconds = 10}) {
    debugPrint(
        '[NotificationService] startDevSpamNotifications every $seconds seconds');

    Timer.periodic(Duration(seconds: seconds), (timer) async {
      const androidDetails = AndroidNotificationDetails(
        'dev_spam_channel',
        'Dev Spam',
        channelDescription: 'Dev-only repeated test notifications',
        importance: Importance.high,
        priority: Priority.high,
      );
      const details = NotificationDetails(android: androidDetails);

      await flutterLocalNotificationsPlugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'Dev test ${timer.tick}',
        'This dev notification repeats every $seconds seconds.',
        details,
      );
    });
  }



  static Future<void> firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    final service = NotificationService();
    await service._showFcmNotification(message);
  }


  /// For testing: show a notification immediately (no scheduling) (isto za proverka ama bez schedule, ova prvo mi proraboti).
  Future<void> showInstantTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'instant_test_channel',
      'Instant Test',
      channelDescription: 'Immediate test notification',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);

    debugPrint('[NotificationService] showInstantTestNotification() called');

    await flutterLocalNotificationsPlugin.show(
      123,
      'Instant test notification',
      'If you see this, local notifications are working.',
      details,
      payload: 'instant_test',
    );
  }

  Future<String> _localTimeZone() async {
    try {
      return tz.local.name;
    } catch (_) {
      return 'UTC';
    }
  }
}