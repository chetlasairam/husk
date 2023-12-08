import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:huskkk/signInPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

Future<User?> signup(String phno, String pass) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  try {
    UserCredential userCrendetial = await _auth.createUserWithEmailAndPassword(
        email: (phno + "@gmail.com"), password: pass);
    print("Successfully created");

    // userCrendetial.user!.updateDisplayName(phno);
    await _firestore.collection('users').doc(phno).set({
      "name": phno,
      "email": (phno + "@gmail.com"),
      "status": "Unavalible",
      "uid": _auth.currentUser!.uid,
    });

    return userCrendetial.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future<User?> signin(String phno, String pass) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: (phno + "@gmail.com"), password: pass);
    print("Login Sucessfull");

    _firestore
        .collection('users')
        .doc(phno)
        .get()
        .then((value) => userCredential.user!.updateDisplayName(value['name']));

    String deviceToken = (await _firebaseMessaging.getToken())!;
    await _firestore.collection('users').doc(phno).update({
      "Token": deviceToken,
    });

    return userCredential.user;
  } catch (e) {
    print(e);
    return null;
  }
}

Future signout(BuildContext context) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    await _auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInPage()),
        (Route<dynamic> route) => false,
      );
    });
  } catch (e) {
    print("Error");
  }
}
