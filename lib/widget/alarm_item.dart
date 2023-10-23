import 'package:clocker2/service/database.dart';

import '../alarm.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmItem extends StatelessWidget {
  final int index;
  final AlarmData alarm;
  final AlarmsDatabase db = AlarmsDatabase();

  AlarmItem(this.index, this.alarm, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(bottom: 15, top: 15, right: 25, left: 25),
      decoration: const BoxDecoration(
          color: Color(0xFFFFFFFF),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(DateFormat('HH:mm').format(alarm.alarmDateTime),
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w600,
                  )),
              alarm.note != ""
                  ? Text(alarm.note,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w100,
                        color: Colors.grey,
                      ))
                  : Container(),
            ],
          ),
          Switch(
            value: alarm.isActive,
            onChanged: (value) {
              var isActive = !alarm.isActive;
              var updateAlarm = AlarmData(
                  id: alarm.id,
                  alarmDateTime: alarm.alarmDateTime,
                  note: alarm.note,
                  isActive: isActive);
              db.update(index, updateAlarm);
            },
          ),
        ],
      ),
    );
  }
}
