import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:jetget/pages/acccount_detail.dart';
import 'package:jetget/widgets/HomaAppBar.dart';
import 'package:jetget/widgets/ItemsWidget.dart';
import 'add_product.dart';
import 'package:jetget/palette.dart';
import 'package:jetget/service//product_service.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ColorPalette colorPalette = ColorPalette();
  final ProductService productService = ProductService();
  String selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorPalette.black,
      body: ListView(
        children: [
          const HomeAppBar(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            padding: const EdgeInsets.symmetric(horizontal: 15),
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  height: 50,
                  width: 300,
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Aradığınız ürünü bulun...",
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: const Text(
              "Ürünler",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          // Items Widget
          ItemsWidget(selectedCategory: selectedCategory),
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
        color: Colors.black.withOpacity(0.9),
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

