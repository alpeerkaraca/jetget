import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Applies {

  applyToProduct(
      {required QueryDocumentSnapshot product, required snapshot, required String userName}) {
    FirebaseFirestore.instance.collection("Users").doc(
        FirebaseAuth.instance.currentUser!.uid)
        .collection("AppliedProducts").doc(product.id).set({
      "productName": product.get('productName'),
      "productImg": product.get('productImg'),
      "price": product.get('price'),
      "category": product.get('category'),
      "creatorUid": product.get('creatorUid'),
      "applierUid": FirebaseAuth.instance.currentUser!.uid,
      "applierUserName": userName,
      "applierProfilePhotoUrl": snapshot.data!.get('profilePhotoUrl'),
      "productID": product.id,
      "applierToken": snapshot.data!.get('token')});
  }

  saveToProductApplicants(
      {required QueryDocumentSnapshot product, required snapshot, required String userName}) {
    FirebaseFirestore.instance.collection("Products").doc(product.id)
        .collection("Applicants").doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "productName": product.get('productName'),
      "productImg": product.get('productImg'),
      "price": product.get('price'),
      "category": product.get('category'),
      "creatorUid": product.get('creatorUid'),
      "applierUid": FirebaseAuth.instance.currentUser!.uid,
      "applierUserName": userName,
      "applierProfilePhotoUrl": snapshot.data!.get('profilePhotoUrl'),
      "productID": product.id,
      "applierToken": snapshot.data!.get('token')});
  }
}
