import 'package:flutter/material.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  TextEditingController _controller = TextEditingController();
  String _message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Page'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a message',
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () async {
                    String message = _controller.text;
                    _controller.clear();
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc("num2")
                        .collection('messages')
                        .doc("num1")
                        .collection('chats')
                        .add({
                      "senderId": "num2",
                      "receiverId": "num1",
                      "message": message,
                      "type": "text",
                      "date": DateTime.now(),
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc("num2")
                          .collection('messages')
                          .doc("num1")
                          .set({
                        'last_msg': message,
                      });
                    });

                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc("num1")
                        .collection('messages')
                        .doc("num2")
                        .collection("chats")
                        .add({
                      "senderId": "num2",
                      "receiverId": "num1",
                      "message": message,
                      "type": "text",
                      "date": DateTime.now(),
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('chats')
                          .doc("num1")
                          .collection('messages')
                          .doc("num2")
                          .set({"last_msg": message});
                    }).then((_) {
                      setState(() {
                        _message = message;
                      });
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 16.0),
          Center(
            child: Text(
              _message,
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
