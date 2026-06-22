import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_notification.dart';

class NotificationNotifier extends Notifier<List<AppNotification>> {
  static const String _storageKey = 'user_notifications';

  @override
  List<AppNotification> build() {
    _loadNotifications();
    return [];
  }

  Future<void> _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notificationsJson = prefs.getString(_storageKey);
    if (notificationsJson != null) {
      try {
        final List<dynamic> decoded = json.decode(notificationsJson);
        final List<AppNotification> loaded = decoded
            .map((item) => AppNotification.fromMap(item as Map<String, dynamic>))
            .toList();
        
        // Sort by timestamp descending
        loaded.sort((a, b) => b.timestamp.compareTo(a.timestamp));
        state = loaded;
      } catch (e) {
        state = [];
      }
    }
  }

  Future<void> _saveNotifications(List<AppNotification> notifications) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> mappedList = notifications.map((n) => n.toMap()).toList();
    await prefs.setString(_storageKey, json.encode(mappedList));
  }

  void addNotification({required String title, required String body}) {
    final newNotification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
      isRead: false,
    );
    
    final newState = [newNotification, ...state];
    state = newState;
    _saveNotifications(newState);
  }

  void markAsRead(String id) {
    final newState = state.map((n) {
      if (n.id == id) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    
    state = newState;
    _saveNotifications(newState);
  }

  void markAllAsRead() {
    final newState = state.map((n) => n.copyWith(isRead: true)).toList();
    state = newState;
    _saveNotifications(newState);
  }

  void deleteNotification(String id) {
    final newState = state.where((n) => n.id != id).toList();
    state = newState;
    _saveNotifications(newState);
  }
  
  void clearAll() {
    state = [];
    _saveNotifications([]);
  }
}

final notificationProvider = NotifierProvider<NotificationNotifier, List<AppNotification>>(() {
  return NotificationNotifier();
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationProvider);
  return notifications.where((n) => !n.isRead).length;
});

class DailyReminderNotifier extends Notifier<bool> {
  @override
  bool build() {
    _init();
    return false;
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('is_daily_reminder_on') ?? false;
  }

  Future<void> toggle(bool value) async {
    state = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_daily_reminder_on', value);
  }
}

final dailyReminderProvider = NotifierProvider<DailyReminderNotifier, bool>(() {
  return DailyReminderNotifier();
});
