import 'package:flutter/material.dart';
import 'package:jetget/pages/login.dart';
import 'package:jetget/service/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String routeName = "/login";

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

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
              width: size.width * .85,
              height: size.height*.85,
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
                          "Aramıza Katılın\n",
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
                        const SizedBox(height: 10),
                        TextField(
                          controller: _userNameController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            labelText: "Kullanıcı Adı",
                            hintText: "example",
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
                        const SizedBox(height: 10),
                        TextField(
                          controller: _roleController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          cursorColor: Colors.white,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                            labelText: "Rol",
                            hintText: "example",
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
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            try {
                                await _authService.registerUser(_userNameController.text, _emailController.text, _passwordController.text, _roleController.text).then((value) => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                  )});
                            }
                            catch(e) {
                              var messsage = "";
                              if(e.toString().contains("email-already-in-use"))
                                {messsage = "Bu e-posta zaten kullanılıyor.";}
                              else if(e.toString().contains("invalid-email")) {
                                messsage = "Geçersiz e-posta adresi.";
                              } else if(e.toString().contains("weak-password")){
                                messsage = "Parola zayıf.";}
                              else {
                                messsage = "Bilinmeyen bir hata oluştu.";}
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(messsage)));
                            }
                          },
                          child: const Text(
                            "Kayıt Ol",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
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