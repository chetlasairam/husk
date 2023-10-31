import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ImagePick extends StatefulWidget {
  final String myNum;
  final String friendNum;

  ImagePick({required this.myNum, required this.friendNum});

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  final picker = ImagePicker();
  late String imageUrl;

  Future<void> _selectAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 675,
      maxWidth: 960,
    );

    if (pickedFile != null) {
      // Upload image to Firebase Cloud Storage
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');

      final uploadTask = storageRef.putFile(File(pickedFile.path));

      await uploadTask.whenComplete(() => null);

      // Get the image download URL
      imageUrl = await storageRef.getDownloadURL();

      // Store image details in Firestore
      await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.myNum)
          .collection('messages')
          .doc(widget.friendNum)
          .collection('chats')
          .add({
        "senderId": widget.myNum,
        "receiverId": widget.friendNum,
        "message": imageUrl,
        "type": "image",
        "date": DateTime.now(),
      });

      setState(() {
        // Refresh UI if needed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Pick'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _selectAndUploadImage,
          child: Text('Select Image'),
        ),
      ),
    );
  }
}
