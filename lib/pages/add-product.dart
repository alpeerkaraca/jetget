import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jetget/palette.dart';
import 'package:jetget/service/product_service.dart' as ProductService; // Alias added
import 'package:jetget/widgets/ProductFormWidget.dart' as ProductFormWidget;
// Alias added
// Alias added

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final _productNameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image;// Specifying the alias
  final ProductService.ProductService _productService = ProductService.ProductService(); // Specifying the alias

  Future _getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm() async {
    String productName = _productNameController.text;
    String category = _categoryController.text;
    String description = _descriptionController.text;
    double price = double.tryParse(_priceController.text) ?? 0.0;
    String productImg = _image != null ? _image!.path : '';

    try {
      await _productService.addProduct(
        productName,
        category,
        description,
        price,
        productImg,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product Added: $productName'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding product: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    ColorPalette colorPalette = ColorPalette();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Product',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
            color: colorPalette.darkAqua,
          ),
        ),
        backgroundColor: Colors.white,
        actions: const [
          // Bu kısmı Badge widget'ını ekleyerek güncelleyebilirsiniz.
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        children: [
          ProductFormWidget.ProductFormWidget( // Specifying the alias
            productNameController: _productNameController,
            categoryController: _categoryController,
            descriptionController: _descriptionController,
            priceController: _priceController,
            image: _image,
            getImage: _getImage,
            submitForm: _submitForm,
          ),
        ],
      ),
    );
  }

}