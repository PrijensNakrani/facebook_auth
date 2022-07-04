import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

/// Facebook LogIn method///

class FacebookAuthServices {
  static Future facebookLogin() async {
    try {
      final result =
          await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
      if (result.status == LoginStatus.success) {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await FirebaseAuth.instance.signInWithCredential(facebookCredential);
        final userData = await FacebookAuth.i.getUserData();
        print(userData);
        print(userData['name']);
        print(userData['email']);
        print(userData['url']);
      }
    } catch (error) {
      print(error);
    }
  }
}
