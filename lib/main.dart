import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jetget/firebase_options.dart';
import 'package:jetget/pages/home.dart';
import 'package:jetget/pages/item.dart';
import 'package:jetget/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'service/product_service.dart';
import 'package:jetget/pages/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Bir mesaj geldi!');
    print('Mesaj data: ${message.data}');

    if (message.notification != null) {
      print('Bildirim de var: ${message.notification}');
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> _navigateToItemPage(BuildContext context) async {
    final ProductService productService = ProductService();
    final List<QueryDocumentSnapshot> products =
        await productService.getProducts();
    final QueryDocumentSnapshot product = products.isNotEmpty
        ? products[0]
        : throw Exception("No products available");

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "JetGet",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        "/": (context) => const LoginPage(),
        "itemPage": (context) {
          _navigateToItemPage(context);
          return Container();
        },
        "homePage": (context) => const HomePage(),
        "notifications": (context) => const NotificationsPage(),
      },
    );
  }
}
