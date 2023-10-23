import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String? payload;

  NotificationScreen({this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      bottomSheet: null,
      body: Center(
          child: Column(
        children: [
          const Icon(
            Icons.alarm,
            size: 120,
            color: Colors.blue,
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Stop"),
          ),
        ],
      )),
    );
  }
}
