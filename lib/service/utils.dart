import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImageFromGallery(context) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  if(image != null){
    return await image.readAsBytes();
  }
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text("Resim seçilmedi"),
      backgroundColor: Colors.red,
    ),
  );
}