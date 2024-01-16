import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jetget/pages/acccount_detail.dart';
import 'package:jetget/widgets/HomaAppBar.dart';
import 'package:jetget/widgets/ItemsWidget.dart';
import 'add_product.dart';
import 'package:jetget/palette.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorPalette colorPalette = ColorPalette();

    return Scaffold(
      backgroundColor: colorPalette.black,
      body: ListView(
        children: [
          const HomeAppBar(),
          Container(

            padding: const EdgeInsets.only(top: 15),
            decoration:  BoxDecoration(
              color: colorPalette.black.withOpacity(0.9),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35),
                topRight: Radius.circular(35),
              ),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(children: [
                    Container(
                      margin: const EdgeInsets.only(left: 5),
                      height: 50,
                      width: 300,
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search here...",
                        ),
                      ),
                    ),
                  ]),
                ),

                Container(
                  alignment: Alignment.centerLeft,
                  margin:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: const Text(
                    "Ürünler",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                //Items Widget
                 const ItemsWidget(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProductAddPage()),
            );
          }
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountDetails()),
            );
          }
        },
        height: 70,
        color:  Colors.black.withOpacity(0.9),
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white70),
          Icon(
            Icons.add,
            size: 30,
            color: Colors.white70,
          ),
          Icon(
            Icons.person,
            size: 30,
            color: Colors.white70,
          ),
        ],
      ),
    );
  }
}
