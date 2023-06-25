import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'globals.dart' as globals;

class Pattern extends StatefulWidget {
  @override
  _PatternState createState() => _PatternState();
}

class _PatternState extends State<Pattern> {
  final passcodeZone = GlobalKey();

  bool visible1 = false;
  bool visible2 = false;
  bool visible3 = false;
  bool visible4 = false;

  var i = 0;
  var password = [0, 0, 0, 0];
  var pass = "";

  var enable = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: Color(0xffb0F2E3F),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: RadialGradient(
              colors: [
                Color(0xffb0E4D71),
                Color(0xffb0F2E3F),
                Color(0xffb0A2331),
              ],
            )),
            child: Column(children: [
              companyLable(),
              SizedBox(
                height: globals.generalize(100),
              ),
              headingBox(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    globals.generalize(20),
                    globals.generalize(10),
                    globals.generalize(20),
                    globals.generalize(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    key: passcodeZone,
                    //color: Colors.red,
                    child: Column(
                      children: [
                        passcodeCircles(),
                        buttonBox(),
                      ],
                    ),
                  ),
                ),
              ),
              forgotPass(),
            ]),
          ),
        ),
      ),
    );
  }

  Widget companyLable() {
    return Padding(
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
        ],
      ),
    );
  }

  Widget _buildCircle(BuildContext context, a) {
    return a
        ? Container(
            width: globals.generalize(18),
            height: globals.generalize(18),
            decoration: new BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: globals.generalize(3),
              ),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          )
        : Container(
            width: globals.generalize(18),
            height: globals.generalize(18),
            decoration: new BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: globals.generalize(3),
              ),
              //color: Colors.white,
              shape: BoxShape.circle,
            ),
          );
  }

  Widget circlebutton(BuildContext context, n) {
    return Expanded(
        child: Padding(
      padding: EdgeInsets.all(
        globals.generalize(3),
      ),
      child: GestureDetector(
          child: Container(
            width: globals.generalize(60),
            height: globals.generalize(60),
            alignment: Alignment.center,
            //color: Colors.deepOrange,
            child: Text(
              n.toString(),
              style: TextStyle(
                  fontSize: globals.generalize(20),
                  color: Colors.white,
                  fontFamily: "FredokaOne"),
            ),
            decoration: new BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: globals.generalize(5),
              ),
              color: enable[n] ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          onTapDown: (details) {
            setState(() {
              enable[n] = true;
              if (i < 4) {
                i = i + 1;
                pass = pass + n.toString();
                print("------------------");
                print(pass);
                print("------------------");
              }
            });
          },
          // when user leaved
          onTapUp: (details) {
            setState(() {
              enable[n] = false;
            });
          },
          // when user leaved
          onTapCancel: () {
            setState(() {
              enable[n] = false;
            });
          },
          // the action to do when user tap
          onTap: () {
            // code...
          }),
    ));
  }

  Widget headingBox() {
    return Column(
      children: [
        Image.asset(
          'assets/images/Husklogo_w_png.png',
          width: globals.generalize(30),
          height: globals.generalize(30),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(
              0, globals.generalize(8), 0, globals.generalize(15)),
          child: Text(
            "Enter Passcode",
            style: TextStyle(
                fontSize: globals.generalize(20),
                color: Colors.white,
                fontFamily: "FredokaOne"),
          ),
        ),
        // Text(
        //   pass,
        //   style: TextStyle(
        //       fontSize: globals.generalize(15),
        //       color: Colors.white,
        //       fontFamily: "FredokaOne"),
        // )
      ],
    );
  }

  Widget passcodeCircles() {
    return Flexible(
        flex: 1,
        fit: FlexFit.tight,
        child: Container(
            width: 0.45 * globals.screenWidth,
            // color: Colors.blue,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Stack(
                  children: [
                    _buildCircle(context, false),
                    _buildCircle(context, (i > 0)),
                  ],
                ),
                Stack(
                  children: [
                    _buildCircle(context, false),
                    _buildCircle(context, (i > 1)),
                  ],
                ),
                Stack(
                  children: [
                    _buildCircle(context, false),
                    _buildCircle(context, (i > 2)),
                  ],
                ),
                Stack(
                  children: [
                    _buildCircle(context, false),
                    _buildCircle(context, (i > 3)),
                  ],
                ),
              ],
            )));
  }

  Widget buttonBox() {
    return Flexible(
        fit: FlexFit.loose,
        flex: 6,
        child: Padding(
          padding: EdgeInsets.fromLTRB(globals.generalize(20), 0,
              globals.generalize(20), globals.generalize(0)),
          child: Container(
            width: 0.65 * globals.screenWidth,
            height: 0.44 * globals.screenHeight,
            //width: double.maxFinite,
            //height: double.infinity,
            //color: Colors.green,
            // child: ElevatedButton(
            //   onPressed: () {
            //     setState(() {
            //       visible1 = visible1 == true ? visible1 = false : visible1 = true;
            //     });
            //   },
            //   child: Text(text),
            // ),
            child: Column(
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    //color: Colors.pink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        circlebutton(context, 1),
                        circlebutton(context, 2),
                        circlebutton(context, 3)
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    //color: Colors.pink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        circlebutton(context, 4),
                        circlebutton(context, 5),
                        circlebutton(context, 6)
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    //color: Colors.pink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        circlebutton(context, 7),
                        circlebutton(context, 8),
                        circlebutton(context, 9)
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Container(
                    //color: Colors.pink,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(
                              globals.generalize(8),
                            ),
                            child: Container(
                              width: globals.generalize(60),
                              height: globals.generalize(60),
                            ),
                          ),
                        ),
                        circlebutton(context, 0),
                        cancleButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget cancleButton() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(
          globals.generalize(3),
        ),
        child: GestureDetector(
          child: Container(
            width: globals.generalize(60),
            height: globals.generalize(60),
            alignment: Alignment.center,
            //color: Colors.deepOrange,
            child: Icon(Icons.backspace,
                color: Colors.white, size: globals.generalize(20)),

            decoration: new BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: globals.generalize(5),
              ),
              //color: Colors.orange,
              color: enable[10] ? Colors.white : Colors.transparent,
              shape: BoxShape.circle,
            ),
          ),
          onTapDown: (details) {
            setState(() {
              enable[10] = true;
              if (i > 0) {
                i = i - 1;
                pass = pass.substring(0, pass.length - 1);
              }
            });
          },
          // when user leaved
          onTapUp: (details) {
            setState(() {
              enable[10] = false;
            });
          },
          // when user leaved
          // onTapCancel: () {
          //   setState(() {
          //     enabled = false;
          //   });
          // },
          // the action to do when user tap
          // onTap: () {
          //   // code...
          // }
        ),
      ),
    );
  }

  Widget forgotPass() {
    return GestureDetector(
      child: Padding(
        padding: EdgeInsets.all(
          globals.generalize(15),
        ),
        child: Text(
          "Forgot Passcode",
          style: TextStyle(
              fontSize: globals.generalize(15),
              color: Colors.white,
              fontFamily: "FredokaOne"),
        ),
      ),
      onTap: () {
        setState(() {
          print(passcodeZone.currentContext!.size);
        });
      },
    );
  }
}
