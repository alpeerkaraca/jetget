import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../pages/item.dart";
import 'package:jetget/palette.dart';
import 'package:jetget/service/notification_service.dart';



class ItemsWidget extends StatefulWidget {
  const ItemsWidget({Key? key}) : super(key: key);

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget>{
  late var userSnapshotGlobal;



  final NotificationService _notificationService = NotificationService();

  @override
  Widget build(BuildContext context) {
    final ColorPalette _colorPalette = ColorPalette();
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('Products').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                Text('Yükleniyor...'),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        return GridView.count(
          childAspectRatio: 0.68,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            for (var product in products)
              Container(
                //Ana Container
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: _colorPalette.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ItemPage(product: product),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: Image.network(
                          product['productImg'],
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product['productName'],
                        style: TextStyle(
                          fontSize: 18,
                          overflow: TextOverflow.ellipsis,
                          color: Colors.white70,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('Users')
                            .doc(product['creatorUid'])
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                          if (userSnapshot.connectionState ==
                              ConnectionState.done) {
                            if (userSnapshot.hasError) {
                              return Text(
                                  "Kullanıcı adı alınamadı. Hata: ${userSnapshot
                                      .error}");
                            }

                            if (userSnapshot.hasData) {
                              var userName = userSnapshot.data!.get('userName');
                              userSnapshotGlobal = userSnapshot.data!.data();

                              return Text.rich(TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(Icons.person,
                                        size: 16, color: Colors.white70)),
                                TextSpan(
                                    text: " $userName",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.white70)),
                              ]));
                            } else {
                              return Text("");
                            }
                          } else {
                            return Text("Kullanıcı adı alınıyor...");
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${product['price']} ₺',
                              style: TextStyle(color: Colors.white70)),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          print("Başvuru gönderildi: ÜrünAdı: ${product['productName']}, ÜrünID: ${product.id}, Ürün Sahibi: ${product['creatorUid']}, Başvuran: ${FirebaseAuth.instance.currentUser!.uid}, BaşvuranAdı: ${userSnapshotGlobal.data!.get('userName')}");
                          _notificationService.sendNotificationToUser(
                              "Başvuru",
                              "@${userSnapshotGlobal.data!.get('userName')}, ${product['productName']} isimli tedariğe başvurdu.",
                              product['creatorUid'],
                              FirebaseAuth.instance.currentUser!.uid,
                              userSnapshotGlobal.data!.get('profilePhotoUrl'),
                              userSnapshotGlobal.data!.get('userName'),
                              product.id,
                              product['productName'],
                              context);
                        },
                        icon: const Icon(Icons.add_box_rounded,
                            size: 16, color: Colors.white),
                        label: const Text("Başvur",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          fixedSize: const Size(125, 100),
                          backgroundColor: Colors.black.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }


}