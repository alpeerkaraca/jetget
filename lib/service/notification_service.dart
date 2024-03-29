import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> saveNotificationToDB(
      {required String title,
      required String content,
      required String receiverUid,
      required String senderUid,
      required String senderImageURL,
      required String senderUserName,
      required String productID,
      required String productName,
      required BuildContext context}) async {
    try {
      if (receiverUid == senderUid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Kendinize başvuru gönderemezsiniz.'),
          ),
        );
        return;
      }
      await _firestore
          .collection('Users')
          .doc(receiverUid)
          .collection('Notifications')
          .add({
        'title': title,
        'content': content,
        'date': DateTime.now(),
        'sender': senderUid,
        'senderProfileImageURL': senderImageURL,
        'senderName': senderUserName,
        'productID': productID,
        'productName': productName,
      }).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$productName için başvuru gönderildi.'),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bildirim gönderilemedi: $e'),
        ),
      );
    }
  }

  void sendPushMessage(String token, String title, String body) async {
    try {
      await http.post(
          Uri.parse(
              'https://fcm.googleapis.com/v1/projects/jetget-dc76f/messages:send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
                'Bearer ya29.a0AfB_byDlrXpNOkxGznMfWI6twJBnYke89L3Nycc0lQ3Xda_-3fyGJRUGE7HcUcu1jzXePkCn29sjNBxfM4vwDjymGYeHj-lyGPiyOv3UZsyj3sVSJN3U06RInP6QQHhQmYFOdTAb38HYlRjDwEbE3o30180y74faNd4aCgYKAXkSARESFQHGX2Milr-LjVaCMALAGHeYv3mUGQ0170'
          },
          body: {
            'message': {
              'token': token,
              'notification': {'title': title, 'body': body},
              'data': {
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'id': '1',
                'status': 'done'
              }
            }
          });
    } catch (e) {
      print(e);
    }
  }

  Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');
    print('Payload: ${message.data}');
  }
}
