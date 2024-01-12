import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemsWidget extends StatelessWidget {
  const ItemsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('Products').get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Veri yüklenene kadar loading göster
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // Verileri çektiğimiz alan
        List<QueryDocumentSnapshot> products = snapshot.data!.docs;

        return GridView.count(
          childAspectRatio: 0.68,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          shrinkWrap: true,
          children: [
            for (var product in products)
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        // Örnek olarak tıklandığında bir sayfaya yönlendirme yapabilirsiniz.
                        Navigator.pushNamed(context, "itemPage");
                      },
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: Image.file(
                          File(product['productImg']), // Firestore'dan çektiğiniz dosya yolu
                          height: 120,
                          width: 120,
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
                      alignment: Alignment.centerLeft,
                      child: Text(
                        product['desc'],
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0XFF4C53A5),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${product['price']}'),
                          const Icon(Icons.shopping_cart_checkout),
                        ],
                      ),
                    ),
                  ],
                ),
              )
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
