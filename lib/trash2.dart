import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  String name, email, phone;
  WelcomePage(
      {Key? key, required this.name, required this.email, required this.phone})
      : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${widget.name}'),
              Text('Email: ${widget.email}'),
              Text('Phone: ${widget.phone}'),
            ],
          ),
        ),
      ),
    );
  }
}
