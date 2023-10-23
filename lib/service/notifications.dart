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

    IOSInitializationSettings iOSInitializationSettings =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) => {},
    );

    InitializationSettings settings = InitializationSettings(
      android: androidSttings,
      iOS: iOSInitializationSettings,
    );

    const AndroidNotificationChannel androidChannel =
        AndroidNotificationChannel(
      "channel 1",
      "Alarms",
      importance: Importance.high,
    );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    tz.initializeTimeZones();
    await notificationsPlugin.initialize(
      settings,
      onSelectNotification: ((payload) async {
        onNotificationClick.add(payload);
      }),
    );

    final details = await notificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotificationClick.add(details.payload);
    }
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
      ),
      iOS: const IOSNotificationDetails(),
    );

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
