import 'package:flutter/material.dart';

class SpecificScreen extends StatelessWidget {
  SpecificScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the data from documentData to build your screen.
    // You can access specific fields using documentData['fieldName'].
    return Scaffold(
      appBar: AppBar(
        title: Text('Specific Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Data received:'),
          ],
        ),
      ),
    );
  }
}
