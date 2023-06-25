import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'globals.dart' as globals;

class VideoChatCall extends StatefulWidget {
  @override
  State<VideoChatCall> createState() => _VideoChatCallState();
}

class _VideoChatCallState extends State<VideoChatCall> {
  // bool control = false;
  bool decision = !false;
  bool speaker = false;
  bool mute = false;
  bool drawOpen = false;
  bool camOnOff = true;
  List<Widget> _chats = [
    LeftChat(),
    RightChat(),
    LeftChat(),
    RightChat(),
    LeftChat(),
    RightChat(),
    LeftChat(),
    RightChat(),
    LeftChat(),
    RightChat(),
    // LeftChat(),
    // RightChat(),
    // LeftChat(),
    // RightChat(),
    // LeftChat(),
    // RightChat(),
    // LeftChat(),
    // RightChat(),
    // LeftChat(),
    // RightChat()
  ];
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
          Visibility(visible: !decision, child: video()),
          Visibility(
            visible: !decision,
            child: Opacity(opacity: 0.6, child: chats()),
          ),
          buttons(),
        ],
      )),
    );
  }

  Widget buttons() {
    return !decision
        ? Container(
            height: globals.screenHeight - globals.statusBarHeight,
            width: globals.screenWidth,
            child: Padding(
              padding: EdgeInsets.fromLTRB(globals.generalize(0), 0,
                  globals.generalize(0), globals.generalize(30)),
              child: Container(
                width: globals.screenWidth - globals.generalize(20),
                //color: Colors.red,
                child: Column(
                  crossAxisAlignment: decision
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: decision
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Visibility(visible: decision, child: patch()),
                    Visibility(
                      visible: decision,
                      child: Expanded(
                        child: SizedBox(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: globals.generalize(30)),
                      child: decisionButtons(),
                    ),
                    controlButtons()
                  ],
                ),
              ),
            ),
          )
        : Container(
            height: globals.screenHeight - globals.statusBarHeight,
            width: globals.screenWidth,
            color: Colors.grey[300],
            child: Padding(
              padding: EdgeInsets.fromLTRB(globals.generalize(0), 0,
                  globals.generalize(0), globals.generalize(30)),
              child: Container(
                width: globals.screenWidth - globals.generalize(20),
                //color: Colors.red,
                child: Column(
                  crossAxisAlignment: decision
                      ? CrossAxisAlignment.center
                      : CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: decision
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                  children: [
                    Visibility(visible: decision, child: patch()),
                    Visibility(
                      visible: decision,
                      child: Expanded(
                        child: SizedBox(),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: globals.generalize(30)),
                      child: decisionButtons(),
                    ),
                    controlButtons()
                  ],
                ),
              ),
            ),
          );
  }

  Widget decisionButtons() {
    return Visibility(
      visible: decision,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: globals.generalize(60),
            height: globals.generalize(60),
            child: ElevatedButton(
                //style: ElevatedButton.styleFrom({}),
                onPressed: () {
                  setState(() {
                    decision = false;
                    //control = true;
                    drawOpen = false;
                  });
                },
                child: Icon(
                  Icons.videocam,
                  color: Colors.white,
                  size: globals.generalize(25),
                ),
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
                )),
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
                onPressed: () {},
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
      ),
    );
  }

  Widget controlButtons() {
    return Visibility(
        visible: !decision,
        child: Padding(
          padding: EdgeInsets.only(right: globals.generalize(8)),
          child: Column(
            children: [
              SizedBox(
                width: globals.generalize(45),
                height: globals.generalize(45),
                child: ElevatedButton(
                    //style: ElevatedButton.styleFrom({}),
                    onPressed: () {
                      setState(() {
                        decision = false;
                        //control = true;
                        drawOpen = !drawOpen;
                      });
                    },
                    child: Icon(
                      drawOpen
                          ? Icons.keyboard_arrow_down_outlined
                          : Icons.arrow_forward_ios_rounded,
                      color: Colors.black,
                      size: drawOpen
                          ? globals.generalize(20)
                          : globals.generalize(15),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          return Colors.white;
                        },
                      ),
                      elevation: MaterialStateProperty.all<double>(3),
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
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
                        child: ElevatedButton(
                            //style: ElevatedButton.styleFrom({}),
                            onPressed: () {
                              setState(() {
                                speaker = !speaker;
                              });
                            },
                            child: Icon(
                              (speaker == false)
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              color: Colors.grey,
                              size: globals.generalize(20),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.white;
                                },
                              ),
                              elevation: MaterialStateProperty.all<double>(3),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: globals.generalize(4)),
                      child: SizedBox(
                        width: globals.generalize(45),
                        height: globals.generalize(45),
                        child: ElevatedButton(
                            //style: ElevatedButton.styleFrom({}),
                            onPressed: () {
                              setState(() {
                                mute = !mute;
                              });
                            },
                            child: Icon(
                              (mute == false)
                                  ? Icons.mic_outlined
                                  : Icons.mic_off,
                              color: Colors.grey,
                              size: globals.generalize(20),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.white;
                                },
                              ),
                              elevation: MaterialStateProperty.all<double>(3),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: globals.generalize(4)),
                      child: SizedBox(
                        width: globals.generalize(45),
                        height: globals.generalize(45),
                        child: ElevatedButton(
                            //style: ElevatedButton.styleFrom({}),
                            onPressed: () {
                              setState(() {
                                camOnOff = !camOnOff;
                              });
                            },
                            child: Icon(
                              (camOnOff == false)
                                  ? Icons.videocam_rounded
                                  : Icons.videocam_off_sharp,
                              color: Colors.grey,
                              size: globals.generalize(20),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.white;
                                },
                              ),
                              elevation: MaterialStateProperty.all<double>(3),
                              shadowColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            )),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: globals.generalize(4)),
                      child: SizedBox(
                        width: globals.generalize(45),
                        height: globals.generalize(45),
                        child: ElevatedButton(
                            //style: ElevatedButton.styleFrom({}),
                            onPressed: () {
                              setState(() {
                                decision = true;
                                //control = false;
                              });
                            },
                            child: Icon(
                              Icons.call_end,
                              color: Colors.white,
                              size: globals.generalize(20),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  return Colors.red;
                                },
                              ),
                              elevation: MaterialStateProperty.all<double>(3),
                              shadowColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                ),
                              ),
                            )),
                      ),
                    ),
                  ]),
                ),
              )
            ],
          ),
        ));
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

              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //Expanded(child: SizedBox()),
                  Expanded(
                    child: Container(
                      child: ListView(shrinkWrap: true, children: <Widget>[
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: _chats.map((wid) {
                            return wid;
                          }).toList(),
                        ),
                      ]),
                    ),
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
                            padding: EdgeInsets.fromLTRB(globals.generalize(8),
                                0, globals.generalize(8), 0),
                            child: Icon(
                              Icons.sentiment_satisfied_alt_outlined,
                              size: globals.generalize(25),
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              // width: globals.screenWidth -
                              //     globals.generalize(98),
                              child: TextFormField(
                                decoration: new InputDecoration.collapsed(
                                    hintText: 'Type something here'),
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 5,
                              ),
                            ),
                          ),
                          // Padding(
                          //     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          //     child: SpeedDial(
                          //       direction: SpeedDialDirection.left,
                          //       icon: Icons.add_circle_outline_rounded,
                          //       elevation: 0,
                          //       iconTheme:
                          //           IconThemeData(size: globals.generalize(28)),
                          //       //animatedIcon: AnimatedIcons.add_event,
                          //       buttonSize: Size(globals.generalize(41),
                          //           globals.generalize(41)),
                          //       overlayOpacity: 0,
                          //       backgroundColor: Colors.white,
                          //       foregroundColor: Colors.grey,
                          //       childPadding: EdgeInsets.fromLTRB(0, 3, 0, 2),
                          //       childrenButtonSize: Size(globals.generalize(35),
                          //           globals.generalize(35)),
                          //       children: [
                          //         SpeedDialChild(
                          //             child: Icon(
                          //           Icons.upload_file_outlined,
                          //           size: globals.generalize(25),
                          //           color: Colors.grey,
                          //         )),
                          //         SpeedDialChild(
                          //             child: Icon(
                          //           Icons.location_history_outlined,
                          //           size: globals.generalize(25),
                          //           color: Colors.grey,
                          //         )),
                          //         SpeedDialChild(
                          //             child: Icon(
                          //           Icons.my_location_rounded,
                          //           size: globals.generalize(25),
                          //           color: Colors.grey,
                          //         )),
                          //         SpeedDialChild(
                          //             child: Icon(
                          //           Icons.image_outlined,
                          //           size: globals.generalize(25),
                          //           color: Colors.grey,
                          //         )),
                          //         SpeedDialChild(
                          //             child: Icon(
                          //           Icons.camera_alt_outlined,
                          //           size: globals.generalize(25),
                          //           color: Colors.grey,
                          //         ))
                          //       ],
                          //     )

                          //     // Icon(
                          //     //   Icons.add_circle_outline_rounded,
                          //     //   size: globals.generalize(25),
                          //     //   color: Colors.grey,
                          //     // ),
                          //     ),

                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                0,
                                globals.generalize(0),
                                0,
                                globals.generalize(0)),
                            child:
                                // Container(
                                //   //color: Colors.purple,
                                //   height: globals.generalize(30),
                                //   width: globals.generalize(30),
                                //   decoration: BoxDecoration(
                                //     color: Colors.green[700],
                                //     borderRadius: BorderRadius.all(
                                //       Radius.circular(100),
                                //     ),
                                //   ),
                                //   child:
                                Visibility(
                              visible: true,
                              child: Container(
                                //color: Color.fromARGB(255, 189, 50, 8),
                                child: Icon(
                                  Icons.arrow_circle_right_rounded,
                                  size: globals.generalize(40),
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          //),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget video() {
    return Container(
      height: globals.screenHeight - globals.statusBarHeight,
      width: globals.screenWidth,
      //color: Colors.purple,
      alignment: Alignment.topLeft,
      decoration: new BoxDecoration(
          //border: Border.all(color: Colors.white, width: 3),
          //shape: BoxShape.circle,
          image: new DecorationImage(
              fit: BoxFit.fill, image: AssetImage('assets/images/myPic.jpg'))),
      child: Container(width: 100, height: 140, color: Colors.pink),
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
                        image: AssetImage('assets/images/myPic.jpg')))),
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
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(globals.generalize(8), 0,
            globals.generalize(8), globals.generalize(8)),
        child: Container(
          //height: 50,
          //color: Colors.red,
          alignment: Alignment.center,
          constraints: BoxConstraints(maxWidth: globals.screenWidth / 1.8),
          decoration: BoxDecoration(
            color: Color(0xff0086D1).withOpacity(0.6),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomRight: Radius.circular(40)),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.2),
            //     spreadRadius: 2,
            //     blurRadius: 9,
            //     offset: Offset(0, 0),
            //   ),
            // ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 15, 18, 15),
                child: SizedBox(
                  //width: globals.screenWidth / 2,
                  child: Text(
                    "Hello mate ghgggggggggggggggggggggggggggggggggggggggggggggggggggg",
                    maxLines: 20,
                    //overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontFamily: "FredokaOne"),
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
            color: Colors.white.withOpacity(0.6),
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
                "Hello Good Morningghhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh ",
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
