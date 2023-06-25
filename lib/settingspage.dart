import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class SettingPage extends StatefulWidget {
  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _helpblock = false;
  bool _secblock = false;
  bool _notifblock = false;
  bool notif_status = false;
  bool g_notif_status = false;
  bool vibr_status = false;
  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xff0D5882),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  Container(
                    //olor: Colors.green,
                    child: Patch(),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 1,
              child: Container(
                //color: Colors.pink,
                width: globals.screenWidth,
                height: globals.screenHeight - globals.statusBarHeight,
                child: Column(
                  children: [
                    SizedBox(
                      height:
                          globals.generalize(90) - globals.generalize(60 / 2),
                    ),
                    Container(
                      width: globals.generalize(60),
                      height: globals.generalize(60),
                      decoration: new BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Colors.white,
                            Color(0xff0086D1),
                            Color(0xff0086D1),
                            Color(0xff0086D1),
                            Color(0xff0086D1),
                            Color(0xff0086D1),
                          ],
                        ),
                        //border: Border.all(color: Colors.white, width: 3),
                        shape: BoxShape.circle,
                        // image: new DecorationImage(
                        //     fit: BoxFit.fill,
                        //     image: AssetImage('assets/images/myPic.jpg'))
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(globals.generalize(3)),
                        child: Container(
                          width: globals.generalize(54),
                          height: globals.generalize(54),
                          decoration: new BoxDecoration(
                              //border: Border.all(color: Colors.white, width: 3),
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('assets/images/myPic.jpg'))),
                        ),
                      ),
                    ),
                    Text(
                      "James",
                      style: TextStyle(
                          fontSize: globals.generalize(25),
                          color: Colors.black,
                          fontFamily: "FredokaOne"),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Expanded(
                        child: ListView(shrinkWrap: true, children: <Widget>[
                      Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: globals.generalize(30),
                                  vertical: globals.generalize(10)),
                              child: Row(
                                children: [
                                  Text(
                                    "Notifications",
                                    style: TextStyle(
                                        fontSize: globals.generalize(20),
                                        color: Colors.black,
                                        fontFamily: "FredokaOne"),
                                  ),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _notifblock = !_notifblock;
                                        });
                                      },
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: globals.screenWidth,
                            color: Colors.grey[300],
                          ),
                          Visibility(
                            visible: _notifblock,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: globals.generalize(40),
                                      vertical: globals.generalize(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Notifications",
                                        style: TextStyle(
                                            fontSize: globals.generalize(15),
                                            color: Colors.black,
                                            fontFamily: "FredokaOne"),
                                      ),
                                      Expanded(child: SizedBox()),
                                      FlutterSwitch(
                                        width: 45.0,
                                        height: 25.0,
                                        valueFontSize: 12.0,
                                        toggleSize: 18.0,
                                        value: notif_status,
                                        onToggle: (val) {
                                          setState(() {
                                            notif_status = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: globals.generalize(40),
                                      vertical: globals.generalize(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Group Notifications",
                                        style: TextStyle(
                                            fontSize: globals.generalize(15),
                                            color: Colors.black,
                                            fontFamily: "FredokaOne"),
                                      ),
                                      Expanded(child: SizedBox()),
                                      FlutterSwitch(
                                        width: 45.0,
                                        height: 25.0,
                                        valueFontSize: 12.0,
                                        toggleSize: 18.0,
                                        value: g_notif_status,
                                        onToggle: (val) {
                                          setState(() {
                                            g_notif_status = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: globals.generalize(40),
                                      vertical: globals.generalize(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Vibration",
                                        style: TextStyle(
                                            fontSize: globals.generalize(15),
                                            color: Colors.black,
                                            fontFamily: "FredokaOne"),
                                      ),
                                      Expanded(child: SizedBox()),
                                      FlutterSwitch(
                                        width: 45.0,
                                        height: 25.0,
                                        valueFontSize: 12.0,
                                        toggleSize: 18.0,
                                        value: vibr_status,
                                        onToggle: (val) {
                                          setState(() {
                                            vibr_status = val;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: globals.generalize(30),
                                  vertical: globals.generalize(10)),
                              child: Row(
                                children: [
                                  Text(
                                    "Security",
                                    style: TextStyle(
                                        fontSize: globals.generalize(20),
                                        color: Colors.black,
                                        fontFamily: "FredokaOne"),
                                  ),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _secblock = !_secblock;
                                        });
                                      },
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: globals.screenWidth,
                            color: Colors.grey[300],
                          ),
                          Visibility(
                            visible: _secblock,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: globals.generalize(40),
                                      vertical: globals.generalize(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Set/Change password",
                                        style: TextStyle(
                                            fontSize: globals.generalize(15),
                                            color: Colors.black,
                                            fontFamily: "FredokaOne"),
                                      ),
                                      Expanded(child: SizedBox()),
                                      Icon(
                                          Icons.published_with_changes_outlined)
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: globals.generalize(40),
                                      vertical: globals.generalize(10)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Remove password",
                                        style: TextStyle(
                                            fontSize: globals.generalize(15),
                                            color: Colors.black,
                                            fontFamily: "FredokaOne"),
                                      ),
                                      Expanded(child: SizedBox()),
                                      //Icon(Icons.call)
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: globals.generalize(30),
                                  vertical: globals.generalize(10)),
                              child: Row(
                                children: [
                                  Text(
                                    "Help",
                                    style: TextStyle(
                                        fontSize: globals.generalize(20),
                                        color: Colors.black,
                                        fontFamily: "FredokaOne"),
                                  ),
                                  Expanded(child: SizedBox()),
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _helpblock = !_helpblock;
                                        });
                                      },
                                      child:
                                          Icon(Icons.arrow_forward_ios_rounded))
                                ],
                              ),
                            ),
                          ),
                          Container(
                            height: 1,
                            width: globals.screenWidth,
                            color: Colors.grey[300],
                          ),
                          Visibility(
                            visible: _helpblock,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: globals.generalize(40),
                                  vertical: globals.generalize(10)),
                              child: Row(
                                children: [
                                  Text(
                                    "Raise a request",
                                    style: TextStyle(
                                        fontSize: globals.generalize(15),
                                        color: Colors.black,
                                        fontFamily: "FredokaOne"),
                                  ),
                                  Expanded(child: SizedBox()),
                                  // Icon(Icons.arrow_forward_ios_rounded)
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ])),

                    //Expanded(child: SizedBox()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.all(globals.generalize(15)),
                        child: Text(
                          "Version 1.0.0",
                          style: TextStyle(
                              fontSize: globals.generalize(10),
                              color: Colors.grey,
                              fontFamily: "FredokaOne"),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
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
        width: globals.screenWidth,
        height: globals.generalize(90),
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff0D5882),
            Color(0xff0086D1),
          ],
        )),
        child: Container(
          //color: Colors.red,
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: globals.generalize(15)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(globals.generalize(4)),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: globals.generalize(20)),
                    ),
                  ),
                  Container(
                    width: globals.screenWidth - globals.generalize(66),
                    height: globals.generalize(35),
                    //color: Colors.teal,
                    child: Center(
                      child: Text(
                        "SettingPage",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: globals.generalize(25),
                            fontFamily: "FredokaOne"),
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0,
                    child: Padding(
                      padding: EdgeInsets.all(globals.generalize(4)),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white, size: globals.generalize(25)),
                    ),
                  )
                ],
              ),
            ),
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
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height + 30, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
