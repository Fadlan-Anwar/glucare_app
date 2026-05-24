import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class MessagingService {
  MessagingService._();

  /// Setup foreground message handler for incoming messages when app is active
  static void setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('╔════════════════════════════════════════════════════════╗');
      debugPrint('║ 📬 FOREGROUND MESSAGE RECEIVED                        ║');
      debugPrint('╚════════════════════════════════════════════════════════╝');
      
      // Extract notification and data from message
      final notification = message.notification;
      final data = message.data;

      debugPrint('Title: ${notification?.title}');
      debugPrint('Body: ${notification?.body}');
      debugPrint('Data: $data');
      
      // Handle message payload
      _handleMessagePayload(notification, data);
    });
  }

  /// Handle message payload
  static void _handleMessagePayload(
    RemoteNotification? notification,
    Map<String, dynamic> data,
  ) {
    // Extract notification details
    final title = notification?.title ?? 'Notification';
    final body = notification?.body ?? '';

    // Extract custom data if any
    final messageType = data['type'] ?? 'default';
    final userId = data['user_id'];
    final actionUrl = data['action_url'];

    debugPrint('Message Type: $messageType');
    debugPrint('User ID: $userId');
    debugPrint('Action URL: $actionUrl');

    // You can add custom handling here based on message type
    // Examples:
    // - Show local notification
    // - Update UI state
    // - Navigate to specific screen
    // - Show dialog/snackbar
  }

  /// Called when app is terminated and user taps on notification
  static Future<void> handleBackgroundMessage(RemoteMessage message) async {
    debugPrint('╔════════════════════════════════════════════════════════╗');
    debugPrint('║ 📬 BACKGROUND MESSAGE RECEIVED                        ║');
    debugPrint('╚════════════════════════════════════════════════════════╝');
    
    final notification = message.notification;
    final data = message.data;

    debugPrint('Title: ${notification?.title}');
    debugPrint('Body: ${notification?.body}');
    debugPrint('Data: $data');
  }
}
