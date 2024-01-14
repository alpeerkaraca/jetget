import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';

class ItemBottomNavBar extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ItemBottomNavBar({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorPalette _colorPalette = ColorPalette();
    return BottomAppBar(
      color: Colors.black,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: _colorPalette.black.withOpacity(.4),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.9),
              spreadRadius: 3,
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
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
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "${product['productName']} isimli ürüne başvuruldu. (Not implemented Yet)",
                  ),
                ));
              },
              icon: Theme(
                data: ThemeData(
                    iconTheme: IconThemeData(color: _colorPalette.darkAqua)),
                child: const Icon(Icons.add_box_rounded),
              ),
              label: Text(
                "Başvur",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70),
              ),
              style: ElevatedButton.styleFrom(
                primary: _colorPalette.black
                    .withOpacity(0.9), // Arka plan rengi siyah
              ),
            ),
          ],
        ),
      ),
    );
  }
}
