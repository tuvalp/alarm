import './service/notifications.dart';
import 'package:flutter/material.dart';
import './widget/notifcation_screen.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  late final NotificationService notificationService;

  @override
  void initState() {
    notificationService = NotificationService();
    notificationService.initializa();
    notificationListiner();
    super.initState();
  }

  void notificationListiner() =>
      notificationService.onNotificationClick.stream.listen(notifcationEvent);

  void notifcationEvent(String? payload) => Navigator.push(
      context, MaterialPageRoute(builder: (context) => NotificationScreen()));

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
          onPressed: () async {
            notificationService.showNotification(
                title: "title", payload: "payload");
          },
          child: Text("prass here")),
    );
  }
}
