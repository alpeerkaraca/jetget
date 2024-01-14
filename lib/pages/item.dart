import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:jetget/widgets/ItemAppBar.dart';
import 'package:jetget/widgets/ItemBottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';

class ItemPage extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ItemPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product == null) {
      return Scaffold(
        body: Center(
          child: Text("Hata: Ürün bilgisi alınamadı."),
        ),
      );
    }
    final ColorPalette _colorPalette = ColorPalette();
    return Scaffold(
      backgroundColor: _colorPalette.black.withOpacity(.2),
      body: ListView(
        children: [
          const ItemAppBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.network(
              product['productImg'],
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEY,
            height: 30,
            child: Container(
              width: double.infinity,
              color: _colorPalette.black.withOpacity(.4),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 48,
                  bottom: 15,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Ürün adını ve açıklamayı sola hizala
                  children: [
                    Row(
                      children: [
                        Text(
                          product['productName'],
                          style: TextStyle(
                            fontSize: 28,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        product['desc'],
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 17, color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ItemBottomNavBar(product: product),
    );
  }
}
