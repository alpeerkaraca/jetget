import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
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
          ); // Veri yüklenene kadar loading göster
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Verileri çektiğimiz alan
        List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        return GridView.count(
          childAspectRatio: 0.68,
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            for (var product in products)
              IntrinsicHeight(
                  child: Container(
                //Ana Container
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),

                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "itemPage");
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
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0XFF4C53A5),
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
                                  "Kullanıcı adı alınamadı. Hata: ${userSnapshot.error}");
                            }

                            if (userSnapshot.hasData) {
                              var userName = userSnapshot.data!.get('userName');

                              // Alınan kullanıcı adını kullanarak TextSpan oluştur
                              return Text.rich(TextSpan(children: [
                                WidgetSpan(
                                    child: Icon(Icons.person,
                                        size: 16, color: Colors.black)),
                                TextSpan(
                                    text: " $userName",
                                    style: const TextStyle(
                                        fontSize: 16, color: Colors.black)),
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
                          Text('${product['price']} ₺'),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "${product['productName']} isimli tedariğe başvuruldu. (Not implemented Yet)")));
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
                        backgroundColor: const Color(0XFF4C53A5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ))
                  ],
                ),
              )),
          ],
        );
      },
    );
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'USD':
        return '\$';
      case 'TRY':
        return '₺';
      case 'EUR':
        return '€';
      default:
        return ''; // Hata durumunda boş dize döndür
    }
  }
}
