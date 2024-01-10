import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetget/pages/home.dart';
import 'package:jetget/pages/register.dart';
import 'package:jetget/service/auth.dart';
import 'package:jetget/palette.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = "/login";

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ColorPalette _colorPalette = ColorPalette();

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: _colorPalette.black.withOpacity(.7),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: size.width * .75,
              height: size.height * .75,
              decoration: BoxDecoration(
                color: _colorPalette.black,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: _colorPalette.bg.withOpacity(.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Image(
                            image: AssetImage('assets/images/logo.png'),
                            width: 175,
                            height: 175),
                        const Text(
                          "JetGet'e Hoş Geldiniz\n",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        TextField(
                          controller: _emailController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.white,
                              grade: 24,
                            ),
                            labelText: "E-Posta",
                            hintText: "example@example.com",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.25),
                              fontFamily: "OpenSans",
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              color: Colors.white,
                            ),
                            labelText: "Parola",
                            hintText: "********",
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(.25),
                              fontFamily: "OpenSans",
                              fontSize: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(.8),
                          ),
                          onPressed: () async {
                            try {
                              await _authService
                                  .signIn(_emailController.text,
                                      _passwordController.text)
                                  .then((value) => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const HomePage()))
                                      });
                            } catch (e) {
                              if (e.toString().contains(
                                  "The supplied auth credential is incorrect")) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Girilen E-Posta Adresi ya da Parola Hatalı"),
                                  ),
                                );
                              }
                              if (e.toString().contains("badly formatted")) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Lütfen E-Posta Adresinizi Kontrol Edin"),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text(
                            "Giriş Yap",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()),
                            );
                          },
                          child: const Text(
                            "Hesabınız Yok Mu? Kayıt Ol!",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ),
        ));
  }
}
