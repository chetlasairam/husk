import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:huskkk/videochatCallPage.dart';
import 'package:huskkk/zegocallcode.dart';
import 'globals.dart' as globals;

class CallInvite extends StatefulWidget {
  final int ref;
  final int user;
  final String userNum;
  final String friendNum;
  const CallInvite(
      {super.key,
      required this.userNum,
      required this.friendNum,
      required this.user,
      required this.ref});

  @override
  State<CallInvite> createState() => _CallInviteState();
}

class _CallInviteState extends State<CallInvite> {
  String dpImg = "null";
  @override
  void initState() {
    super.initState();

    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.friendNum)
          .get();

      if (documentSnapshot.exists) {
        var data = documentSnapshot.data() as Map<String, dynamic>;
        if (data.containsKey("myImage")) {
          setState(() {
            print("========");
            dpImg = data['myImage'];
            print("========");
          });
        }
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  void callReject() {
    Navigator.pop(context);

    print("rejected call");
  }

  bool speaker = false;
  bool mute = false;
  bool documentExists = false;

  @override
  Widget build(BuildContext context) {
    int user = widget.user;
    int ref = widget.ref;
    String userNum = widget.userNum;
    String friendNum = widget.friendNum;
    print("building-----------");
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('o2ocalls')
          .doc(widget.friendNum)
          .snapshots(),
      builder: (context, snapshot) {
        documentExists = snapshot.hasData &&
            snapshot.data?.data() != null &&
            (snapshot.data?.data() as Map).isNotEmpty;
        if (!documentExists) {
          // Delay the pop to handle quick state changes
          Future.delayed(Duration(milliseconds: 500), () {
            // Check the state variable again before popping
            if (mounted && !documentExists) {
              Navigator.pop(context);
            }
          });
        }

        if (documentExists) {
          Map<String, dynamic>? typedata =
              snapshot.data?.data() as Map<String, dynamic>?;

          String? callType = typedata?['present_call'];
          Map<String, dynamic>? data =
              snapshot.data?.data() as Map<String, dynamic>?;

          if (data != null &&
              data.containsKey("acceptstatus") &&
              data["acceptstatus"] == "accepted") {
            var callID = '${widget.userNum}_${widget.friendNum}';
            if (callType == 'voice') {
              print("typedata=======$callType");
              print("------------------------Friendnum: $friendNum");
              print("---------------------callerID: $callID");

              return VoiceCallZego(
                  userNum: widget.userNum,
                  friendNum: widget.friendNum,
                  callID: callID);
            } else if (callType == 'video') {
              print("typedata=======$callType");
              return VideoCallZego(
                userNum: widget.userNum,
                friendNum: widget.friendNum,
                callID: callID,
              );
            } else {
              print("typedata=======$callType");
              return VideoChatCall(
                  myNum: widget.userNum,
                  friendNum: widget.friendNum,
                  callID: callID);
            }
          }
        }

        return Scaffold(
          backgroundColor: Color(0xff0D5882),
          body: SafeArea(
            child: Stack(
              children: [
                buttons(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buttons() {
    return Container(
      height: globals.screenHeight - globals.statusBarHeight,
      width: globals.screenWidth,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.fromLTRB(globals.generalize(0), 0,
            globals.generalize(0), globals.generalize(30)),
        child: Container(
          width: globals.screenWidth - globals.generalize(20),
          //color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              patch(),
              Expanded(
                child: SizedBox(),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: globals.generalize(30)),
                child:
                    (widget.user == 0) ? decisionButtons() : controlButtons(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget decisionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: globals.generalize(60),
          height: globals.generalize(60),
          child: ElevatedButton(
              //style: ElevatedButton.styleFrom({}),
              onPressed: () {
                setState(() {
                  if (widget.ref == 2) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VoiceCallZego(
                            callID: "${widget.friendNum}_${widget.userNum}",
                            userNum: widget.userNum,
                            friendNum: widget.friendNum),
                      ),
                    );
                  } else if (widget.ref == 3) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoCallZego(
                            callID: "${widget.userNum}_${widget.friendNum}",
                            userNum: widget.userNum,
                            friendNum: widget.friendNum),
                      ),
                    );
                  } else {
                    var callID = "${widget.friendNum}_${widget.userNum}";
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoChatCall(
                          myNum: widget.userNum,
                          friendNum: widget.friendNum,
                          callID: callID,
                        ),
                      ),
                    );
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.green;
                  },
                ),
                elevation: MaterialStateProperty.all<double>(10),
                shadowColor: MaterialStateProperty.all<Color>(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
              child: getIcon()),
        ),
        Expanded(
          child: SizedBox(
            width: globals.generalize(20),
          ),
        ),
        SizedBox(
          width: globals.generalize(60),
          height: globals.generalize(60),
          child: ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('o2ocalls')
                    .doc(widget.userNum)
                    .update({
                  "caller": FieldValue
                      .delete(), // Replace 'field1' with your actual field name
                  "present_call": FieldValue
                      .delete(), // Replace 'field2' with your actual field name
                  "timestamp": FieldValue.delete(),
                  "acceptstatus": FieldValue.delete()
                }).then(
                  (value) {
                    callReject();
                  },
                );

                // callReject();
              },
              child: Icon(
                Icons.call_end,
                color: Colors.white,
                size: globals.generalize(25),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return (Colors.red[700])!;
                  },
                ),
                elevation: MaterialStateProperty.all<double>(10),
                shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              )),
        )
      ],
    );
  }

  Widget controlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: globals.generalize(60),
          height: globals.generalize(60),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  speaker = !speaker;
                });
              },
              child: Icon(
                (speaker == false) ? Icons.volume_up : Icons.volume_off,
                color: Colors.grey,
                size: globals.generalize(25),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.white;
                  },
                ),
                elevation: MaterialStateProperty.all<double>(10),
                shadowColor:
                    MaterialStateProperty.all<Color>((Colors.grey[350])!),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              )),
        ),
        Expanded(
          child: SizedBox(
            width: globals.generalize(20),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {});
          },
          child: SizedBox(
            width: globals.generalize(60),
            height: globals.generalize(60),
            child: ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('o2ocalls')
                      .doc(widget.friendNum)
                      .update({
                    "caller": FieldValue
                        .delete(), // Replace 'field1' with your actual field name
                    "present_call": FieldValue
                        .delete(), // Replace 'field2' with your actual field name
                    "timestamp": FieldValue.delete(),
                    "acceptstatus": FieldValue.delete()
                    // Add as many fields as your document contains
                  }).then((value) {
                    callReject();
                  });
                },
                child: Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: globals.generalize(25),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      return (Colors.red[700])!;
                    },
                  ),
                  elevation: MaterialStateProperty.all<double>(10),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.red),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                )),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: globals.generalize(20),
          ),
        ),
        SizedBox(
          width: globals.generalize(60),
          height: globals.generalize(60),
          child: ElevatedButton(
              onPressed: () {
                setState(() {
                  mute = !mute;
                });
              },
              child: Icon(
                (mute == false) ? Icons.mic_outlined : Icons.mic_off,
                color: Colors.grey,
                size: globals.generalize(25),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    return Colors.white;
                  },
                ),
                elevation: MaterialStateProperty.all<double>(10),
                shadowColor:
                    MaterialStateProperty.all<Color>((Colors.grey[350])!),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              )),
        )
      ],
    );
  }

  Widget getIcon() {
    if (widget.ref == 2) {
      return Icon(
        Icons.call,
        color: Colors.white,
        size: globals.generalize(25),
      );
    } else if (widget.ref == 3) {
      return Icon(
        Icons.videocam,
        color: Colors.white,
        size: globals.generalize(25),
      );
    } else {
      return Icon(
        Icons.video_chat,
        color: Colors.white,
        size: globals.generalize(25),
      );
    }
  }

  Widget patch() {
    return ClipPath(
      child: Container(
        width: globals.generalize(globals.screenWidth),
        height: globals.generalize(200),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff0D5882),
            Color(0xff0086D1),
          ],
        )),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // SizedBox(
              //   height: globals.generalize(20),
              // ),
              Container(
                  width: globals.generalize(70),
                  height: globals.generalize(70),
                  decoration: new BoxDecoration(
                      border: Border.all(color: Colors.white, width: 3),
                      shape: BoxShape.circle,
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: dpImg == "null"
                              ? AssetImage('assets/images/myPic.jpeg')
                              : NetworkImage(dpImg) as ImageProvider))),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    globals.generalize(8),
                    globals.generalize(8),
                    globals.generalize(8),
                    globals.generalize(4)),
                child: Center(
                    child: Text(
                  widget.friendNum,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: globals.generalize(25),
                      fontFamily: "FredokaOne"),
                )),
              ),
              Center(
                  child: Text(
                "Ringing...",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: globals.generalize(13),
                    fontFamily: "FredokaOne"),
              )),
              SizedBox(
                height: globals.generalize(20),
              )
            ],
          ),
        ),
      ),
      clipper: CustomClipPath(),
    );
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
