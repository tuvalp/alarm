import 'package:clocker2/alarm.dart';
import './notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AlarmsDatabase {
  final _myAlarms = Hive.box("myAlarms");
  late final NotificationService notificationService;

  void notifictionInit() {
    notificationService = NotificationService();
    notificationService.initializa();
  }

  void handleNotification(AlarmData alarm) {
    notifictionInit();

    var isActive = alarm.isActive;
    var hour = alarm.alarmDateTime.hour < 10
        ? "0${alarm.alarmDateTime.hour}"
        : alarm.alarmDateTime.hour;
    var min = alarm.alarmDateTime.minute < 10
        ? "0${alarm.alarmDateTime.minute}"
        : alarm.alarmDateTime.minute;
    var time = alarm.alarmDateTime.copyWith(second: 0);

    if (isActive == true) {
      notificationService.showNotification(
        id: alarm.id,
        title: ("${hour}:${min}").toString(),
        body: alarm.note,
        payload: alarm.id < 1 ? "No ID find" : alarm.id.toString(),
        time: time,
      );
    } else {
      notificationService.cancelNotification(alarm.id);
    }
  }

  void add(AlarmData alarm) async {
    _myAlarms.add(alarm);
    handleNotification(alarm);
    // NotifictionInit();
    // notificationService.showNotification(title: "add alarm");
  }

  void update(index, AlarmData alarm) {
    _myAlarms.put(index, alarm);

    handleNotification(alarm);
    // notificationService.showScheduleNotification(title: "add Update");
  }

  void delete(index) {
    _myAlarms.deleteAt(index);
  }
}
