import 'package:clippy_flutter/arc.dart';
import 'package:flutter/material.dart';
import 'package:jetget/widgets/ItemAppBar.dart';
import 'package:jetget/widgets/ItemBottomNavBar.dart';

class ItemPage extends StatelessWidget {
  const ItemPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      body: ListView(
        children: [
          const ItemAppBar(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Image.asset(
              "assets/images/ayakkabi.png",
              height: 300,
            ),
          ),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEY,
            height: 30,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: const Padding(
                padding: EdgeInsets.only(
                  top: 48,
                  bottom: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Product",
                          style: TextStyle(
                            fontSize: 28,
                            color: Color(0xFF4C53A5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        "...",
                        textAlign: TextAlign.justify,
                        style:
                            TextStyle(fontSize: 17, color: Color(0xFF4C53A5)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const ItemBottomNavBar(),
    );
  }
}
