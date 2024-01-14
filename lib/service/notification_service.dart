import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await _firebaseMessaging.requestPermission();

    final token = await _firebaseMessaging.getToken();

    FirebaseFirestore.instance.collection('Users').doc(uid).update({
      'token': token,
    });
  }

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
          SnackBar(
            backgroundColor: Colors.red,
            content: Text('Kendinize başvuru gönderemezsiniz.'),
          ),
        );
        //return;
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
            content: Text('${productName} için başvuru gönderildi.'),
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

  Future<void> sendNotificationToUser({
    required String receiverToken,
    required String title,
    required String content,
  }) async {
    return ;
  }






 Future<void> handleBackgroundMessage(RemoteMessage message) async {
    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');
    print('Payload: ${message.data}');
  }



}
