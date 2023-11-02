import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class SpecificScreen extends StatelessWidget {
  SpecificScreen({super.key});
  static const route = '/specificScreen';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    // Use the data from message to build your screen.
    // You can access specific fields using message.notification.title and message.notification.body.
    return Scaffold(
      appBar: AppBar(
        title: Text('Specific Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('${message.notification!.title}'),
            Text('${message.notification!.body}'),
          ],
        ),
      ),
    );
  }
}
