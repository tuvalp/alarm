import 'dart:math';

import '../alarm.dart';
import '../service/database.dart';

import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AlarmControl extends StatefulWidget {
  final bool? updateMode;
  final int? index;
  final AlarmData? alarm;

  const AlarmControl([this.updateMode, this.index, this.alarm]);
  @override
  State<AlarmControl> createState() =>
      _AlarmControlState(updateMode, index, alarm);
}

class _AlarmControlState extends State<AlarmControl> {
  final bool? updateMode;
  final int? index;
  final AlarmData? alarm;

  _AlarmControlState([this.updateMode, this.index, this.alarm]);
  AlarmsDatabase db = AlarmsDatabase();

  TextEditingController noteController = TextEditingController();

  int id = 0;
  DateTime setDateTime = DateTime.now();
  String setNote = "";
  bool setIsActive = true;

  @override
  void initState() {
    super.initState();

    if (updateMode == true) {
      setState(() {
        id = alarm!.id;
        setDateTime = alarm!.alarmDateTime;
        setIsActive = alarm!.isActive;
        setNote = alarm!.note;
        noteController.text = alarm!.note;
      });
    } else {
      id = Random().nextInt(8888) + 1111;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 20),
          TimePickerSpinner(
            itemHeight: 60,
            spacing: 40,
            highlightedTextStyle: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 34,
              color: Colors.blue,
            ),
            time: setDateTime,
            is24HourMode: true,
            isForce2Digits: true,
            onTimeChange: (newtime) => setState(() {
              setDateTime = newtime;
            }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Active",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                ),
              ),
              Switch(
                  value: setIsActive,
                  onChanged: (value) {
                    setState(() {
                      setIsActive = value;
                    });
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                "Note",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w100,
                ),
              ),
              TextButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Add note'),
                    content: TextFormField(
                      onFieldSubmitted: ((value) {
                        setState(() {
                          setNote = noteController.text;
                        });
                        Navigator.pop(context);
                      }),
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: noteController.text,
                      ),
                      controller: noteController,
                    ),
                    actionsAlignment: MainAxisAlignment.spaceBetween,
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Icon(
                          Icons.close,
                          size: 24,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            setNote = noteController.text;
                          });
                          Navigator.pop(context, 'OK');
                        },
                        child: const Icon(
                          Icons.check,
                          size: 24,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Text(noteController.text == ""
                    ? "Add a note"
                    : noteController.text),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                icon: const Icon(
                  Icons.close,
                  size: 28,
                ),
              ),
              IconButton(
                onPressed: (() {
                  if (index == null) {
                    db.add(AlarmData(
                        id: id,
                        alarmDateTime: setDateTime,
                        note: setNote,
                        isActive: setIsActive));
                  } else {
                    db.update(
                        widget.index,
                        AlarmData(
                            id: id,
                            alarmDateTime: setDateTime,
                            note: setNote,
                            isActive: setIsActive));
                  }
                  Navigator.pop(context);
                }),
                icon: const Icon(
                  Icons.check,
                  size: 28,
                  color: Colors.blue,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
