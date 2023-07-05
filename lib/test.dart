import 'package:flutter/material.dart';
import 'package:huskkk/testCall.dart';

// import 'package:firebase_database/firebase_database.dart';
class Test extends StatelessWidget {
  const Test({super.key});
  static String name = "";
  static String userId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("VideoCall")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                  hintText: "Name", border: OutlineInputBorder()),
              onChanged: (val) {
                name = val;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextField(
              decoration: const InputDecoration(
                  hintText: "UserId", border: OutlineInputBorder()),
              onChanged: (val) {
                userId = val;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => Call()));
                },
                child: Text("Submit"))
          ],
        )),
      ),
    );
  }
}
