import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

bool _isInitializated = false;
bool get inInitializated => _isInitializated;

Future<void> initNotifications() async {
  if (_isInitializated) return;

  const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('app_icon');

  const DarwinInitializationSettings initializationSettingsIos =
      DarwinInitializationSettings();

  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: initializationSettingsIos,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> mostrarNotificacion() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('channelId', 'channelName');
  const DarwinNotificationDetails darwinNotificationDetails =
      DarwinNotificationDetails();

  const NotificationDetails notificationDetails = NotificationDetails(
    android: androidNotificationDetails,
    iOS: darwinNotificationDetails,
  );
  await flutterLocalNotificationsPlugin.show(
    1,
    'Título de notificación',
    'Bajo stock',
    notificationDetails,
  );
}
