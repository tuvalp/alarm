import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    tz.initializeTimeZones();
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await notificationsPlugin.initialize(
      initializationSettings,
      //onSelectNotification: notificationDetails(),
    );
  }

  // notificationDetails() {
  //   return const NotificationDetails(
  //     android: AndroidNotificationDetails(
  //       'channelId',
  //       'channelName',
  //       importance: Importance.max,
  //     ),
  //   );
  // }

  Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payLoad,
  }) async {
    print("notification --------------------------------------------------");
    notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
          android: AndroidNotificationDetails(
        "1",
        "alarms",
        importance: Importance.max,
        priority: Priority.max,
      )),
      payload: payLoad,
    );
  }

//   Future showScheduleNotification({
//     int id = 0,
//     String? title,
//     String? body,
//     DateTime? time,
//     String? payLoad,
//   }) async {
//     notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       tz.TZDateTime.from(time!, tz.local),
//       await notificationDetails(),
//       androidAllowWhileIdle: true,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//     );
//   }
}
