import 'dart:io';

import 'package:huskkk/callInvitation.dart';
import 'package:huskkk/chatBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huskkk/methods.dart';
import 'package:huskkk/namesave.dart';
import 'package:huskkk/searchPage.dart';
import 'package:huskkk/settingspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:huskkk/videochatCallPage.dart';
import 'package:huskkk/zegocallcode.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:huskkk/stream_listener_widget.dart';

import 'globals.dart' as globals;
import 'package:contacts_service/contacts_service.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

Future<bool> checkContactExists(String phoneNumber) async {
  try {
    // Open the file in read mode
    File file = File('contact.txt');
    if (!(await file.exists())) {
      // If the file doesn't exist, return false
      return false;
    }

    // Read the contents of the file
    List<String> lines = await file.readAsLines();

    // Iterate through the lines to check if the phoneNumber exists
    for (String line in lines) {
      if (line.contains('"$phoneNumber"')) {
        // If the phoneNumber exists in the file, return true
        return true;
      }
    }

    // If the phoneNumber doesn't exist in the file, fetch from device contacts
    PermissionStatus status = await Permission.contacts.request();
    if (!status.isGranted) {
      return false; // Return false if permission is not granted
    }

    final Iterable<Contact> contacts = await ContactsService.getContacts();

    for (final Contact contact in contacts) {
      if (contact.phones != null) {
        for (final Item phone in contact.phones!) {
          final normalizedPhoneNumber =
              phone.value?.replaceAll(RegExp(r'[^0-9]'), '');

          if (normalizedPhoneNumber == phoneNumber) {
            return true; // Contact found in device contacts
          }
        }
      }
    }

    // If contact not found in device contacts, return false
    return false;
  } catch (e) {
    // Handle exceptions, for example, file not found or permission issues
    print('Error occurred while checking contact: $e');
    return false;
  }
}

Future<String> getContactNameFromNumber(String phoneNumber) async {
  // Request contacts permission
  PermissionStatus status = await Permission.contacts.request();
  if (!status.isGranted) {
    return ''; // Return an empty string if permission is not granted
  }

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

/// 1: HomePage
/// 2: Audio Call
/// 3: Video Call
/// 4: Video Chat Call
class HomePage extends StatefulWidget {
  final int nav;
  const HomePage({required this.nav});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool showButton = false;
  void updateButtonVisibility(bool isVisible) {
    Future.microtask(() {
      if (mounted) {
        setState(() {
          print("=====Changing======");
          showButton = isVisible;
        });
      }
    });
  }

  // Future<String> getContactNameFromNumber(String phoneNumber) async {
  //   final Iterable<Contact> contacts = await ContactsService.getContacts();

  //   for (final Contact contact in contacts) {
  //     if (contact.phones != null) {
  //       for (final Item phone in contact.phones!) {
  //         final normalizedPhoneNumber =
  //             phone.value?.replaceAll(RegExp(r'[^0-9]'), '');

  //         if (normalizedPhoneNumber == phoneNumber) {
  //           return contact.displayName ?? '';
  //         }
  //       }
  //     }
  //   }

  //   return ''; // Return an empty string if no matching contact is found
  // }

  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;
    String myNum = _auth.currentUser!.displayName.toString();

    return Scaffold(
      backgroundColor: Color(0xff0D5882),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Patch(),
              Column(
                children: [
                  // ElevatedButton(
                  //     onPressed: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (_) => Namesave(
                  //                     phno: myNum,
                  //                   )));
                  //     },
                  //     child: Container(
                  //       child: Text("Name"),
                  //     )),
                  Container(height: globals.generalize(90)),
                  Container(
                    height: globals.screenHeight -
                        globals.generalize(90) -
                        globals.statusBarHeight,
                    width: globals.screenWidth,
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(myNum)
                          .collection('messages')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data != null) {
                          final documents = snapshot.data?.docs;
                          print('Total documents: ${documents?.length}');

                          return ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              var docId = snapshot.data.docs[index].id;
                              var lastMsg =
                                  snapshot.data.docs[index]['last_msg'];
                              var lastMsgTime =
                                  snapshot.data.docs[index]['timestamp'];

                              if (lastMsgTime != null) {
                                Timestamp timestamp = lastMsgTime;
                                DateTime dateTime = timestamp.toDate();
                                DateFormat formatter = DateFormat('HH:mm');
                                String formattedTime =
                                    formatter.format(dateTime);
                                print("MESSAGE TIME:" + lastMsgTime.toString());

                                return FutureBuilder<DocumentSnapshot>(
                                  future: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(docId)
                                      .get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return ChatCard(
                                        phoneNumber: docId,
                                        lastMsg: lastMsg,
                                        lastMsgTime: formattedTime,
                                        name: docId,
                                        dpImg: "",
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      String name =
                                          snapshot.data?.get('username') ?? "";
                                      String dpImg =
                                          snapshot.data?.get('myImage') ?? "";
                                      return ChatCard(
                                          phoneNumber: docId,
                                          lastMsg: lastMsg,
                                          lastMsgTime: formattedTime,
                                          name:
                                              (name.isNotEmpty) ? name : docId,
                                          dpImg:
                                              (dpImg.isNotEmpty) ? dpImg : "");
                                    }
                                  },
                                );
                              }

                              return Container();
                            },
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Center(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: const CircularProgressIndicator(),
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  // Container(
                  //   height: globals.screenHeight -
                  //       globals.generalize(90) -
                  //       globals.statusBarHeight,
                  //   width: globals.screenWidth,
                  //   //color: Colors.red,
                  //   child: SingleChildScrollView(
                  //     child: Column(
                  //       children:
                  //       documentWidgets.map((wid) {
                  //         return wid;
                  //       }).toList(),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('o2ocalls')
                    .doc(myNum)
                    .snapshots(),
                builder: (context, snapshot) {
                  bool documentExists = snapshot.hasData &&
                      snapshot.data?.data() != null &&
                      (snapshot.data?.data() as Map).isNotEmpty;
                  print(snapshot.data);
                  if (documentExists && !showButton) {
                    updateButtonVisibility(true);
                  } else if (!documentExists && showButton) {
                    updateButtonVisibility(false);
                  }

                  return SizedBox.shrink();
                },
              ),
              if (showButton)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10)),
                    width: 200,
                    height: 150,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('o2ocalls')
                              .doc(myNum)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(); // or any other loading indicator
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              String name =
                                  (snapshot.data?.data() as Map?)?['caller'] ??
                                      '';
                              return FutureBuilder<String>(
                                future: getContactNameFromNumber(name),
                                builder: (context, nameSnapshot) {
                                  if (nameSnapshot.connectionState ==
                                      ConnectionState.done) {
                                    return Text(nameSnapshot.data ?? '');
                                  } else {
                                    return Text(
                                        name); // or any other loading indicator
                                  }
                                },
                              );
                            }
                          },
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('o2ocalls')
                              .doc(myNum)
                              .snapshots(),
                          builder: (context, snapshot) {
                            String name = (snapshot.data?.data()
                                    as Map?)?['present_call'] ??
                                '';
                            return Text(name);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('o2ocalls')
                                  .doc(myNum)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                var friendNum = (snapshot.data?.data()
                                        as Map?)?['caller'] ??
                                    '';
                                return ElevatedButton(
                                  onPressed: () {
                                    try {
                                      var callID = '$friendNum' + "_$myNum";
                                      FirebaseFirestore.instance
                                          .collection('o2ocalls')
                                          .doc(myNum)
                                          .update({
                                        "acceptstatus": "accepted",
                                      });
                                      print(
                                          "callid from receving f+m" + callID);
                                      if ((snapshot.data?.data()
                                              as Map?)?['present_call'] ==
                                          'voice') {
                                        print(
                                            "---------------------callerID_home: $callID");

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VoiceCallZego(
                                              userNum: myNum,
                                              friendNum: friendNum,
                                              callID: callID,
                                            ),
                                          ),
                                        );
                                      } else if ((snapshot.data?.data()
                                              as Map?)?['present_call'] ==
                                          'video') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VideoCallZego(
                                              userNum: myNum,
                                              friendNum: friendNum,
                                              callID: callID,
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => VideoChatCall(
                                              myNum: myNum,
                                              friendNum: friendNum,
                                              callID: callID,
                                            ),
                                          ),
                                        );
                                      }
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //     builder: (context) => VoiceCallZego(
                                      //       userNum: myNum,
                                      //       friendNum: friendNum,
                                      //       callID: callID,
                                      //     ),
                                      //   ),
                                      // );
                                    } catch (e) {
                                      print("=================errorrrr$e");
                                    }
                                  },
                                  child: Icon(Icons.call),
                                );
                              },
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
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
                                },
                                child: Icon(Icons.call_end))
                          ],
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(100),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 7,
              blurRadius: 7,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: SizedBox(
          height: 60.0,
          width: 60.0,
          child: FittedBox(
            child: FloatingActionButton(
                onPressed: () {
                  // setState(() {
                  //   print("=======================================");

                  //   print(_auth.currentUser);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Search()));
                  print("========================================");
                  // });
                },
                backgroundColor: Colors.white,
                elevation: 5,
                child: Icon(
                  Icons.message,
                  color: Colors.black87,
                  size: globals.generalize(20),
                )),
          ),
        ),
      ),
    );
  }

  // // Widget chatCard() {
  // //   return
  // // }
}

class ChatCard extends StatefulWidget {
  // final String name;
  final String phoneNumber;
  final String lastMsg;
  final String lastMsgTime;
  final String name;
  final String dpImg;

  const ChatCard(
      {
      // required this.name,
      required this.phoneNumber,
      required this.lastMsg,
      required this.lastMsgTime,
      required this.name,
      required this.dpImg});
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String? _contactName;
  // String dpImg = "null";
  @override
  void initState() {
    super.initState();
    _loadContactName();
    // fetchUserData();
  }

  _loadContactName() async {
    final contactName = await getContactNameFromNumber(widget.phoneNumber);
    if (mounted) {
      setState(() {
        if (contactName == "") {
          _contactName = widget.phoneNumber;
        } else {
          _contactName = contactName;
        }
      });
    }
  }

  // Future<void> fetchUserData() async {
  //   try {
  //     DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.phoneNumber)
  //         .get();

  //     if (documentSnapshot.exists) {
  //       var data = documentSnapshot.data() as Map<String, dynamic>;
  //       if (data.containsKey("myImage")) {
  //         setState(() {
  //           print("========");
  //           dpImg = data['myImage'];
  //           print("========");
  //         });
  //       }
  //     }
  //   } catch (e) {
  //     print("Error fetching user data: $e");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => ChatBox(
                    // name: widget.name,
                    friendNum: widget.phoneNumber,
                    name: widget.name,
                  ))),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(globals.generalize(12), 0,
                  globals.generalize(12), globals.generalize(8)),
              child: Container(
                //
                width: globals.screenWidth,
                height: globals.generalize(50),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(globals.generalize(3)),
                      child: Container(
                          width: globals.generalize(45),
                          height: globals.generalize(45),
                          decoration: new BoxDecoration(
                              //border: Border.all(color: Colors.white, width: 3),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: widget.dpImg == ""
                                      ? AssetImage('assets/images/myPic.jpeg')
                                      : NetworkImage(widget.dpImg)
                                          as ImageProvider))),
                    ),
                    SizedBox(
                      width: globals.generalize(5),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, globals.generalize(8), 0, globals.generalize(5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: TextStyle(
                                  fontSize: globals.generalize(15),
                                  color: Colors.black,
                                  fontFamily: "FredokaOne"),
                            ),
                            Expanded(
                                child: SizedBox(
                              height: 1,
                            )),
                            Text(
                              widget.lastMsg,
                              style: TextStyle(
                                  fontSize: globals.generalize(10),
                                  color: Colors.grey[600],
                                  fontFamily: "FredokaOne"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Padding(
                      padding: EdgeInsets.all(globals.generalize(18)),
                      child: Text(
                        widget.lastMsgTime,
                        style: TextStyle(
                            fontSize: globals.generalize(10),
                            color: Colors.grey[600],
                            fontFamily: "FredokaOne"),
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

class Patch extends StatefulWidget {
  @override
  _PatchState createState() => _PatchState();
}

class _PatchState extends State<Patch> {
  bool temp = true;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: globals.generalize(globals.screenWidth),
        height: globals.generalize(160),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff0D5882),
            Color(0xff0086D1),
          ],
        )),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(globals.generalize(8)),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/Husklogo_w_png.png',
                    width: globals.generalize(30),
                    height: globals.generalize(30),
                  ),
                  SizedBox(
                    width: globals.generalize(3),
                  ),
                  Text(
                    'HUSK',
                    style: TextStyle(
                        fontSize: globals.generalize(20),
                        color: Colors.white,
                        fontFamily: "FredokaOne"),
                  ),
                  Expanded(
                      child: SizedBox(
                    width: 5,
                  )),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        temp = !temp;
                      });
                    },
                    child: PopupMenuButton(
                        onSelected: (int menu) {
                          if (menu == 2) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => Search()));
                          } else if (menu == 3) {
                            User? user = FirebaseAuth.instance.currentUser;
                            String username = "";
                            if (user != null) {
                              username = user.displayName ?? "No username";
                              String email = user.email ?? "No email";
                              print('Username: $username');
                              print('Email: $email');
                            } else {
                              print('No user currently logged in.');
                            }
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SettingPage(username: username),
                              ),
                            );
                          }
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        child: Center(
                            child: Icon(
                          Icons.menu,
                          color: Colors.white,
                        )),
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 1,
                              child: Center(child: Text('Create Group')),
                              enabled: false,
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Center(child: Text('Search')),
                            ),
                            PopupMenuItem(
                              value: 3,
                              child: Center(child: Text('Settings')),
                            ),
                            PopupMenuItem(
                              value: 4,
                              child: Center(child: Text('SignOut')),
                              onTap: () {
                                signout(context);
                              },
                            ),
                          ];
                        }),
                    // Icon(
                    //   (temp == true) ? Icons.menu : Icons.mic_off,
                    //   color: Colors.white,
                    // ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: globals.generalize(0),
            ),
            Center(
                child: Text(
              "Chats",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: globals.generalize(30),
                  fontFamily: "FredokaOne"),
            )),
          ],
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
