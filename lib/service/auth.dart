import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<User> registerUser(String userName, String email, String password, String role) async {

    var user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await _firestore.collection("Users").doc(user.user!.uid).set({
      "userName": userName,
      "email": email,
      "role": role,
    });
    return user.user!;
  }
}