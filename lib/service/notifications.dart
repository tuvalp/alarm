import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final onNotificationClick = BehaviorSubject<String?>();

  MethodChannel platform = const MethodChannel('com.dexterous/alarm_clock');

  Future<void> initializa() async {
    AndroidInitializationSettings androidSttings =
        const AndroidInitializationSettings("@drawable/alarm_icon");

    InitializationSettings settings = InitializationSettings(
      android: androidSttings,
    );

    tz.initializeTimeZones();
    await notificationsPlugin.initialize(
      settings,
      onSelectNotification: ((payload) async {
        print("cosamo");
        onNotificationClick.add(payload);
      }),
    );
  }

  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    DateTime? time,
  }) async {
    final String? alarmUri = await platform.invokeMethod<String>('getAlarmUri');
    final UriAndroidNotificationSound uriSound =
        UriAndroidNotificationSound(alarmUri!);

    tz.TZDateTime scheduledDate = tz.TZDateTime.from(time!, tz.local);

    NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
      "channel 1",
      "Alarms",
      importance: Importance.max,
      priority: Priority.max,
      sound: uriSound,
      audioAttributesUsage: AudioAttributesUsage.alarm,
      fullScreenIntent: true,
      autoCancel: false,
      playSound: true,
      //channelAction: new AndroidNotificationChannelAction
    ));

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: payload,
    );
  }

  void cancelNotification(int id) {
    notificationsPlugin.cancel(id);
  }
}
