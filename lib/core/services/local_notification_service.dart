import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

final localNotificationServiceProvider = Provider<LocalNotificationService>((ref) {
  return LocalNotificationService();
});

/// Device notifications for reminders and cloud alerts (FCM-ready channels).
class LocalNotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;
  int _id = 0;

  Future<void> initialize() async {
    if (_initialized) return;
    if (const bool.fromEnvironment('FLUTTER_TEST')) {
      _initialized = true;
      return;
    }

    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      const linux = LinuxInitializationSettings(defaultActionName: 'Open CLIVORA');
      await _plugin.initialize(
        const InitializationSettings(android: android, iOS: ios, linux: linux),
        onDidReceiveNotificationResponse: (_) {},
      );

      const channel = AndroidNotificationChannel(
        'clivora_alerts',
        'CLIVORA Alerts',
        description: 'Invoices, tasks, messages, and updates',
        importance: Importance.defaultImportance,
      );

      await _plugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    } catch (e) {
      debugPrint('Local notifications unavailable: $e');
    }

    _initialized = true;
  }

  Future<void> show({
    required String title,
    required String body,
    String? payload,
  }) async {
    if (!_initialized) await initialize();
    _id++;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'clivora_alerts',
        'CLIVORA Alerts',
        channelDescription: 'Invoices, tasks, messages, and updates',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );
    try {
      await _plugin.show(_id, title, body, details, payload: payload);
    } catch (e) {
      debugPrint('Local notification failed: $e');
    }
  }

  Future<void> scheduleAt({
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime when,
    String? payload,
  }) async {
    if (!_initialized) await initialize();
    if (when.isBefore(tz.TZDateTime.now(tz.local))) return;
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'clivora_alerts',
        'CLIVORA Alerts',
        channelDescription: 'Invoices, tasks, messages, and updates',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
    );
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    } catch (e) {
      debugPrint('Scheduled notification failed, showing now: $e');
      await show(title: title, body: body, payload: payload);
    }
  }

  Future<void> cancel(int id) async {
    if (!_initialized) await initialize();
    try {
      await _plugin.cancel(id);
    } catch (e) {
      debugPrint('Cancel notification failed: $e');
    }
  }
}
