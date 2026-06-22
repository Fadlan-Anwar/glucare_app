import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import '../../main.dart';
import '../providers/notification_provider.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // Initialize timezone
    tz.initializeTimeZones();

    // Request permission first
    await _requestPermissions();

    // Android initialization
    // @mipmap/ic_launcher must match the name of the icon in android/app/src/main/res/mipmap/
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        // Handle notification tap here if needed
      },
    );

    // Schedule the daily reminder by default
    await scheduleDailyReminder();
  }

  Future<void> _requestPermissions() async {
    // Request notification permission on Android 13+
    var status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'glucare_channel_id',
      'GluCare Notifications',
      channelDescription: 'Notifications for daily tracking and analysis',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );

    // Save to provider
    try {
      globalProviderContainer.read(notificationProvider.notifier).addNotification(
        title: title,
        body: body,
      );
    } catch (e) {
      // Ignore if provider not ready
    }
  }

  Future<void> scheduleDailyReminder() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_reminder_id',
      'Daily Reminder',
      channelDescription: 'Reminds you to fill your daily targets',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF007AE1),
      ledColor: Color(0xFF007AE1),
      ledOnMs: 1000,
      ledOffMs: 500,
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigTextStyleInformation(
        'Jangan sampai targetmu bolong hari ini! Buka <b>GluCare</b> sekarang dan selesaikan target harianmu untuk menjaga kadar gula darah tetap stabil. 💪',
        htmlFormatBigText: true,
        contentTitle: '<b>Glucare Menunggumu!</b> 👋',
        htmlFormatContentTitle: true,
        summaryText: 'Pengingat Harian',
      ),
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // Jadwal jam 20:00 (8 Malam)
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 20, 0);
    
    if (scheduledDate.isBefore(now)) {
      // Jika sekarang sudah lewat jam 8 malam, jadwalkan untuk besok jam 8 malam
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 100, // ID khusus untuk reminder harian
      title: 'Glucare Menunggumu! 👋',
      body: 'Sepertinya kamu belum update progres hari ini. Yuk buka aplikasi dan catat target harianmu!',
      scheduledDate: scheduledDate,
      notificationDetails: platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _flutterLocalNotificationsPlugin.cancel(id: 100);
  }
}
