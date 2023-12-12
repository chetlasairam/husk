import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:huskkk/receiverDetailsPage.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_speed_dial/flutter_speed_dial.dart';
// import 'package:huskkk/stream_listener_widget.dart';

import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'sendNotification.dart';

Future<String> getContactNameFromNumber(String phoneNumber) async {
  final Iterable<Contact> contacts = await ContactsService.getContacts();

  for (final Contact contact in contacts) {
    if (contact.phones != null) {
      for (final Item phone in contact.phones!) {
        final normalizedPhoneNumber =
            phone.value?.replaceAll(RegExp(r'[^0-9]'), '');

        if (normalizedPhoneNumber == phoneNumber) {
          return contact.displayName ?? '';
        }
      }
    }
  }

  return ''; // Return an empty string if no matching contact is found
}

class ChatBox extends StatefulWidget {
  // final String name;
  final String friendNum;

  const ChatBox({
    // required this.name,
    required this.friendNum,
  });
  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  String? _contactName;
  String? friendToken;

  @override
  void initState() {
    super.initState();
    _loadContactName();
  }

  Future<void> _loadContactName() async {
    try {
      final contactName = await getContactNameFromNumber(widget.friendNum);
      setState(() {
        if (contactName == "") {
          _contactName = widget.friendNum;
        } else {
          _contactName = contactName;
        }
      });
    } catch (e) {
      print("Error in loading contact name: $e");
      // Handle the error condition here
      // You can set a default value for _contactName or show an error message
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void sendMessage(String message) async {
    if (mounted) {
      setState(() {
        _message = message;
      });
    }
  }

  TextEditingController _controller = TextEditingController();
  String _message = '';
  ValueNotifier<bool> showGestureDetector = ValueNotifier<bool>(false);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;
    String myNum = _auth.currentUser!.displayName.toString();
    String friendNum = widget.friendNum;
    print("============Friend num=$friendNum");

    return Scaffold(
        backgroundColor: Color(0xff0D5882),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff0D5882),
                    Color(0xff0086D1),
                  ],
                )),
                child: Row(
                  children: [
                    // StreamListenerWidget(),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(globals.generalize(8),
                            globals.generalize(8), 0, globals.generalize(8)),
                        child: Icon(
                          Icons.arrow_back_ios_rounded,
                          size: globals.generalize(25),
                          color: Colors.white,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ReceiverDetails(
                                    userNum:
                                        _auth.currentUser!.displayName ?? '',
                                    friendNum: friendNum)));
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0,
                                globals.generalize(8),
                                globals.generalize(8),
                                globals.generalize(8)),
                            child: Container(
                                width: globals.generalize(40),
                                height: globals.generalize(40),
                                decoration: new BoxDecoration(
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/images/myPic.jpg')))),
                          ),
                          Text(
                            _contactName ?? widget.friendNum,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: globals.generalize(18),
                                fontFamily: "FredokaOne"),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                        child: Padding(
                      padding: EdgeInsets.all(globals.generalize(8)),
                      child: PopupMenuButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),

                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                            //Radius.circular(20.0),
                          ),
                        ),
                        //initialValue: 2,
                        child: Center(
                            child: Icon(Icons.more_vert_outlined,
                                color: Colors.white,
                                size: globals.generalize(25))),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: Center(child: Text('Mute')),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Center(child: Text('Hide')),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: Center(child: Text('Clear Chat')),
                            ),
                            PopupMenuItem(
                              value: 4,
                              child: Center(child: Text('Block')),
                              onTap: () {},
                            ),
                          ];
                        },
                      ),

                      // Icon(Icons.more_vert_outlined,
                      //     color: Colors.white, size: globals.generalize(25)),
                    ))
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  width: globals.screenWidth,
                  constraints: BoxConstraints(
                      maxHeight: globals.screenHeight -
                          globals.generalize(56) -
                          globals.statusBarHeight),
                  height: globals.screenHeight -
                      globals.generalize(56) -
                      globals.statusBarHeight,
                  // color: Colors.yellow,
                  color: Colors.grey[300],
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //Expanded(child: SizedBox()),

                      Expanded(
                        child: Container(
                            child: StreamBuilder(
                                stream: FirebaseFirestore.instance
                                    .collection("chats")
                                    .doc(myNum)
                                    .collection('messages')
                                    .doc(friendNum)
                                    .collection('chats')
                                    .orderBy("date", descending: true)
                                    .snapshots(),
                                builder: (context, AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data.docs.length < 1) {
                                      return Center(
                                        child: (friendNum != myNum)
                                            ? Text("Say Hi")
                                            : Text(
                                                "Can't send message to own number"),
                                      );
                                    }
                                    return ListView.builder(
                                        itemCount: snapshot.data.docs.length,
                                        reverse: true,
                                        physics: BouncingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          bool isMe = snapshot.data.docs[index]
                                                  ['senderId'] ==
                                              myNum;
                                          if (isMe) {
                                            return RightChat(
                                                message: snapshot.data
                                                    .docs[index]['message']);
                                          } else {
                                            return LeftChat(
                                                message: snapshot.data
                                                    .docs[index]['message']);
                                          }
                                        });
                                  }
                                  return Center(
                                    child: Container(
                                      height: 100,
                                      width: 100,
                                      child: const CircularProgressIndicator(),
                                    ),
                                  );
                                })

                            // ListView(shrinkWrap: true, children: <Widget>[
                            //   Column(
                            //     mainAxisSize: MainAxisSize.min,
                            //     children: _chats.map((wid) {
                            //       return wid;
                            //     }).toList(),
                            //   ),
                            // ]),
                            ),
                      ),
                      Visibility(
                          visible: (friendNum != myNum) ? true : false,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                globals.generalize(8),
                                0,
                                globals.generalize(8),
                                globals.generalize(10)),
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
                                    padding: EdgeInsets.fromLTRB(
                                        globals.generalize(8),
                                        0,
                                        globals.generalize(8),
                                        0),
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
                                            decoration:
                                                InputDecoration.collapsed(
                                              hintText: 'Type something here',
                                            ),
                                            keyboardType:
                                                TextInputType.multiline,
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
                                            .collection('chats')
                                            .doc(myNum)
                                            .collection('messages')
                                            .doc(friendNum)
                                            .collection('chats')
                                            .add({
                                          "senderId": myNum,
                                          "receiverId": friendNum,
                                          "message": message,
                                          "type": "text",
                                          "date": DateTime.now(),
                                        }).then((value) {
                                          FirebaseFirestore.instance
                                              .collection('chats')
                                              .doc(myNum)
                                              .collection('messages')
                                              .doc(friendNum)
                                              .set({
                                            'last_msg': message,
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                          });
                                        });

                                        await FirebaseFirestore.instance
                                            .collection('chats')
                                            .doc(friendNum)
                                            .collection('messages')
                                            .doc(myNum)
                                            .collection("chats")
                                            .add({
                                          "senderId": myNum,
                                          "receiverId": friendNum,
                                          "message": message,
                                          "type": "text",
                                          "date": DateTime.now(),
                                        }).then((value) {
                                          FirebaseFirestore.instance
                                              .collection('chats')
                                              .doc(friendNum)
                                              .collection('messages')
                                              .doc(myNum)
                                              .set({
                                            "last_msg": message,
                                            'timestamp':
                                                FieldValue.serverTimestamp(),
                                          });
                                        }).then((_) {
                                          setState(() {
                                            sendMessage(message);
                                          });
                                        });
                                        /////////////////////////
                                        try {
                                          DocumentSnapshot friendSnapshot =
                                              await FirebaseFirestore.instance
                                                  .collection('users')
                                                  .doc(friendNum)
                                                  .get();

                                          if (friendSnapshot.exists) {
                                            Map<String, dynamic>? friendData =
                                                friendSnapshot.data()
                                                    as Map<String, dynamic>?;

                                            if (friendData != null &&
                                                friendData
                                                    .containsKey('Token')) {
                                              String? friendToken =
                                                  friendData['Token'];
                                              print(
                                                  'Friend Token: $friendToken');
                                              sendPushNotification(friendToken!,
                                                  _contactName!, message);
                                            } else {
                                              print(
                                                  'Token field not found in friend document or value is null');
                                            }
                                          } else {
                                            print(
                                                'Friend document does not exist');
                                          }
                                        } catch (e) {
                                          print(
                                              'Error retrieving friend token: $e');
                                        }
                                        ///////////////////////
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

                                  Visibility(
                                    visible: !showGestureDetector.value,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        globals.generalize(8),
                                        0,
                                        globals.generalize(8),
                                        0,
                                      ),
                                      child: Icon(
                                        Icons.image_outlined,
                                        size: globals.generalize(25),
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),

                                  // Visibility(
                                  //   visible: !showGestureDetector.value,
                                  //   child: Padding(
                                  //       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  //       child: SpeedDial(
                                  //         direction: SpeedDialDirection.up,
                                  //         icon: Icons.add_circle_outline_rounded,
                                  //         elevation: 0,
                                  //         iconTheme: IconThemeData(
                                  //             size: globals.generalize(28)),
                                  //         //animatedIcon: AnimatedIcons.add_event,
                                  //         buttonSize: Size(globals.generalize(41),
                                  //             globals.generalize(41)),
                                  //         overlayOpacity: 0,
                                  //         backgroundColor: Colors.white,
                                  //         foregroundColor: Colors.grey,
                                  //         childPadding:
                                  //             EdgeInsets.fromLTRB(0, 3, 0, 2),
                                  //         childrenButtonSize: Size(
                                  //             globals.generalize(35),
                                  //             globals.generalize(35)),
                                  // children: [
                                  // SpeedDialChild(
                                  //     child: Icon(
                                  //   Icons.upload_file_outlined,
                                  //   size: globals.generalize(25),
                                  //   color: Colors.grey,
                                  // )),
                                  // SpeedDialChild(
                                  //     child: Icon(
                                  //   Icons.location_history_outlined,
                                  //   size: globals.generalize(25),
                                  //   color: Colors.grey,
                                  // )),
                                  // SpeedDialChild(
                                  //     child: Icon(
                                  //   Icons.my_location_rounded,
                                  //   size: globals.generalize(25),
                                  //   color: Colors.grey,
                                  // )),
                                  // SpeedDialChild(
                                  //     child: Icon(
                                  //   Icons.image_outlined,
                                  //   size: globals.generalize(25),
                                  //   color: Colors.grey,
                                  // )),
                                  // SpeedDialChild(
                                  //     child: Icon(
                                  //   Icons.camera_alt_outlined,
                                  //   size: globals.generalize(25),
                                  //   color: Colors.grey,
                                  // ))
                                  // ],
                                  // )

                                  // Icon(
                                  //   Icons.add_circle_outline_rounded,
                                  //   size: globals.generalize(25),
                                  //   color: Colors.grey,
                                  // ),
                                  //       ),
                                  // ),
                                  // Padding(
                                  //   padding: EdgeInsets.fromLTRB(
                                  //       0,
                                  //       globals.generalize(0),
                                  //       0,
                                  //       globals.generalize(0)),
                                  //   child:
                                  //       // Container(
                                  //       //   //color: Colors.purple,
                                  //       //   height: globals.generalize(30),
                                  //       //   width: globals.generalize(30),
                                  //       //   decoration: BoxDecoration(
                                  //       //     color: Colors.green[700],
                                  //       //     borderRadius: BorderRadius.all(
                                  //       //       Radius.circular(100),
                                  //       //     ),
                                  //       //   ),
                                  //       //   child:
                                  //       Visibility(
                                  //     visible: true,
                                  //     child: Container(
                                  //       //color: Color.fromARGB(255, 189, 50, 8),
                                  //       child: Icon(
                                  //         Icons.arrow_circle_right_rounded,
                                  //         size: globals.generalize(40),
                                  //         color: Colors.green,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                  //),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
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
