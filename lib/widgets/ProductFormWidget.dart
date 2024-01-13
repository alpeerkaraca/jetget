import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jetget/palette.dart';
import 'enums.dart';

class ProductFormWidget extends StatefulWidget {
  final TextEditingController productNameController;
  final TextEditingController categoryController;
  final TextEditingController descriptionController;
  final TextEditingController priceController;
  final File? image;
  final Function getImage;
  final Function submitForm;

  const ProductFormWidget({
    super.key,
    required this.productNameController,
    required this.categoryController,
    required this.descriptionController,
    required this.priceController,
    required this.image,
    required this.getImage,
    required this.submitForm,
  });

  @override
  _ProductFormWidgetState createState() => _ProductFormWidgetState();
}

class _ProductFormWidgetState extends State<ProductFormWidget> {
  final ColorPalette _colorPalette = ColorPalette();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFormField(
              label: 'Ürün İsmi',
              controller: widget.productNameController,
            ),
            _buildFormField(
              label: 'Sektör',
              controller: widget.categoryController,
            ),
            _buildFormField(
              label: 'Açıklama',
              controller: widget.descriptionController,
              maxLines: 3,
            ),
            _buildPriceField(),
            const SizedBox(height: 16),
            _buildImagePicker(),
            const SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }

  Widget _buildPriceField() {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: widget.priceController,
            decoration: InputDecoration(
              labelText: 'Fiyat',
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              suffixIcon: Container(
                margin: const EdgeInsets.only(right: 12.0),
                padding: const EdgeInsets.all(12.0),
                child: const Text(
                  '₺',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0, // Özelleştirebilirsiniz
                  ),
                ),
              ),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'This field is required';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () => widget.getImage(),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  widget.image!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              )
            : const Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.grey,
                  size: 48,
                ),
              ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () => widget.submitForm(),
      style: ElevatedButton.styleFrom(
          backgroundColor: _colorPalette
              .darkAqua // Buradaki renk istediğiniz renge değiştirilebilir
          ),
      child: const Text(
        'Ürün Ekle',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$';
      case Currency.TRY:
        return '₺';
      case Currency.EUR:
        return '€';
    }
  }
}
