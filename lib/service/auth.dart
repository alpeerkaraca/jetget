import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return user.user!;
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<User> registerUser(String userName, String email, String password) async {

    var user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection("Users").doc(user.user!.uid).set({
      "userName": userName,
      "email": email,
      "uid": user.user!.uid,
      "profilePhotoUrl": "https://firebasestorage.googleapis.com/v0/b/jetget-dc76f.appspot.com/o/ProfilePictures%2Fdefault.png?alt=media&token=7fd2f48d-2dae-47f2-8924-9a73e130ba94",
      "urun": 0,
      "basvuru": 0,
      "tedarik": 0,
    });
    return user.user!;
  }
}