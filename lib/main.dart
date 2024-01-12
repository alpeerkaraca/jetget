import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jetget/firebase_options.dart';
import 'package:jetget/pages/cart.dart';
import 'package:jetget/pages/home.dart';
import 'package:jetget/pages/item.dart';
import 'package:jetget/pages/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          "cartPage": (context) => const CartPage(),
          "itemPage": (context) => const ItemPage(),
          "homePage": (context) => const HomePage(),
        });
  }
}
