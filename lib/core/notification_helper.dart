import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationHelper {
  NotificationHelper._();

  /// Requests notification permission from the user and returns the granted settings.
  static Future<NotificationSettings> requestPermission() async {
    final messaging = FirebaseMessaging.instance;

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: false,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
    );

    return settings;
  }

  /// Returns true when notification permission is authorized or provisional.
  static bool isPermissionGranted(NotificationSettings settings) {
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }
}
