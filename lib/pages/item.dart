import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:jetget/widgets/ItemAppBar.dart';
import 'package:jetget/widgets/ItemBottomNavBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';

class ItemPage extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ItemPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = ColorPalette();
    return Scaffold(
      backgroundColor: colorPalette.black.withOpacity(.2),
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
              color: colorPalette.black.withOpacity(.4),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 48,
                  bottom: 15,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          product['productName'],
                          style: const TextStyle(
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
                        style: const TextStyle(
                            fontSize: 17, color: Colors.white70),
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
