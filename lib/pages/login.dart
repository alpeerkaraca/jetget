import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jetget/pages/home.dart';
import 'package:jetget/pages/register.dart';
import 'package:jetget/service/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String routeName = "/login";

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Container(
            width: size.width * .75,
            height: size.height*.75,
            decoration: BoxDecoration(
              color: Colors.black38.withOpacity(.75),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(

              padding: const EdgeInsets.all(15),
              child:Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                    const Image(image: AssetImage('assets/images/logo.png'),
                      width: 175,
                      height: 175,),
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
                          Icons.email,
                          color: Colors.white,
                        ),
                        labelText: "E-Posta",
                        hintText: "example@example.com",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(.75),
                          fontFamily: "OpenSans",
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                      cursorColor: Colors.white,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        labelText: "Parola",
                        hintText: "********",
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(.75),
                          fontFamily: "OpenSans",
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                     ElevatedButton(
                       style: ElevatedButton.styleFrom(
                         backgroundColor: Colors.white,

                       ),
                      onPressed: () async {
                        try {
                          await _authService.signIn(_emailController.text, _passwordController.text).then((value) => {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()))
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            print('No user found for that email.');
                          } else if (e.code == 'wrong-password') {
                            print('Wrong password provided for that user.');
                          }
                        }
                      },
                      child: const Text("Giriş Yap",style: TextStyle(color: Colors.black),),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterPage()),
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
              )
            ),
          ),
        ),
      )
    );
  }
}