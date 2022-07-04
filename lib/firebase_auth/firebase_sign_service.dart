import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  static Future<User?> registerUser(
      {required String email, required String password}) async {
    try {
      User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password))
          .user;
      if (user != null) {
        log("signUp sucessfully");
        return user;
      } else {
        log("signUp Faild");
      }
    } on FirebaseException catch (e) {
      log("$e");
    }
    return null;
  }

  static Future<User?> loginUser(
      {required String email, required String password}) async {
    User? user = (await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password))
        .user;
    if (user != null) {
      log("Login Succsesfully");
      return user;
    } else {
      log("Login Faild");
    }
    return null;
  }
}
