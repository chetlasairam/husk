import 'package:flutter/material.dart';
import 'package:huskkk/testCall.dart';
import 'package:flutter/material.dart';
////////////
import 'package:huskkk/constants.dart';
import 'package:huskkk/test.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

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
              decoration: InputDecoration(
                  hintText: "Name", border: OutlineInputBorder()),
              onChanged: (val) {
                name = val;
              },
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                  hintText: "UserId", border: OutlineInputBorder()),
              onChanged: (val) {
                userId = val;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Call(
                                callID: "1",
                              )));
                },
                child: Text("Submit"))
          ],
        )),
      ),
    );
  }
}

/////////////////////////////////////////

class Call extends StatelessWidget {
  const Call({super.key, required this.callID});
  final String callID;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoConst
          .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: ZegoConst
          .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: Test.userId,
      userName: Test.name,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}