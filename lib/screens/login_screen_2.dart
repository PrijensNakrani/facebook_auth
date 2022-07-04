import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../firebase_auth/facebook_auth.dart';
import '../firebase_auth/firebase_sign_service.dart';

class LoginScreen2 extends StatefulWidget {
  const LoginScreen2({Key? key}) : super(key: key);

  @override
  State<LoginScreen2> createState() => _LoginScreen2State();
}

class _LoginScreen2State extends State<LoginScreen2> {
  final _firsName = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FadeInDown(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.r),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
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
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200),
                                ),
                              ),
                              child: TextFormField(
                                controller: _firsName,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "must be not empty";
                                  }
                                },
                                decoration: const InputDecoration(
                                  hintText: "First name",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade200),
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
                              margin: EdgeInsets.symmetric(horizontal: 15.w),
                              child: TextFormField(
                                controller: _password,
                                validator: (value) {
                                  RegExp regex = RegExp(
                                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
                                  if (!regex.hasMatch(value!)) {
                                    return "Enter valid password";
                                  }
                                },
                                textInputAction: TextInputAction.done,
                                decoration: const InputDecoration(
                                  hintText: "Password",
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40.h),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        FirebaseAuthService.registerUser(
                                email: _email.text, password: _password.text)
                            .then(
                          (user) {
                            if (user != null) {
                              print("$user");
                              print("${FirebaseAuth.instance.currentUser}");

                              // FirebaseFirestore.instance
                              //     .collection("Users")
                              //     .doc(FirebaseAuth
                              //         .instance.currentUser!.uid)
                              //     .set({
                              //   'email': _email.text,
                              //   'password': _password.text
                              // });

                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text("User Already Exist")));
                            }
                          },
                        );
                      }
                    },
                    child: FadeInDown(
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        FacebookAuthServices.facebookLogin();
                      },
                      child: Text("continue with Facebook"))
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
