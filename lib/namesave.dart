import 'package:huskkk/homePage.dart';
import 'package:huskkk/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'globals.dart' as globals;
import 'signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Namesave extends StatefulWidget {
  final String phno;
  const Namesave({super.key, required this.phno});
  @override
  State<Namesave> createState() => _NamesaveState();
}

class _NamesaveState extends State<Namesave> {
  void showToast() {
    Fluttertoast.showToast(
      msg: 'Wrong Credentials',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      // backgroundColor: Colors.red,
      // textColor: Colors.yellow
    );
  }

  CollectionReference<Map<String, dynamic>> collectionReference =
      FirebaseFirestore.instance.collection('my_collection');

  bool isLoading = false;

  final TextEditingController _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    globals.screenWidth = MediaQuery.of(context).size.width;
    globals.screenHeight = MediaQuery.of(context).size.height;
    globals.statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
        backgroundColor: Color(0xff0D5882),
        resizeToAvoidBottomInset: false,
        body: isLoading
            ? Center(
                child: Container(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
              )
            : SafeArea(
                child: Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Patch(),
                      Stack(
                        children: [MainLayer()],
                      )

                      // buttons()
                    ],
                  ),
                ),
              ));
  }

  Widget MainLayer() {
    return Stack(children: <Widget>[
      Container(
        height: globals.screenHeight -
            globals.generalize(200) -
            globals.statusBarHeight,
        child: Column(
          children: [
            SizedBox(
              height: globals.generalize(40),
            ),
            TextBoxes(),
            Expanded(child: SizedBox()),
            Buttons(),
          ],
        ),
      )
    ]);
  }

  Widget TextBoxes() {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          globals.generalize(20), 0, globals.generalize(20), 0),
      child: Container(
        width: globals.screenWidth,
        child: Column(
          children: [
            TextFormField(
              inputFormatters: [
                new LengthLimitingTextInputFormatter(10),
              ],
              controller: _name,
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: "FredokaOne"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Buttons() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  if (_name.text.isNotEmpty) {
                    setState(() {
                      isLoading = true;
                    });
                  } else {
                    showToast();
                    print("Please enter credentials");
                  }
                  FirebaseFirestore _firestore = FirebaseFirestore.instance;

                  print("Name saved");

                  // userCrendetial.user!.updateDisplayName(phno);
                  await _firestore.collection('users').doc(widget.phno).update({
                    "username": _name.text,
                    "myImage":
                        "https://firebasestorage.googleapis.com/v0/b/huskkk-729af.appspot.com/o/images%2F4ed5fd13-9d7d-4a31-8004-b38a824fe6c0.jpg?alt=media&token=c02f5a57-a45d-4ad5-a12e-01dd691bd0ee"
                  }).then((value) => Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => HomePage(nav: 1))));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "FredokaOne"),
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.blue),
                  elevation: MaterialStateProperty.all<double>(10),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                )),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}

class Patch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Container(
        width: globals.screenWidth,
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
                ],
              ),
            ),
            SizedBox(
              height: globals.generalize(25),
            ),
            Center(
                child: Text(
              "Welcome",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: globals.generalize(40),
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

class DrawCircle1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = (Colors.grey[200])!;
    canvas.drawCircle(
        Offset(globals.generalize(50), (globals.screenHeight / 4.5)),
        (globals.screenHeight / 4.5),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //false : paint call might be optimized away.
    return false;
  }
}

class DrawCircle2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();

    paint.color = (Colors.grey[200])!;
    canvas.drawCircle(
        Offset(
            globals.screenWidth - 25,
            globals.screenHeight -
                globals.generalize(200) -
                (globals.screenHeight / 11) * 2),
        (globals.screenHeight / 11),
        paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    //false : paint call might be optimized away.
    return false;
  }
}
