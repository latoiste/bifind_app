import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  NotificationService._internal();

  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showOutOfRangeNotification(String name) async {
    return _notificationsPlugin.show(
      0,
      "Item Left Behind!",
      "$name is out of range",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "out_of_range_channel_id", 
          "Out Of Range Alert")
      ),
    );
  }
}
