import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendNotificationToUser(
    String title,
    String content,
    String receiverUid,
    String senderUid,
    String senderImageURL,
    String senderUserName,
    String productID,
    String productName,
    BuildContext context,
  ) async {

    try {
      if(receiverUid == senderUid){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(backgroundColor: Colors.red,
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
}
