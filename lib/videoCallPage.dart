import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'globals.dart' as globals;

///Use zego

class VideoCall extends StatefulWidget {
  final String friendNum;
  final String myNum;

  const VideoCall({
    required this.myNum,
    required this.friendNum,
  });
  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  bool control = !true;
  bool decision = !false;
  bool speaker = false;
  bool mute = false;
  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xff0D5882),
      body: SafeArea(
        child: Stack(children: [
          Container(
            color: Colors.grey[300],
            height: globals.screenHeight - globals.statusBarHeight,
            width: globals.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                    visible: !decision,
                    child: Container(
                      height: globals.screenHeight - globals.statusBarHeight,
                      width: double.infinity,
                      color: Colors.yellow,
                      child: Center(
                          child: Text(
                              "Video calling screen(Here video is visible)")),
                    )),
                Visibility(
                    visible: decision, child: Expanded(child: mainLayer())),
              ],
            ),
          ),
          Container(
            height: globals.screenHeight - globals.statusBarHeight,
            width: globals.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Visibility(
                //     visible: !decision,
                //     child: Expanded(
                //         child: Container(
                //       color: Colors.yellow,
                //     ))),

                buttons()
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget mainLayer() {
    return Container(
      //color: Colors.purple,
      child: Column(
        children: [
          patch(),
          SizedBox(
            height: globals.screenHeight -
                globals.statusBarHeight -
                globals.generalize(200) -
                globals.generalize(90),
          ),
        ],
      ),
    );
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

  Widget buttons() {
    return Padding(
      padding: EdgeInsets.fromLTRB(globals.generalize(30), 0,
          globals.generalize(30), globals.generalize(30)),
      child: Column(
        children: [decisionButtons(), controlButtons()],
      ),
    );
  }

  Widget controlButtons() {
    return Visibility(
      visible: control,
      child: Row(
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
              setState(() {
                decision = true;
                control = false;
              });
            },
            child: SizedBox(
              width: globals.generalize(60),
              height: globals.generalize(60),
              child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      decision = true;
                      control = false;
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
                    control = true;
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
