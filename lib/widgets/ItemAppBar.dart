import 'package:flutter/material.dart';
import 'package:jetget/palette.dart';

class ItemAppBar extends StatelessWidget {
  const ItemAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = ColorPalette();
    return Container(
      color: colorPalette.black.withOpacity(.4),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              size: 30,
              color: Colors.grey, // Buraya istediğiniz renk değerini ekleyebilirsiniz
            ),
          ),
           const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Ürün Detayı",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.grey, // _colorPalette'den renk alınacak
              ),
            ),
          ),
        ],
      ),
    );
  }
}
