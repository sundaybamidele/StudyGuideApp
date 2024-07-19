import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('app_icon');
  const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> scheduleNotification(int id, String title, String body, int minutes) async {
  try {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'your_channel_id',
          'Your Channel Name',
          channelDescription: 'Your channel description',
          importance: Importance.max,
          priority: Priority.high,
          // Ensure your settings are compatible with the notification's purpose
        ),
      ),
      // Use appropriate scheduling options
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
    // ignore: avoid_print
    print('Notification scheduled successfully.');
  } catch (e) {
    // ignore: avoid_print
    print('Error scheduling notification: $e');
  }
}
