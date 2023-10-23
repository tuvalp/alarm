import '../widget/alarm_control.dart';
import 'package:flutter/material.dart';

class AlarmAdd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
        child: const Icon(
          Icons.alarm_add_sharp,
          size: 34,
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => const AlertDialog(
              content: AlarmControl(),
              actionsAlignment: MainAxisAlignment.spaceBetween,
            ),
          );
        });
  }
}
