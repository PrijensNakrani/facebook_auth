import 'package:animate_do/animate_do.dart';
import 'package:firebase_personal_practice/firebase_auth/firebase_sign_service.dart';
import 'package:firebase_personal_practice/screens/home_screen.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _userName = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.orange.shade900,
              Colors.orange.shade800,
              Colors.orange.shade400
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  FadeInDown(
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    ),
                  ),
                  FadeInDown(
                    child: const Text(
                      "welcome",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(60),
                    topLeft: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 150,
                        ),
                        FadeInDown(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(200, 95, 27, 3),
                                  blurRadius: 20,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey.shade200,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: _email,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter Valid Email";
                                        }
                                      },
                                      keyboardType: TextInputType.name,
                                      decoration: const InputDecoration(
                                          hintText: "Email",
                                          border: InputBorder.none),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: TextFormField(
                                      controller: _password,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Enter valid password";
                                        }
                                      },
                                      keyboardType:
                                          TextInputType.visiblePassword,
                                      decoration: const InputDecoration(
                                        hintText: "Password",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          "Forgot password?",
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        FadeInDown(
                          child: GestureDetector(
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                FirebaseAuthService.loginUser(
                                        email: _email.text,
                                        password: _password.text)
                                    .then(
                                  (user) {
                                    if (user != null) {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HomeScreen(),
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text("Login Faild")));
                                    }
                                  },
                                );
                              }
                            },
                            child: Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade900,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // const SizedBox(
                        //   height: 30,
                        // ),
                        // Row(
                        //   children: [
                        //     Expanded(
                        //       child: FadeInDown(
                        //         child: Container(
                        //           height: 50,
                        //           decoration: BoxDecoration(
                        //             color: Colors.blue,
                        //             borderRadius: BorderRadius.circular(50),
                        //           ),
                        //           child: const Center(
                        //             child: Text(
                        //               "facebook",
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //     const SizedBox(
                        //       width: 30,
                        //     ),
                        //     Expanded(
                        //       child: FadeInDown(
                        //         child: Container(
                        //           height: 50,
                        //           decoration: BoxDecoration(
                        //             color: Colors.black,
                        //             borderRadius: BorderRadius.circular(50),
                        //           ),
                        //           child: const Center(
                        //             child: Text(
                        //               "Github",
                        //               style: TextStyle(
                        //                 color: Colors.white,
                        //                 fontSize: 16,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
