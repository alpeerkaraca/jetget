import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jetget/widgets/enums.dart';


class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
        'productImg': productImg,
        'creatorUid': creatorUid,
      });
    } catch (e) {
      // Handle errors, e.g., display a message to the user
      print('Error adding product: $e');
      throw Exception('Error adding product: $e');
    }
  }

  String _getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$';
      case Currency.TRY:
        return '₺';
      case Currency.EUR:
        return '€';
      default:
        return '';
    }
  }
}