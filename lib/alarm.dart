import 'package:hive/hive.dart';

part 'alarm.g.dart';

@HiveType(typeId: 1)
class AlarmData {
  AlarmData(
      {required this.id,
      required this.alarmDateTime,
      required this.note,
      required this.isActive});

  @HiveField(0)
  int id;

  @HiveField(1)
  DateTime alarmDateTime;

  @HiveField(2)
  String note;

  @HiveField(3)
  bool isActive;
}
