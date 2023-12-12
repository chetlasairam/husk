import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huskkk/callInvitation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:huskkk/chatBox.dart';
import 'package:contacts_service/contacts_service.dart';
import 'globals.dart' as globals;
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

class ReceiverDetails extends StatefulWidget {
  final String userNum;
  final String friendNum;

  const ReceiverDetails({
    super.key,
    required this.userNum,
    required this.friendNum,
  });
  @override
  _ReceiverDetailsState createState() => _ReceiverDetailsState();
}

class _ReceiverDetailsState extends State<ReceiverDetails> {
  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        backgroundColor: Color(0xff0D5882),
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Patch(
                  userNum: widget.userNum,
                  friendNum: widget.friendNum,
                ),
                MainLayer(
                  friendNum: widget.friendNum,
                )

                // buttons()
              ],
            ),
          ),
        ));
  }
}

class Patch extends StatefulWidget {
  final String userNum;
  final String friendNum;

  const Patch({
    super.key,
    required this.userNum,
    required this.friendNum,
  });
  @override
  _PatchState createState() => _PatchState();
}

class _PatchState extends State<Patch> {
  String? _contactName;

  @override
  void initState() {
    super.initState();
    _loadContactName();
  }

  Future<void> _loadContactName() async {
    final contactName = await getContactNameFromNumber(widget.friendNum);
    setState(() {
      if (contactName == "") {
        _contactName = widget.friendNum;
      } else {
        _contactName = contactName;
      }
    });
  }

  Future<String> getContactName(String phoneNumber) async {
    Iterable<Contact> contacts =
        await ContactsService.getContacts(query: phoneNumber);
    Contact contact = contacts.firstWhere(
        (contact) => contact.phones!.any((item) => item.value == phoneNumber),
        orElse: () => Contact());
    return contact.displayName ?? phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomClipPath(),
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
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: globals.generalize(12),
              horizontal: globals.generalize(8)),
          child: Row(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: globals.generalize(25)),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: globals.generalize(10)),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: globals.generalize(20),
                        // ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                              width: globals.generalize(70),
                              height: globals.generalize(70),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.white, width: 3),
                                  shape: BoxShape.circle,
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                          'assets/images/myPic.jpg')))),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              globals.generalize(8),
                              globals.generalize(8),
                              globals.generalize(8),
                              globals.generalize(4)),
                          child: Center(
                            //     child: FutureBuilder<String>(
                            //   future: getContactNameFromNumber(widget.friendNum),
                            //   builder: (BuildContext context,
                            //       AsyncSnapshot<String> snapshot) {
                            //     if (snapshot.connectionState ==
                            //         ConnectionState.waiting) {
                            //       return Center(
                            //         child: Container(
                            //           height: 10,
                            //           width: 10,
                            //           child: CircularProgressIndicator(),
                            //         ),
                            //       ); // or some other widget while waiting
                            //     } else {
                            //       if (snapshot.hasError)
                            //         return Text('Error: ${snapshot.error}');
                            //       else
                            //         return Text(snapshot.data ?? 'Not found',
                            //             style: TextStyle(
                            //                 color: Colors.white,
                            //                 fontSize: globals.generalize(25),
                            //                 fontFamily: "FredokaOne"));
                            //     }
                            //   },
                            // )

                            ///////////////////////
                            child: Text(
                              _contactName ?? widget.friendNum,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: globals.generalize(18),
                                  fontFamily: "FredokaOne"),
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setupCall(widget.userNum, widget.friendNum,
                                        "voice", _contactName)
                                    .then((_) {
                                  setState(() {
                                    // sendMessage(message); or any other state updates
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CallInvite(
                                              user: 1,
                                              ref: 2,
                                              userNum: widget.userNum,
                                              friendNum: widget.friendNum)));
                                }).catchError((error) {
                                  // Handle any errors here
                                });
                              },
                              child: Icon(
                                Icons.call,
                                color: Colors.white,
                                size: globals.generalize(25),
                              ),
                            ),
                            SizedBox(
                              width: globals.generalize(12),
                            ),
                            GestureDetector(
                              onTap: () {
                                setupCall(widget.userNum, widget.friendNum,
                                        "video", _contactName)
                                    .then((_) {
                                  setState(() {
                                    // sendMessage(message); or any other state updates
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CallInvite(
                                              user: 1,
                                              ref: 3,
                                              userNum: widget.userNum,
                                              friendNum: widget.friendNum)));
                                }).catchError((error) {
                                  // Handle any errors here
                                });
                              },
                              child: Icon(
                                Icons.videocam,
                                color: Colors.white,
                                size: globals.generalize(25),
                              ),
                            ),
                            SizedBox(
                              width: globals.generalize(12),
                            ),
                            GestureDetector(
                              onTap: () {
                                setupCall(widget.userNum, widget.friendNum,
                                        "videochat", _contactName)
                                    .then((_) {
                                  setState(() {
                                    // sendMessage(message); or any other state updates
                                  });

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => CallInvite(
                                              user: 1,
                                              ref: 4,
                                              userNum: widget.userNum,
                                              friendNum: widget.friendNum)));
                                }).catchError((error) {
                                  // Handle any errors here
                                });
                              },
                              child: Icon(
                                Icons.video_camera_back,
                                color: Colors.white,
                                size: globals.generalize(25),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: globals.generalize(20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
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
                    child: Icon(Icons.more_vert_outlined,
                        color: Colors.white, size: globals.generalize(25)),
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
                  ))),
            ],
          ),
        ),
      ),
    );
  }
}

setupCall(userNum, friendNum, msg, _contactName) async {
  await FirebaseFirestore.instance
      .collection('o2ocalls')
      .doc(userNum)
      .collection('records')
      .doc(friendNum)
      .collection('log')
      .add({
    "callerId": userNum,
    "callreceiverId": friendNum,
    "message": msg,
    "type": "text",
    "date": DateTime.now(),
  }).then((value) {
    FirebaseFirestore.instance
        .collection('o2ocalls')
        .doc(userNum)
        .collection('records')
        .doc(friendNum)
        .set({
      'present_call': msg,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }).then((value) {
    FirebaseFirestore.instance.collection('o2ocalls').doc(friendNum).set({
      'caller': userNum,
      'present_call': msg,
      'timestamp': FieldValue.serverTimestamp(),
    });
  });

  await FirebaseFirestore.instance
      .collection('o2ocalls')
      .doc(friendNum)
      .collection('records')
      .doc(userNum)
      .collection("log")
      .add({
    "callerId": userNum,
    "callreceiverId": friendNum,
    "message": msg,
    "type": "text",
    "date": DateTime.now(),
  }).then((value) {
    FirebaseFirestore.instance
        .collection('o2ocalls')
        .doc(friendNum)
        .collection('records')
        .doc(userNum)
        .set({
      "present_call": msg,
      'timestamp': FieldValue.serverTimestamp(),
    });
  });
  try {
    DocumentSnapshot friendSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendNum)
        .get();

    if (friendSnapshot.exists) {
      Map<String, dynamic>? friendData =
          friendSnapshot.data() as Map<String, dynamic>?;

      if (friendData != null && friendData.containsKey('Token')) {
        String? friendToken = friendData['Token'];
        print('Friend Token: $friendToken');
        sendPushNotification(
            friendToken!, _contactName!, "incoming $msg call...");
      } else {
        print('Token field not found in friend document or value is null');
      }
    } else {
      print('Friend document does not exist');
    }
  } catch (e) {
    print('Error retrieving friend token: $e');
  }
}

class CustomClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height + 30, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MainLayer extends StatefulWidget {
  final String friendNum;

  const MainLayer({
    super.key,
    // required this.name,
    required this.friendNum,
  });
  @override
  State<MainLayer> createState() => _MainLayerState();
}

class _MainLayerState extends State<MainLayer> {
  bool _mediaOpen = true;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(globals.generalize(8), 0,
          globals.generalize(8), globals.generalize(8)),
      child: Container(
        width: globals.screenWidth,
        height: globals.screenHeight -
            globals.statusBarHeight -
            globals.generalize(200) -
            globals.generalize(8),
        //color: Colors.teal,
        child: Column(children: [
          Container(
            width: double.infinity,
            height: _mediaOpen
                ? globals.generalize(100)
                : globals.screenHeight -
                    globals.statusBarHeight -
                    globals.generalize(200) -
                    globals.generalize(8),
            //color: Colors.red,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 9,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  globals.generalize(8),
                  globals.generalize(4),
                  globals.generalize(8),
                  globals.generalize(4)),
              child: Column(children: [
                Row(
                  children: [
                    Text(
                      "Media",
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: globals.generalize(15),
                          fontFamily: "FredokaOne"),
                    ),
                    Expanded(child: SizedBox()),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _mediaOpen = !_mediaOpen;
                        });
                      }),
                      child: Icon(
                        _mediaOpen
                            ? Icons.arrow_drop_down_sharp
                            : Icons.arrow_right,
                        color: Colors.grey,
                        size: globals.generalize(18),
                      ),
                    )
                  ],
                ),
                Visibility(
                    visible: _mediaOpen, child: Expanded(child: SizedBox())),
                Visibility(
                  visible: _mediaOpen,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: globals.generalize(6), horizontal: 0),
                      child: Row(
                          children: List.generate(
                        15,
                        (index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 3.0),
                            child: Container(
                                width: globals.generalize(60),
                                height: globals.generalize(60),
                                decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    image: new DecorationImage(
                                        fit: BoxFit.fill,
                                        image: AssetImage(
                                            'assets/images/myPic.jpg')))),
                          );
                        },
                      )),
                    ),
                  ),
                ),
                Visibility(
                    visible: !_mediaOpen,
                    child: SizedBox(
                      height: globals.generalize(8),
                    )),
                Visibility(
                  visible: !_mediaOpen,
                  child: Expanded(
                      child: Container(
                          //color: Colors.cyan,
                          child: GridView.count(
                              mainAxisSpacing: 5,
                              //crossAxisSpacing: 5,
                              crossAxisCount: 4,
                              children: List.generate(
                                50,
                                (index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 3.0),
                                    child: GestureDetector(
                                      onTap: () => Navigator.of(context).push(
                                          PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  HeroWidgetDetail(),
                                              transitionsBuilder: ((context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return child;
                                              }))),
                                      child: Hero(
                                        tag: 'img',
                                        child: Container(
                                            width: globals.generalize(60),
                                            height: globals.generalize(60),
                                            decoration: new BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(5),
                                                ),
                                                image: new DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                        'assets/images/myPic.jpg')))),
                                      ),
                                    ),
                                  );
                                },
                              )))),
                )
              ]),
            ),
          ),
          Visibility(
            visible: _mediaOpen,
            child: SizedBox(
              height: globals.generalize(10),
            ),
          ),
          Visibility(
            visible: _mediaOpen,
            child: Container(
              //color: Colors.yellow,
              height: globals.generalize(50),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 9,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.all(globals.generalize(12)),
                child: Row(children: [
                  Text(
                    "Phone No.",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: globals.generalize(15),
                        fontFamily: "FredokaOne"),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    widget.friendNum,
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: globals.generalize(15),
                        fontFamily: "FredokaOne"),
                  ),
                ]),
              ),
            ),
          ),
          Visibility(
            visible: _mediaOpen,
            child: SizedBox(
              height: globals.generalize(10),
            ),
          ),
          Visibility(
            visible: _mediaOpen,
            child: Expanded(
              child: Container(
                //color: Colors.blue,
                //height: globals.generalize(50),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 9,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      globals.generalize(8),
                      globals.generalize(4),
                      globals.generalize(8),
                      globals.generalize(4)),
                  child: Column(children: [
                    Row(
                      children: [
                        Text(
                          "Calls",
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: globals.generalize(15),
                              fontFamily: "FredokaOne"),
                        ),
                      ],
                    ),
                    Container(
                      height: globals.screenHeight -
                          globals.statusBarHeight -
                          globals.generalize(412),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                              globals.generalize(0),
                              globals.generalize(10),
                              globals.generalize(0),
                              globals.generalize(4)),
                          child: Column(children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Yesterday",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "20:27",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "32 minutes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_received_rounded,
                                      color: Colors.green,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "02 minutes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_made_rounded,
                                      color: Colors.green,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.videocam_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "                     ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_missed_outgoing_outlined,
                                      color: Colors.red,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Yesterday",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "20:27",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "32 minutes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_received_rounded,
                                      color: Colors.green,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "02 minutes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_made_rounded,
                                      color: Colors.green,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.videocam_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "                     ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_missed_outgoing_outlined,
                                      color: Colors.red,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Yesterday",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "20:27",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "32 minutes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_received_rounded,
                                      color: Colors.green,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.call_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "02 minutes",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_made_rounded,
                                      color: Colors.green,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.videocam_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "                     ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_missed_outgoing_outlined,
                                      color: Colors.red,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.videocam_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "                     ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_missed_outgoing_outlined,
                                      color: Colors.red,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: globals.generalize(4)),
                              child: Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.videocam_outlined,
                                      color: Colors.blue,
                                      size: globals.generalize(25),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "30/2/2022",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          ",",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                        Text(
                                          "06:57",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: globals.generalize(12),
                                              fontFamily: "FredokaOne"),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "                     ",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: globals.generalize(12),
                                          fontFamily: "FredokaOne"),
                                    ),
                                    Icon(
                                      Icons.call_missed_outgoing_outlined,
                                      color: Colors.red,
                                      size: globals.generalize(25),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class HeroWidgetDetail extends StatelessWidget {
  const HeroWidgetDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Hero(
        tag: 'img',
        child: Center(
          child: Container(
              decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                  image: new DecorationImage(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/images/myPic.jpg')))),
        ),
      )),
    );
  }
}
