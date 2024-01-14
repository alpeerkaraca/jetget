import 'package:flutter/material.dart';
import 'package:jetget/palette.dart';


class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette _colorPalette = ColorPalette();
    return Container(
      color: Colors.black.withOpacity(0.9),
      padding: const EdgeInsets.all(25),
      child: Row(

        children: [
          const Icon(
            Icons.sort,
            size: 30,
            color: Colors.white70,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "JetGet",
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          const Spacer(),
          Badge(
            backgroundColor: Colors.red,
            padding: const EdgeInsets.all(7),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, "cartPage");
              },
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 32,

              ),
            ),
          ),
        ],
      ),
    );
  }
}
