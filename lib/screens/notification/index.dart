import 'package:chokchey_finance/components/header.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Header(
      headerTexts: 'notification',
      bodys: Center(
        child: Container(
          child: Text('Notification'),
        ),
      ),
    );
  }
}
