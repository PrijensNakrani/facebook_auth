import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_personal_practice/firbase_data/notes_screen.dart';
import 'package:firebase_personal_practice/firebase_auth/facebook_auth.dart';
import 'package:firebase_personal_practice/firebase_auth/firebase_sign_service.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SignUPScreen1 extends StatefulWidget {
  const SignUPScreen1({Key? key}) : super(key: key);

  @override
  State<SignUPScreen1> createState() => _SignUPScreen1State();
}

class _SignUPScreen1State extends State<SignUPScreen1> {
  final _email = TextEditingController();
  final _userName = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final file = await picker.getImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _image = File(file.path);
      });
    }
  }

  Future uploadImage({File? file}) async {
    try {
      var response = await firebase_storage.FirebaseStorage.instance
          .ref("profile")
          .putFile(file!);
      var url = response.storage.ref("profile").getDownloadURL();
      return url;
    } on firebase_storage.FirebaseException catch (e) {
      print(e);
    }
  }

  Future addUserProfileData() async {
    final url1 = await uploadImage(file: _image);
    FirebaseFirestore.instance
        .collection("User1")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": _email.text,
      "username": _userName.text,
      "url1": url1
    }).then((value) => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NotesScreen(),
              ),
            ));
  }

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
                      "Sign Up",
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: ClipOval(
                            child: _image == null
                                ? Icon(
                                    Icons.person_outline,
                                    size: 40,
                                  )
                                : Image.file(
                                    _image!,
                                    fit: BoxFit.fill,
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      FadeInDown(
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
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
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                        hintText: "Email",
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Colors.grey.shade200),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: _userName,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                        hintText: "Username",
                                        border: InputBorder.none),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  child: TextFormField(
                                    controller: _password,
                                    validator: (value) {
                                      RegExp regex = RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                      if (!regex.hasMatch(value!)) {
                                        return "Enter valid password";
                                      }
                                    },
                                    keyboardType: TextInputType.visiblePassword,
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
                      FadeInDown(
                        child: GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              FirebaseAuthService.registerUser(
                                      email: _email.text,
                                      password: _password.text)
                                  .then(
                                (user) {
                                  if (user != null) {
                                    print("$user");
                                    print(
                                        "${FirebaseAuth.instance.currentUser}");

                                    // FirebaseFirestore.instance
                                    //     .collection("Users")
                                    //     .doc(FirebaseAuth
                                    //         .instance.currentUser!.uid)
                                    //     .set({
                                    //   'email': _email.text,
                                    //   'password': _password.text
                                    // });
                                    addUserProfileData();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("User Already Exist")));
                                  }
                                },
                              );
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 50),
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade900,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Center(
                              child: Text(
                                "Sign Up",
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
                      const SizedBox(
                        height: 20,
                      ),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       FacebookAuthServices.facebookLogin().then(
                      //         (value) => Navigator.pushReplacement(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => NotesScreen(),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //     child: Text("continue with Facebook")),

                      GestureDetector(
                        onTap: () {
                          FacebookAuthServices.facebookLogin().then(
                            (value) => Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotesScreen(),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              "facebook",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
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
