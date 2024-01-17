import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditProductPage extends StatefulWidget {
  final String product;

  const EditProductPage({required this.product, super.key});

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  late String productID = widget.product;
  late String imageURL = '';

  late final TextEditingController _productNameController =
      TextEditingController();
  late final TextEditingController _productDescriptionController =
      TextEditingController();
  late final TextEditingController _productPriceController =
      TextEditingController();
  late final TextEditingController _productCategoryController =
      TextEditingController();
  final ColorPalette _colorPalette = ColorPalette();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  File? _image;

  @override
  void dispose() {
    _productNameController.dispose();
    _productPriceController.dispose();
    _productDescriptionController.dispose();
    _productCategoryController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    try {
      getProductDetails(productID);
    } catch (e) {
      // Handle error
      print('Error in initState: $e');
    }
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
      body: StreamBuilder(
          stream: _firestore.collection('Products').doc(productID).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Yükleniyor...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    Text(
                      'Yükleniyor...',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              );
            }
            var product = snapshot.data!;

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                        decoration: BoxDecoration(
                          color: _colorPalette.black.withOpacity(.4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRect(
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () async {
                              final fileName = DateTime.now()
                                  .millisecondsSinceEpoch
                                  .toString();
                              await _picker
                                  .pickImage(
                                      source: ImageSource.gallery,
                                      imageQuality: 50)
                                  .then((value) {
                                    setState(() {
                                      _image = File(value!.path);
                                    });
                                  })
                                  .then((value) => _storage
                                      .ref()
                                      .child('ProductImages/$fileName.jpg')
                                      .putFile(_image!))
                                  .then((value) => value.ref.getDownloadURL())
                                  .then((value) => imageURL = value.toString())
                                  .then((value) => _firestore
                                          .collection('Products')
                                          .doc(productID)
                                          .update({
                                        'productImg': imageURL.toString(),
                                      }));
                              // I want to update the image here
                            },
                            child: Image.network(
                              product['productImg'],
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))),
                TextField(
                  controller: _productNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Ürün Adı',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _productDescriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Ürün Açıklaması',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _productPriceController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Ürün Fiyatı',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _productCategoryController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Ürün Kategorisi',
                    labelStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _colorPalette.darkAqua,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    await _firestore
                        .collection('Products')
                        .doc(productID)
                        .update({
                      'productName': _productNameController.text,
                      'desc': _productDescriptionController.text,
                      'price': double.parse(_productPriceController.text),
                      'category': _productCategoryController.text,
                      'productImg': imageURL.isNotEmpty
                          ? imageURL
                          : product['productImg'],
                    }).then((value) => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text('Ürün Düzenlendi'),
                    )));
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Kaydet',
                    style: TextStyle(
                      color: Colors.white, // Beyaz renk
                    ),
                  ),
                ),


              ],
            );
          }),
    );
  }

  getProductDetails(String productID) async {
    return await FirebaseFirestore.instance
        .collection('Products')
        .doc(productID)
        .get()
        .then((value) {
      _productNameController.text = value.get('productName');
      _productPriceController.text = value.get('price').toString();
      _productDescriptionController.text = value.get('desc');
      _productCategoryController.text = value.get('category');
      imageURL = value.get('productImg').toString();
    });
  }
}
