import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../pages/item.dart";
import 'package:jetget/palette.dart';
import 'package:jetget/service/notification_service.dart';

class ItemsWidget extends StatefulWidget {
  ItemsWidget({Key? key}) : super(key: key);

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  final NotificationService _notificationService = NotificationService();

  var user = FirebaseAuth.instance.currentUser;
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
          childAspectRatio: 0.586,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            for (var product in products)
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItemPage(product: product),
                    ),
                  );
                },
                child: Container(
                  //Ana Container
                  padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  decoration: BoxDecoration(
                    color: Color(0XFF2E2A40),
                    //color: _colorPalette.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        child: Image.network(
                          product['productImg'],
                          height: 128,
                          width: 128,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        width: 144,
                        child: Divider(
                          color: Colors.white.withOpacity(0.5),
                          thickness: 1,
                        ),
                      ),
                      Container(
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
                      SizedBox(
                        width: 144,
                        child: Divider(
                          color: Colors.white.withOpacity(0.5),
                          thickness: 1,
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
                                    "Kullanıcı adı alınamadı. Hata: ${userSnapshot.error}");
                              }

                              if (userSnapshot.hasData) {
                                return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text.rich(TextSpan(children: [
                                        WidgetSpan(
                                            child: Icon(Icons.person,
                                                color: Colors.white70)),
                                        TextSpan(
                                            text:
                                                "${userSnapshot.data!.get('userName')}",
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Colors.white70,
                                                fontWeight: FontWeight.bold)),
                                      ])),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 8, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Icon(Icons.price_change,
                                                color: Colors.white70,
                                                size: 18),
                                            Text('${product.get('price')}',
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            Icon(
                                              Icons.currency_lira,
                                              color: Colors.white70,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                      ),
                                      Center(
                                          child: Container(
                                              height: 48,
                                              width: 144,
                                              child: FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('Users')
                                                    .doc(user!.uid)
                                                    .get(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    if (snapshot.hasError) {
                                                      return Text(
                                                          "Kullanıcı adı alınamadı. Hata: ${snapshot.error}");
                                                    }

                                                    if (snapshot.hasData) {
                                                      var userName = snapshot
                                                          .data!
                                                          .get('userName');
                                                      return ElevatedButton
                                                          .icon(
                                                        onPressed: () {
                                                          _notificationService
                                                              .saveNotificationToDB(
                                                            title: 'Başvuru',
                                                            content:
                                                                '${userName} adlı kullanıcı ${product.get('productName')} için başvuru gönderdi.',
                                                            receiverUid:
                                                                product.get(
                                                                    'creatorUid'),
                                                            senderUid:
                                                                user!.uid,
                                                            senderImageURL:
                                                                snapshot.data!.get(
                                                                    'profilePhotoUrl'),
                                                            senderUserName:
                                                                snapshot.data!.get(
                                                                    'userName'),
                                                            productID:
                                                                product.id,
                                                            productName:
                                                                product.get(
                                                                    'productName'),
                                                            context: context,
                                                          );
                                                          _notificationService
                                                              .sendNotificationToUser(
                                                            receiverToken:
                                                                snapshot.data!
                                                                    .get(
                                                                        'token'),
                                                            title: 'Başvuru',
                                                            content:
                                                                '@${userName} size başvuru gönderdi.',
                                                          );
                                                        },
                                                        icon: Icon(
                                                            Icons.add_circle),
                                                        label: Text('Başvur'),
                                                      );
                                                    } else {
                                                      return Text("");
                                                    }
                                                  } else {
                                                    return Text(
                                                        "Kullanıcı adı alınıyor...");
                                                  }
                                                },
                                              )))
                                    ]);
                              } else {
                                return Text("");
                              }
                            } else {
                              return Text("Kullanıcı adı alınıyor...");
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
