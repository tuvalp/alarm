import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String? payload;

  NotificationScreen({this.payload});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.alarm,
                size: 120,
                color: Colors.blue,
              ),
              Text(payload!),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Stop"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
