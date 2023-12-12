//////Before cloninggfgg originalll

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:huskkk/homePage.dart';
import 'package:huskkk/specificscreen.dart';
// import 'package:flutter/services.dart';

import 'splashsr.dart';

// import 'patternPage.dart';
// import 'trash1.dart';
// import 'trash2.dart';
// import 'audioCallPage.dart';
// import 'signInPage.dart';
// import 'signUp.dart';
// import 'homePage.dart';
// import 'chatBox.dart';
// import 'videoCallPage.dart';
// import 'videochatCallPage.dart';
// import 'receiverDetailsPage.dart';
// import 'searchPage.dart';
// import 'settingspage.dart';
// import 'test.dart';
// import 'callInvitation.dart';
// import 'imagepicker.dart';
// import 'zegocallcode.dart';
final navigatorKey = GlobalKey<NavigatorState>();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  print("====Now Trying FCM done====");

  print("====Trying FCM====");
  //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,

      // home: ImagePick(myNum: "1234567890", friendNum: "919908723592"),
      // home: Test(),
      // home: Search(),
      // home: SignInPage(),
      //home: Pattern(),
      //home: SignUp(),
      // home: AudioCall(myNum: "8309358983", friendNum: "8309358986"),
      // home: const HomePage(
      //   nav: 1,
      // ),
      //home: ChatBox(),
      //home: TextBox(),
      //home: Trash2(),
      // home: ReceiverDetails(),
      // home: VideoCall(myNum: "8309358983", friendNum: "8309358986"),
      // home: VideoChatCall()
      //home: Search()
      //home: Settings(),
      // home: const VideoChatCall(myNum: "8309358983", friendNum: "8309358986"),
      //home: tr1(),
      //home: Pattern(),
      // home: const CallInvite(
      //   ref: 3,
      // ),
      home: SplashScreen(),

      // home: const Test(),
      routes: {SpecificScreen.route: (context) => SplashScreen()},
    );
  }
}
