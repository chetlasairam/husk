import 'package:huskkk/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'globals.dart' as globals;
import 'signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
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

  bool _isObscurePwd = false;
  bool _isObscureCPwd = false;
  final TextEditingController _phno = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _cpass = TextEditingController();
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
                        children: [CircleLeft(), CircleRight(), MainLayer()],
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
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                new LengthLimitingTextInputFormatter(10),
              ],
              controller: _phno,
              decoration: InputDecoration(
                labelText: 'Phone No.',
                labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: "FredokaOne"),
              ),
            ),
            TextField(
              obscureText: _isObscurePwd,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(10),
              ],
              controller: _pass,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: "FredokaOne"),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscurePwd ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscurePwd = !_isObscurePwd;
                    });
                  },
                ),
              ),
            ),
            TextField(
              obscureText: _isObscureCPwd,
              inputFormatters: [
                new LengthLimitingTextInputFormatter(10),
              ],
              controller: _cpass,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: "FredokaOne"),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isObscureCPwd ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscureCPwd = !_isObscureCPwd;
                    });
                  },
                ),
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
                onPressed: () {
                  if (_phno.text.isNotEmpty &&
                      _pass.text.isNotEmpty &&
                      _cpass.text.isNotEmpty &&
                      _pass.text == _cpass.text) {
                    setState(() {
                      isLoading = true;
                    });

                    signup(_phno.text, _pass.text).then((user) {
                      if (user != null) {
                        user.updateDisplayName(_phno.text).then((_) {
                          print('Profile Updated');
                        });
                        setState(() {
                          isLoading = false;
                        });
                        print("SignUp successful");
                        collectionReference
                            .add({_phno.text: user.uid}).then((documentRef) {
                          print(
                              'Data appended successfully with ID: ${documentRef.id}');
                        }).catchError((error) {
                          print('Error appending data: $error');
                        });
                        Navigator.push(context,
                            MaterialPageRoute(builder: (_) => SignInPage()));
                      } else {
                        print("SignUp Failed===");
                        setState(() {
                          isLoading = false;
                        });
                        Fluttertoast.showToast(
                          msg: "Account already exists",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                        );
                      }
                    });
                  } else {
                    showToast();
                    print("Please enter credentials");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: "FredokaOne"),
                  ),
                ),
                style: ButtonStyle(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Alreary have an account?",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontFamily: "FredokaOne"),
              ),
              GestureDetector(
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: "FredokaOne"),
                ),
                onTap: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                  (Route<dynamic> route) => false,
                ),
              ),
            ],
          )
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

class CircleLeft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: globals.screenWidth,
      height: globals.screenHeight -
          globals.generalize(200) -
          globals.statusBarHeight,
      //color: Colors.green,
      child: CustomPaint(
        painter: DrawCircle1(),
      ),
    );
  }
}

class CircleRight extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: globals.screenWidth,
      height: globals.screenHeight -
          globals.generalize(200) -
          globals.statusBarHeight,
      //color: Colors.green,
      child: CustomPaint(
        painter: DrawCircle2(),
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
