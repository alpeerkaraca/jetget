import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';

class AppliedProductsPage extends StatefulWidget {
  const AppliedProductsPage({Key? key}) : super(key: key);

  @override
  State<AppliedProductsPage> createState() => _AppliedProductsState();
}

class _AppliedProductsState extends State<AppliedProductsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPalette().black,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Başvurduğum Ürünler', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("Users").doc(_auth.currentUser!.uid).collection("AppliedProducts").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData && snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  Text('Yükleniyor...'),
                ],
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              return FutureBuilder(
                future: FirebaseFirestore.instance.collection("Users").doc(document.get('creatorUid')).get(),
                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  if (userSnapshot.hasError) {
                    return Text('Hata: ${userSnapshot.error}');
                  }

                  var userData = userSnapshot.data;
                  var productData = document;

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(productData.get('productImg')),
                    ),
                    title: Text(userData!.get('userName'), style: TextStyle(color: Colors.white)),
                    subtitle: Text(document.get('productName'), style: TextStyle(color: Colors.white)),
                    trailing: Text(document.get('price').toString(), style: TextStyle(color: Colors.white)),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
