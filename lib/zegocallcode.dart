import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
////////////
import 'package:huskkk/constants.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

void deleteCallTrace(String myNum, String friendNum) async {
  try {
    await FirebaseFirestore.instance.collection('o2ocalls').doc(myNum).update({
      "caller": FieldValue.delete(),
      "present_call": FieldValue.delete(),
      "timestamp": FieldValue.delete(),
      "acceptstatus": FieldValue.delete()
      // Add as many fields as your document contains
    }).then((value) {
      // Add any additional actions after the fields are deleted
    });
  } catch (e) {
    // Handle any potential errors here
    print('Error: $e');
  }

  try {
    await FirebaseFirestore.instance
        .collection('o2ocalls')
        .doc(friendNum)
        .update({
      "caller": FieldValue.delete(),
      "present_call": FieldValue.delete(),
      "timestamp": FieldValue.delete(),
      "acceptstatus": FieldValue.delete()
      // Add as many fields as your document contains
    }).then((value) {
      // Add any additional actions after the fields are deleted
    });
  } catch (e) {
    // Handle any potential errors here
    print('Error: $e');
  }
}

class VoiceCallZego extends StatelessWidget {
  const VoiceCallZego(
      {super.key,
      required this.userNum,
      required this.friendNum,
      required this.callID});
  final String callID;
  final String userNum;
  final String friendNum;

  @override
  Widget build(BuildContext context) {
    // deleteCallTrace(userNum);
    return ZegoUIKitPrebuiltCall(
        appID: ZegoConst
            .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
        appSign: ZegoConst
            .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
        userID: userNum,
        userName:
            FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown User',
        callID: callID,

        // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
        config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
          ..onOnlySelfInRoom = (context) {
            Navigator.of(context).pop();

            // Add short delay
            Future.delayed(Duration(milliseconds: 100), () {
              deleteCallTrace(userNum, friendNum);
              print("Call screen popped");
            });
          });
  }
}

class VideoCallZego extends StatelessWidget {
  const VideoCallZego(
      {super.key,
      required this.userNum,
      required this.friendNum,
      required this.callID});
  final String callID;
  final String userNum;
  final String friendNum;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: ZegoConst
          .appId, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: ZegoConst
          .appSign, // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: userNum,
      userName:
          FirebaseAuth.instance.currentUser!.displayName ?? 'Unknown User',

      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) {
          Navigator.of(context).pop();

          // Add short delay
          Future.delayed(Duration(milliseconds: 100), () {
            deleteCallTrace(userNum, friendNum);
            print("Call screen popped");
          });
        },
    );
  }
}
