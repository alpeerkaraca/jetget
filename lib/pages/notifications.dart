import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';
import 'package:jetget/service/notification_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ColorPalette _colorPalette = ColorPalette();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bildirimler',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: _colorPalette.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: _colorPalette.black,
      body: StreamBuilder(
        stream: _firestore
            .collection('Users')
            .doc(_auth.currentUser!.uid)
            .collection('Notifications')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text(
                'Sen dayan biz getiriyoz senin verilerini.',
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            );
          }


          if (snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_off,
                  color: Colors.white,
                  size: 24,
                ),
                Text(
                  'Buralar da hep dutluk olmuş.',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ));
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF4C53A5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          document['senderProfileImageURL'].toString()),
                    ),
                    title: Text(
                      document['title'],
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      document['content'],
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        _firestore
                            .collection('Users')
                            .doc(_auth.currentUser!.uid)
                            .collection('Notifications')
                            .doc(document.id)
                            .delete();
                      },
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}



Future<String> getSenderProfileImage(String senderUid) async {
  try {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(senderUid)
        .get();

    return userDoc.get('profileImageURL').toString() ?? '';
  } catch (e) {
    print('Error getting sender profile image: $e');
    return '';
  }
}
