import 'package:flutter/material.dart';
import 'package:jetget/widgets/CartAppBar.dart';
import 'package:jetget/widgets/CartBottomNavBar.dart';
import 'package:jetget/widgets/CartItems.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          const CartAppBar(),
          Container(
            height: 700,
            padding: const EdgeInsets.only(top: 15),
            decoration: const BoxDecoration(
                color: Color(0xFFEDECF2),
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35))),
            child: Column(children: [
              const CartItems(),
              Container(
                //decoration:
                //BoxDecoration(borderRadius: BorderRadius.circular(10)),
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                padding: const EdgeInsets.all(10),
                child: Row(children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF4C53A5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ]),
              ),
            ]),
          )
        ],
      ),
      bottomNavigationBar: const CartBottomNavBar(),
    );
  }
}
