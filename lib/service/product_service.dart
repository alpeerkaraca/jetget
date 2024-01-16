import 'package:cloud_firestore/cloud_firestore.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<QueryDocumentSnapshot>> getProducts() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('Products').get();

      return querySnapshot.docs;
    } catch (e) {
      print('Error getting products: $e');
      throw Exception('Error getting products: $e');
    }
  }

  Future<void> addProduct(
    String productName,
    String category,
    String description,
    double price,
    String productImg,
    String creatorUid,
  ) async {
    CollectionReference productsCollection = _firestore.collection('Products');

    try {
      await productsCollection.add({
        'productName': productName,
        'category': category,
        'desc': description,
        'price': price,
        'productImg': productImg ??
            'https://firebasestorage.googleapis.com/v0/b/jetget-dc76f.appspot.com/o/ProductImages%2Fyok.png?alt=media&token=eeb62242-9308-40dc-8aab-4e109fc23564',
        'creatorUid': creatorUid,
      });
    } catch (e) {
      print('Error adding product: $e');
      throw Exception('Error adding product: $e');
    }
  }

  updateProject(String id, String productName, String category,
      String description, double price, String productImg) async {
    CollectionReference productsCollection = _firestore.collection('Products');
    try {
      await productsCollection.doc(id).update({
        'productName': productName,
        'category': category,
        'desc': description,
        'price': price,
        'productImg': productImg ??
            'https://firebasestorage.googleapis.com/v0/b/jetget-dc76f.appspot.com/o/ProductImages%2Fyok.png?alt=media&token=eeb62242-9308-40dc-8aab-4e109fc23564',
      });
    } catch (e) {
      print('Error adding product: $e');
      throw Exception('Error adding product: $e');
    }
  }
}
