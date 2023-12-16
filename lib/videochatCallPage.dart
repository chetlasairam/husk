import 'package:flutter/material.dart';
import 'package:huskkk/homePage.dart';
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:huskkk/constants.dart';
import 'package:permission_handler/permission_handler.dart';

const appId = AgoraConst.appId;
const token = AgoraConst.token;
const channel = AgoraConst.channelName;

class VideoChatCall extends StatefulWidget {
  final String friendNum;
  final String myNum;
  final String callID;

  const VideoChatCall(
      {required this.myNum, required this.friendNum, required this.callID});

  @override
  State<VideoChatCall> createState() => _VideoChatCallState();
}

class _VideoChatCallState extends State<VideoChatCall> {
  bool _engineReleased = false;
  // bool control = false;
  // bool decision = !false;
  bool speaker = false;
  bool mute = false;
  bool drawOpen = false;
  bool camOnOff = true;

  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false; // Track microphone mute state
  bool _isFrontCamera = true; // Track camera position
  bool _isCameraOff = false; // Track camera off state
  bool _isSpeakerOn = true; // Track speaker on state

  late RtcEngine _engine;
  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    // create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
            endCall();
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();

    await _engine.joinChannel(
      token: token,
      channelId: channel,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> endCall() async {
    if (!_engineReleased) {
      _engineReleased = true;
      await _engine.leaveChannel();
      await _engine.release();
      // Navigate to the previous screen or perform any other necessary actions
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  void toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _engine.muteLocalAudioStream(_isMuted);
    });
  }

  void toggleCamera() {
    setState(() {
      _isFrontCamera = !_isFrontCamera;
      _engine.switchCamera();
    });
  }

  void toggleCameraOff() {
    setState(() {
      _isCameraOff = !_isCameraOff;
      _engine.enableLocalVideo(!_isCameraOff);
    });
  }

  void toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
      _engine.setEnableSpeakerphone(_isSpeakerOn);
    });
  }

  void sendMessage(String message) async {
    if (mounted) {
      setState(() {
        _message = message;
      });
    }
  }

  void deleteVideoChatPipe() async {
    try {
      print("============in delete");
      // Reference to the document you want to delete
      await FirebaseFirestore.instance
          .collection("o2ocalls")
          .doc(widget.callID)
          .delete()
          .then((_) => {print('===========Document deleted successfully')});
    } catch (e) {
      print('==========Error deleting document: $e');
    }
  }

  void deleteCallTrace(String myNum, String friendNum) async {
    try {
      await FirebaseFirestore.instance
          .collection('o2ocalls')
          .doc(myNum)
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

  TextEditingController _controller = TextEditingController();
  String _message = '';
  ValueNotifier<bool> showGestureDetector = ValueNotifier<bool>(false);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void dispose() {
    if (!_engineReleased) {
      _engine.release();
      _engineReleased = true;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;
    String? myNum = _auth.currentUser?.displayName.toString();
    String friendNum = widget.friendNum;
    return Scaffold(
      backgroundColor: Color(0xff0D5882),
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(child: video()),
          Opacity(opacity: 0.6, child: chats()),
          buttons(),
        ],
      )),
    );
  }

  Widget buttons() {
    return Container(
      height: globals.screenHeight - globals.statusBarHeight,
      width: globals.screenWidth,
      child: Padding(
        padding: EdgeInsets.fromLTRB(globals.generalize(0), 0,
            globals.generalize(0), globals.generalize(30)),
        child: Container(
          width: globals.screenWidth - globals.generalize(20),
          //color: Colors.red,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [controlButtons()],
          ),
        ),
      ),
    );
  }

  Widget controlButtons() {
    return Padding(
      padding: EdgeInsets.only(right: globals.generalize(8)),
      child: Column(
        children: [
          SizedBox(
            width: globals.generalize(45),
            height: globals.generalize(45),
            child: GestureDetector(
                //style: ElevatedButton.styleFrom({}),
                onTap: () {
                  setState(() {
                    drawOpen = !drawOpen;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(globals.generalize(50)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2), // Shadow color
                        spreadRadius: 2,
                        blurRadius: 9,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Icon(
                    drawOpen
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                    size: drawOpen
                        ? globals.generalize(20)
                        : globals.generalize(15),
                  ),
                )),
          ),
          Visibility(
            visible: drawOpen,
            child: Container(
              //color: Colors.green,
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.only(top: globals.generalize(4)),
                  child: SizedBox(
                      width: globals.generalize(45),
                      height: globals.generalize(45),
                      child: GestureDetector(
                        //style: ElevatedButton.styleFrom({}),
                        onTap: () {
                          setState(() {
                            speaker = !speaker;
                            toggleSpeaker();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(globals.generalize(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 9,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Icon(
                            (speaker == false)
                                ? Icons.volume_up
                                : Icons.volume_off,
                            color: Colors.grey,
                            size: globals.generalize(20),
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: globals.generalize(4)),
                  child: SizedBox(
                    width: globals.generalize(45),
                    height: globals.generalize(45),
                    child: GestureDetector(
                        //style: ElevatedButton.styleFrom({}),
                        onTap: () {
                          setState(() {
                            mute = !mute;
                            toggleMute();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(globals.generalize(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 9,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Icon(
                            (mute == false)
                                ? Icons.mic_outlined
                                : Icons.mic_off,
                            color: Colors.grey,
                            size: globals.generalize(20),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: globals.generalize(4)),
                  child: SizedBox(
                      width: globals.generalize(45),
                      height: globals.generalize(45),
                      child: GestureDetector(
                        //style: ElevatedButton.styleFrom({}),
                        onTap: () {
                          setState(() {
                            _isFrontCamera = !_isFrontCamera;
                            toggleCamera();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(globals.generalize(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 9,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.flip_camera_ios_outlined,
                            color: Colors.grey,
                            size: globals.generalize(20),
                          ),
                        ),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.only(top: globals.generalize(4)),
                  child: SizedBox(
                    width: globals.generalize(45),
                    height: globals.generalize(45),
                    child: GestureDetector(
                        //style: ElevatedButton.styleFrom({}),
                        onTap: () {
                          setState(() {
                            camOnOff = !camOnOff;
                            toggleCameraOff();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(globals.generalize(50)),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.2), // Shadow color
                                spreadRadius: 2,
                                blurRadius: 9,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Icon(
                            (camOnOff == true)
                                ? Icons.videocam_rounded
                                : Icons.videocam_off_sharp,
                            color: Colors.grey,
                            size: globals.generalize(20),
                          ),
                        )),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: globals.generalize(4)),
                  child: SizedBox(
                    width: globals.generalize(45),
                    height: globals.generalize(45),
                    child: GestureDetector(
                      //style: ElevatedButton.styleFrom({}),
                      onTap: () {
                        print("=========deleting");
                        deleteVideoChatPipe();
                        print("-----------deleted");
                        setState(() {
                          deleteCallTrace(widget.myNum, widget.friendNum);
                          endCall();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(globals.generalize(50)),
                          color: Colors.red,
                          boxShadow: [
                            BoxShadow(
                              color:
                                  Colors.grey.withOpacity(0.2), // Shadow color
                              spreadRadius: 2,
                              blurRadius: 9,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.call_end,
                          color: Colors.white,
                          size: globals.generalize(20),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          )
        ],
      ),
    );
  }

  Widget chats() {
    return Container(
      height: globals.screenHeight - globals.statusBarHeight,
      width: globals.screenWidth,
      //color: Colors.deepOrange,
      child: Column(
        children: [
          SizedBox(
            height: globals.screenHeight * 0.30,
          ),
          Expanded(
            child: Container(
              width: globals.screenWidth,
              // constraints: BoxConstraints(
              //     maxHeight: globals.screenHeight -
              //         globals.generalize(56) -
              //         globals.statusBarHeight),
              // height: globals.screenHeight -
              //     globals.generalize(56) -
              //     globals.statusBarHeight,
              //color: Colors.yellow,

              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Expanded(child: SizedBox()),
                /////////////////////////////
                //Chat Option Enable
                Expanded(
                  child: Container(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("o2ocalls")
                              .doc(widget.callID)
                              .collection('chats')
                              .orderBy("date", descending: true)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data.docs.length < 1) {
                                return Center(
                                  child: Text("Say Hi"),
                                );
                              }
                              return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  reverse: true,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    bool isMe = snapshot.data.docs[index]
                                            ['senderId'] ==
                                        widget.myNum;
                                    if (isMe) {
                                      return RightChat(
                                          message: snapshot.data.docs[index]
                                              ['message']);
                                    } else {
                                      return LeftChat(
                                          message: snapshot.data.docs[index]
                                              ['message']);
                                    }
                                  });
                            }
                            return Center(child: CircularProgressIndicator());
                          })),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(globals.generalize(8), 0,
                      globals.generalize(8), globals.generalize(10)),
                  child: Container(
                    width: globals.screenWidth,
                    height: globals.generalize(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 7,
                          blurRadius: 7,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(globals.generalize(8), 0,
                              globals.generalize(8), 0),
                          child: Icon(
                            Icons.sentiment_satisfied_alt_outlined,
                            size: globals.generalize(25),
                            color: Colors.grey,
                          ),
                        ),
                        ValueListenableBuilder<bool>(
                          valueListenable: showGestureDetector,
                          builder: (context, value, _) {
                            return Expanded(
                              child: SizedBox(
                                child: TextFormField(
                                  controller: _controller,
                                  decoration: InputDecoration.collapsed(
                                    hintText: 'Type something here',
                                  ),
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 5,
                                  onChanged: (text) {
                                    setState(() {
                                      showGestureDetector.value =
                                          text.isNotEmpty;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                        Visibility(
                          visible: showGestureDetector.value,
                          child: GestureDetector(
                            onTap: () async {
                              String message = _controller.text;
                              _controller.clear();
                              await FirebaseFirestore.instance
                                  .collection("o2ocalls")
                                  .doc(widget.callID)
                                  .collection('chats')
                                  .add({
                                "senderId": widget.myNum,
                                "receiverId": widget.friendNum,
                                "message": message,
                                "type": "text",
                                "date": DateTime.now(),
                              }).then((value) {
                                FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(widget.myNum)
                                    .collection('messages')
                                    .doc(widget.friendNum)
                                    .set({
                                  'last_msg': message,
                                  'timestamp': FieldValue.serverTimestamp(),
                                });
                              }).then((_) {
                                setState(() {
                                  sendMessage(message);
                                });
                              });

                              // await FirebaseFirestore.instance
                              //     .collection('chats')
                              //     .doc(widget.friendNum)
                              //     .collection('messages')
                              //     .doc(widget.myNum)
                              //     .collection("chats")
                              //     .add({
                              //   "senderId": widget.myNum,
                              //   "receiverId": widget.friendNum,
                              //   "message": message,
                              //   "type": "text",
                              //   "date": DateTime.now(),
                              // }).then((value) {
                              //   FirebaseFirestore.instance
                              //       .collection('chats')
                              //       .doc(widget.friendNum)
                              //       .collection('messages')
                              //       .doc(widget.myNum)
                              //       .set({
                              //     "last_msg": message,
                              //     'timestamp': FieldValue.serverTimestamp(),
                              //   });
                              // }).then((_) {
                              //   setState(() {
                              //     sendMessage(message);
                              //   });
                              // });
                            },
                            child: Container(
                              child: Icon(
                                Icons.arrow_circle_right_rounded,
                                size: globals.generalize(40),
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )

                ///////////////////
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget video() {
    ///friend Screen Container
    return Stack(children: [
      Container(
        height: globals.screenHeight - globals.statusBarHeight,
        width: globals.screenWidth,
        //color: Colors.purple,
        alignment: Alignment.topLeft,
        decoration: new BoxDecoration(
            //border: Border.all(color: Colors.white, width: 3),
            //shape: BoxShape.circle,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/lady1.jpeg'))),

        ///My screen container
        child: _remoteVideo(),
      ),
      Container(
        width: 100,
        height: 140,
        decoration: new BoxDecoration(
            //border: Border.all(color: Colors.white, width: 3),
            //shape: BoxShape.circle,
            color: Colors.yellow,
            image: new DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/lady2.jpeg'))),
        child: _localVideo(),
      ),
    ]);
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _localVideo() {
    if (_localUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const CircularProgressIndicator();
    }
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
                        image: AssetImage('assets/images/myPic.jpeg')))),
            Padding(
              padding: EdgeInsets.fromLTRB(
                  globals.generalize(8),
                  globals.generalize(8),
                  globals.generalize(8),
                  globals.generalize(4)),
              child: Center(
                  child: Text(
                "James",
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

class LeftChat extends StatelessWidget {
  final String message;

  LeftChat({required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          globals.generalize(8),
          0,
          globals.generalize(8),
          globals.generalize(8),
        ),
        child: Container(
          alignment: Alignment.center,
          constraints: BoxConstraints(
            maxWidth: globals.screenWidth / 1.8,
          ),
          decoration: BoxDecoration(
            color: Color(0xff0086D1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              topRight: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
                child: SizedBox(
                  child: Text(
                    message,
                    maxLines: 20,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "FredokaOne",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RightChat extends StatelessWidget {
  final String message;

  RightChat({required this.message});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.fromLTRB(globals.generalize(8), 0,
            globals.generalize(8), globals.generalize(8)),
        child: Container(
          //color: Colors.red,
          //alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: globals.screenWidth / 1.8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                topLeft: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 9,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
            child: SizedBox(
              //width: globals.screenWidth / 2,
              child: Text(
                message,
                maxLines: 20,
                //overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontFamily: "FredokaOne"),
              ),
            ),
          ),
        ),
      ),
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
