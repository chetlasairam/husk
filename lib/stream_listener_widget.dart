import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huskkk/specificscreen.dart';

class StreamListenerWidget extends StatefulWidget {
  @override
  _StreamListenerWidgetState createState() => _StreamListenerWidgetState();
}

class _StreamListenerWidgetState extends State<StreamListenerWidget> {
  final _auth = FirebaseAuth.instance;
  bool newDataAdded = false;

  Stream<DocumentSnapshot<Map<String, dynamic>>> getIncomingCallStream() {
    return FirebaseFirestore.instance
        .collection('o2ocalls')
        .doc('aaa')
        .collection('incomingcall')
        .doc('call')
        .snapshots();
  }

  void navigateToSpecificScreen() {
    if (newDataAdded) {
      print("inside Nav");
      newDataAdded = false;
      Future.delayed(Duration.zero, () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SpecificScreen()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: getIncomingCallStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Data is still loading
          return Container();
        } else if (snapshot.hasError) {
          // Handle error
          return Container();
        } else {
          final data = snapshot.data?.data();
          if (data != null && data['newDataAdded'] == true && !newDataAdded) {
            newDataAdded = true;
            print("ccc");
            navigateToSpecificScreen();
            // Return an empty container or a placeholder widget if needed
            print("Nav sent");
            return Container();
          }
          // Return an empty container if no navigation is required
          return Container();
        }
      },
    );
  }
}
