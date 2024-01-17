import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "../pages/item.dart";
import 'package:jetget/palette.dart';
import 'package:jetget/service/notification_service.dart';
import 'package:jetget/service/apply_works.dart';

class ItemsWidget extends StatefulWidget {
  const ItemsWidget({Key? key, required this.selectedCategory})
      : super(key: key);

  final String selectedCategory;

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  final NotificationService _notificationService = NotificationService();
  final Applies _applies = Applies();

  var user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = ColorPalette();
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
          return Text('Hata: ${snapshot.error}');
        }

        List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        if (widget.selectedCategory.isNotEmpty) {
          products = products
              .where((product) =>
                  product['category'].toLowerCase() ==
                  widget.selectedCategory.toLowerCase())
              .toList();
        }

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
                    color: const Color(0XFF2E2A40),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Image.network(
                          product['productImg'] ??
                              'https://firebasestorage.googleapis.com/v0/b/jetget-dc76f.appspot.com/o/ProductImages%2Fyok.png?alt=media&token=eeb62242-9308-40dc-8aab-4e109fc23564',
                          height: 128,
                          width: 128,
                          cacheWidth: 128,
                          cacheHeight: 128,
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
                          style: const TextStyle(
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
                                        const WidgetSpan(
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
                                            const Icon(Icons.price_change,
                                                color: Colors.white70,
                                                size: 18),
                                            Text('${product.get('price')}',
                                                style: const TextStyle(
                                                    color: Colors.white70,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            const Icon(
                                              Icons.currency_lira,
                                              color: Colors.white70,
                                              size: 18,
                                            )
                                          ],
                                        ),
                                      ),
                                      Center(
                                          child: SizedBox(
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
                                                                '$userName adlı kullanıcı ${product.get('productName')} için başvuru gönderdi.',
                                                            receiverUid:
                                                                product.get(
                                                                    'creatorUid'),
                                                            senderUid:
                                                                user!.uid,
                                                            senderImageURL:
                                                                snapshot.data!.get(
                                                                    'profilePhotoUrl'),
                                                            senderUserName:
                                                                userName,
                                                            productID:
                                                                product.id,
                                                            productName:
                                                                product.get(
                                                                    'productName'),
                                                            context: context,
                                                          );
                                                          _applies
                                                              .applyToProduct(
                                                                  product:
                                                                      product,
                                                                  snapshot:
                                                                      snapshot,
                                                                  userName:
                                                                      userName);

                                                          _applies.saveToProductApplicants(product: product, snapshot: snapshot, userName: userName);

                                                          _notificationService
                                                              .sendPushMessage(
                                                            snapshot.data!
                                                                .get('token'),
                                                            "Yeni Başvuru Teklifi!",
                                                            "$userName adlı kullanıcı ${product.get('productName')} ürünü için başvuru gönderdi.",
                                                          );
                                                        },
                                                        icon: const Icon(
                                                            Icons.add_circle),
                                                        label: const Text(
                                                            'Başvur'),
                                                      );
                                                    } else {
                                                      return const Text("");
                                                    }
                                                  } else {
                                                    return const Text(
                                                        "Kullanıcı adı alınıyor...");
                                                  }
                                                },
                                              )))
                                    ]);
                              } else {
                                return const Text("");
                              }
                            } else {
                              return const Text("Kullanıcı adı alınıyor...");
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
