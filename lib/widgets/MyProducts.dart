import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/pages/edit_product_details.dart';
import 'package:jetget/pages/add_product.dart';

class MyProducts extends StatefulWidget {
  const MyProducts({super.key});

  @override
  State<MyProducts> createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  void initState() {
    checkIsUserLoggedIn(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Products')
            .where('creatorUid', isEqualTo: currentUserId)
            .snapshots(),
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
          List<QueryDocumentSnapshot> myProducts = snapshot.data!.docs;

          if(myProducts.length == 0){
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Henüz ürününüz yok.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    "Ürün eklemek için + butonuna basın.",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  IconButton(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProductAddPage()));}, icon: Icon(Icons.add, color: Colors.white, size: 50,)),
                ],
              ),
            );
          }

          return GridView.count(
            childAspectRatio: 0.68,
            physics: const BouncingScrollPhysics(),
            crossAxisCount: 2,
            shrinkWrap: true,
            children: [
              for (var product in myProducts)
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditProductPage(product: product.id)));
                  },
                  child: IntrinsicHeight(
                    child: Container(
                      //Ana Container
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, bottom: 15),

                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0XFF2E2A40),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: Image.network(
                              product['productImg'],
                              height: 128,
                              width: 128,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              product['productName'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              "${product['price']} ₺",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          );
        });
  }
}

checkIsUserLoggedIn(BuildContext context) async {
  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      Navigator.pushNamed(context, "login");
    }
  });
}
