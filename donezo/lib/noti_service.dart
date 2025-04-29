import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiService {
  static final NotiService _instance = NotiService._internal();
  factory NotiService() => _instance;
  NotiService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('lib/assets/images/dino.png');

      await _notificationsPlugin.initialize(
        const InitializationSettings(android: androidSettings),
        onDidReceiveNotificationResponse: (_) {},
      );

      await _configureLocalTimeZone();
      _isInitialized = true;
    } catch (e) {
      print('Notification service initialization failed: $e');
    }
  }

  Future<void> _configureLocalTimeZone() async {
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      tz.setLocalLocation(tz.local);
    }
  }

  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'reminder_channel_id',
        'Reminder Notifications',
        channelDescription: 'Channel for task reminder notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> scheduleTaskReminders({
    required String taskId,
    required String title,
    required String description,
    required DateTime dueDate,
  }) async {
    try {
      final tz.TZDateTime tzDueDate = tz.TZDateTime.from(dueDate, tz.local);
      final notifications = [
        _createNotification(
          id: '${taskId}_24h',
          title: '24h Reminder: $title',
          body: description,
          scheduledDate: tzDueDate.subtract(const Duration(hours: 24)),
        ),
      ];

      await Future.wait(notifications);
    } catch (e) {
      print('Error scheduling notifications: $e');
    }
  }

  Future<void> _createNotification({
    required String id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    final int notificationId = id.hashCode;

    if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
      print('Skipping past-due notification: $title');
      return;
    }

    await _notificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      scheduledDate,
      _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
