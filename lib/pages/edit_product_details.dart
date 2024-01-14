import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';
import 'package:clippy_flutter/arc.dart';

class EditProductPage extends StatefulWidget {
  final QueryDocumentSnapshot product;

  EditProductPage({required this.product, Key? key}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late QueryDocumentSnapshot product;
  late TextEditingController _productNameController;
  late TextEditingController _productPriceController;
  late TextEditingController _productDescriptionController;
  late TextEditingController _productCategoryController;
  final ColorPalette _colorPalette = ColorPalette();
  @override
  void initState() {
    super.initState();
    product = widget.product;
    _productNameController =
        TextEditingController(text: product['productName']);
    _productPriceController =
        TextEditingController(text: product['price'].toString());
    _productDescriptionController =
        TextEditingController(text: product['desc']);
    _productCategoryController =
        TextEditingController(text: product['category']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.black,
      appBar: AppBar(
        backgroundColor: _colorPalette.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text('Ürün Düzenle', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        children: [
          Padding(
              padding: EdgeInsets.all(16),
              child: Image.network(
                product['productImg'],
                height: 300,
              )),
          Arc(
            edge: Edge.TOP,
            arcType: ArcType.CONVEY,
            height: 30,
            child: Container(
              width: double.infinity,
              color: _colorPalette.black,
              child: Padding(
                padding: EdgeInsets.only(
                  top: 48,
                  bottom: 15,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRect(
                              child: Expanded(
                                child: TextField(
                                  controller: _productNameController,
                                  decoration: InputDecoration(
                                    hintText: "Ürün Adı",
                                    hintStyle: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                  ),

                                  style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 24,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            )),
                      ],
                    ),
                    Divider(
                      color: Colors.black,
                      height: 20,
                      thickness: 2,
                    ),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      child: Text(
                        product['desc'],
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
