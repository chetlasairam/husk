import 'dart:async';
import 'package:huskkk/Authenticate.dart';
import 'package:flutter/material.dart';
import 'package:huskkk/homePage.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: initScreen(context),
    );
  }

  startTime() async {
    var duration = new Duration(seconds: 2);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Authenticate()));
  }

  Widget initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/Husklogo.png',
                width: (150 / 640) * MediaQuery.of(context).size.height,
                height: (150 / 640) * MediaQuery.of(context).size.height,
              ),
              Text(
                'HUSK',
                style: TextStyle(
                    fontSize: (45 / 640) * MediaQuery.of(context).size.height,
                    color: Colors.white,
                    fontFamily: "FredokaOne"),
              ),

              // Text(
              //   '$_counter',
              //   style: Theme.of(context).textTheme.headline4,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
