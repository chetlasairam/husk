import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'splashsr.dart';
// import 'patternPage.dart';
// import 'trash1.dart';
// import 'trash2.dart';
// import 'audioCallPage.dart';
// import 'signInPage.dart';
// import 'signUp.dart';
import 'homePage.dart';
// import 'chatBox.dart';
// import 'videoCallPage.dart';
// import 'videochatCallPage.dart';
// import 'receiverDetailsPage.dart';
// import 'searchPage.dart';
// import 'settingspage.dart';
// import 'test.dart';

Future main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values());
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dem',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: Test(),
      // home: Search(),
      //home: SignInPage(),
      //home: Pattern(),
      //home: SignUp(),
      //home: AudioCall(),
      home: HomePage(),
      //home: ChatBox(),
      //home: TextBox(),
      //home: Trash2(),
      //home: ReceiverDetails(),
      //home: VideoCall(),
      //home: VideoChatCall()
      //home: Search()
      //home: Settings(),
      //home: VideoChatCall(),
      //home: tr1(),
      //home: Pattern(),
    );
  }
}
