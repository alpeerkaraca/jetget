import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';
import 'package:jetget/pages/notifications.dart';
import 'package:jetget/service/notification_service.dart';
import 'package:jetget/service/apply_works.dart';

class ItemBottomNavBar extends StatelessWidget {
  final QueryDocumentSnapshot product;

  ItemBottomNavBar({Key? key, required this.product}) : super(key: key);

  final User user = FirebaseAuth.instance.currentUser!;
  final firestoreInstance = FirebaseFirestore.instance.doc("Users/${FirebaseAuth.instance.currentUser!.uid}");
  final ColorPalette colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection("Users").doc(user.uid).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Yükleniyor...'),
              ],
            ),
          );
        }

        var userData = snapshot.data;

        return BottomAppBar(
          color: Colors.black,
          child: Container(
            height: 70,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: colorPalette.black.withOpacity(.4),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.9),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${product['price']} ₺',
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    NotificationService().saveNotificationToDB(
                      title: "Başvuru",
                      content: "${userData?.get('userName')} adlı kullanıcı ${product['productName']} için başvuru gönderdi.",
                      receiverUid: product['creatorUid'],
                      senderUid: FirebaseAuth.instance.currentUser!.uid,
                      senderImageURL: userData?.get('profilePhotoUrl'),
                      senderUserName: userData?.get('userName'),
                      productID: product.id,
                      productName: product['productName'],
                      context: context,
                    );
                    Applies().applyToProduct(product: product, snapshot: userData, userName: userData?.get('userName'));
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        "${product['productName']} isimli ürüne başvuruldu.",
                      ),
                    ));
                  },
                  icon: Icon(Icons.add_box_rounded, color: colorPalette.darkAqua),
                  label: const Text(
                    "Başvur",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorPalette.black.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
