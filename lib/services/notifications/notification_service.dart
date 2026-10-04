import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_show_app/services/firebase/firestore_service.dart';
import 'package:game_show_app/core/infrastructure/permission_handler.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  final FirestoreService _firestoreService = FirestoreService();
  final PermissionHandler _permissionHandler = PermissionHandler();

  static const String _channelId = 'game_channel';
  static const String _channelName = 'Game Notifications';
  static const String _channelDesc = 'Notifications for game events';

  static const List<String> _defaultTopics = [
    'game_invites',
    'friend_requests',
    'daily_challenge',
  ];

  Future<void> initialize({String? userId}) async {
    // 1. Request Runtime Permission (Critical for Android 13+)
    await _permissionHandler.requestNotificationPermission();

    // 2. Request FCM Permission
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    final token = await _fcm.getToken();
    // ignore: avoid_print
    print('FCM Token: $token');

    // Wire up FCM token to user's Firestore document
    if (userId != null && token != null) {
      await _firestoreService.updateUser(userId, {'fcmToken': token});
    }

    // Listen for token refresh and update Firestore
    _fcm.onTokenRefresh.listen((newToken) async {
      if (userId != null) {
        await _firestoreService.updateUser(userId, {'fcmToken': newToken});
      }
    });

    // Subscribe to default topics
    for (final topic in _defaultTopics) {
      await _fcm.subscribeToTopic(topic);
    }

    FirebaseMessaging.onMessage.listen(_handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpened);
  }

  void _onNotificationTap(NotificationResponse response) {
    // TODO: Handle notification tap - navigate to relevant screen
  }

  void _handleMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      showLocalNotification(
        title: notification.title ?? '',
        body: notification.body ?? '',
      );
    }
  }

  void _handleMessageOpened(RemoteMessage message) {
    // TODO: Handle navigation when notification is tapped
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDesc,
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      title.hashCode,
      title,
      body,
      details,
      payload: payload,
    );
  }

  Future<void> scheduleDailyNotification({
    required TimeOfDay time,
    required String title,
    required String body,
  }) async {
    // TODO: Implement daily scheduling using platform-specific alarm APIs
    // For Android: use android_alarm_manager or workmanager
    // For iOS: use BGTaskScheduler
    await showLocalNotification(title: title, body: body);
  }

  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  Future<String?> getToken() => _fcm.getToken();

  Future<void> subscribeToTopic(String topic) =>
      _fcm.subscribeToTopic(topic);

  Future<void> unsubscribeFromTopic(String topic) =>
      _fcm.unsubscribeFromTopic(topic);
}
