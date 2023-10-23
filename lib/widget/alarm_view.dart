import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../service/notifications.dart';

import 'alarm_item.dart';
import '../widget/alarm_control.dart';
import 'package:clocker2/widget/notifcation_screen.dart';

class AlarmView extends StatefulWidget {
  const AlarmView({super.key});

  @override
  State<AlarmView> createState() => _AlarmViewState();
}

class _AlarmViewState extends State<AlarmView> {
  final _myAlarms = Hive.box("myAlarms");
  late final NotificationService notificationService;

  @override
  void initState() async {
    Permission.audio.request();
    Permission.notification.request();
    notificationService = NotificationService();
    notificationService.initializa();
    final details = await notificationService.notificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      notificationService.onNotificationClick.add(details.payload);
    }
    notificationListiner();
    super.initState();
  }

  void notificationListiner() =>
      notificationService.onNotificationClick.stream.listen(notifcationEvent);

  void notifcationEvent(String? payload) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => NotificationScreen(
                payload: payload,
              )));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: ValueListenableBuilder(
        valueListenable: _myAlarms.listenable(),
        builder: (context, Box box, _) {
          return ListView.builder(
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                var alarm = box.getAt(index);
                return GestureDetector(
                  child: AlarmItem(box.keyAt(index), alarm),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        content: AlarmControl(true, index, alarm),
                        actionsAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    );
                  },
                );
              });
        },
      ),
    );
  }
}
