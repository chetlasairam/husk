import 'package:huskkk/chatBox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huskkk/methods.dart';
import 'package:huskkk/searchPage.dart';
import 'package:huskkk/settingspage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

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

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List<Widget> documentWidgets = [];

  @override
  void initState() {
    super.initState();
    // retrieveDocumentNames();
  }

  // void retrieveDocumentNames() async {
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection("chats")
  //       .doc("num1")
  //       .collection("messages")
  //       .get();

  //   setState(() {
  //     documentWidgets =
  //         querySnapshot.docs.map((doc) => ChatCard(doc.id)).toList();
  //   });
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
                  Container(height: globals.generalize(90)),
                  Container(
                    height: globals.screenHeight -
                        globals.generalize(90) -
                        globals.statusBarHeight,
                    width: globals.screenWidth,
                    //color: Colors.red,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chats')
                          .doc(myNum)
                          .collection('messages')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final documents = snapshot.data?.docs;

                          return SingleChildScrollView(
                            child: Column(
                              children: documents?.map((doc) {
                                    final docId = doc.id;

                                    return ChatCard(
                                        phoneNumber:
                                            docId); // Replace with your desired widget

                                    // You can also use ListTile for a more comprehensive display
                                    // return ListTile(
                                    //   title: Text(docId),
                                    //   // Add other properties or widgets as needed
                                    // );
                                  }).toList() ??
                                  [],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
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
                  setState(() {
                    print("========================================");
                    print(_auth.currentUser);
                    // ChatCard(_auth.currentUser!.displayName.toString());
                    print("========================================");
                  });
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

  const ChatCard({
    // required this.name,
    required this.phoneNumber,
  });
  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  String? _contactName;

  @override
  void initState() {
    super.initState();
    _loadContactName();
  }

  Future<void> _loadContactName() async {
    final contactName = await getContactNameFromNumber(widget.phoneNumber);
    setState(() {
      _contactName = contactName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ChatBox(
                    // name: widget.name,
                    friendNum: widget.phoneNumber,
                  ))),
      child: Column(
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(globals.generalize(12), 0,
                  globals.generalize(12), globals.generalize(8)),
              child: Container(
                //color: Colors.yellow,
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
                                  image:
                                      AssetImage('assets/images/myPic.jpg')))),
                    ),
                    SizedBox(
                      width: globals.generalize(5),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            0, globals.generalize(8), 0, globals.generalize(8)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              _contactName ?? widget.phoneNumber,
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
                              "Thanks for inviting me",
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
                        "10:23",
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
                            Navigator.push(context,
                                MaterialPageRoute(builder: (_) => Search()));
                          } else if (menu == 3) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => SettingPage()));
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
