import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';

Future<void> sendPushNotification(
    String friendToken, String friendNum, String msg) async {
  try {
    final body = jsonEncode({
      "to": friendToken,
      "notification": {"title": friendNum, "body": msg}
    });
    var response = await post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader:
              'key=AAAALQ0bMBc:APA91bFw9zgoTVqYBiix-QyU3xn-rVS3vDdMQ-B4Q2xqCoeG0E88fGtuTxZQl87xAzQcA4AoT5ttXd-fRQ2zu18staiSPekzPD81HFTQ9aLKA-oqjWLngXDBVuUZJn6Wf7jvDhqJpPtU'
        },
        body: body);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
  } catch (e) {
    print("\\\\\============== $e");
  }
}
