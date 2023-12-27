import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth_services.dart';
import '../functions/dart/reusable_functions.dart';
import '../res/app_string.dart';
import '../screens/todo_list_screen.dart';

class GenericHelperProvider extends ChangeNotifier {
  bool signInGoogleLoading = false;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      signInGoogleLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final response =
          await AuthService().auth.signInWithCredential(credential);

      if (response.user!.uid.isNotEmpty) {
        signInGoogleLoading = false;
        notifyListeners();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TodoHome()));
      } else {
        signInGoogleLoading = false;
        notifyListeners();
        todoModelBox(context, 'Google login failed');
      }
    } on FirebaseAuthException catch (ex) {
      signInGoogleLoading = false;
      notifyListeners();
      print("Error on firebase auth exception: $ex");

      if (ex.message == AppStr.noInternetErrorStr) {
        todoModelBox(context, 'No Internet Available');
      }
    } catch (ex) {
      signInGoogleLoading = false;
      notifyListeners();
      print("Error: $ex");
      todoModelBox(context, '${ex.toString()}');
    }
  }
}
