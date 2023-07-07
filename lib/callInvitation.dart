import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CallInvite extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Simulate adding a call ID to Firebase (replace with actual Firebase code)
            // When a new call ID is added, Firebase will trigger a push notification to the device
            // containing the necessary data (friendNum) to open the call invitation page.
            String friendNum = "John";
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallInvitationPage(friendNum: friendNum),
              ),
            );
          },
          child: Text('Add Call ID'),
        ),
      ),
    );
  }
}

class CallInvitationPage extends StatelessWidget {
  final String friendNum;

  const CallInvitationPage({required this.friendNum});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Invitation'),
      ),
      body: Center(
        child: Text('You have a call invitation from friend $friendNum.'),
      ),
    );
  }
}
