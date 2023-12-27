import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/shared/widgets/alert_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../auth_services.dart';
import '../res/app_string.dart';
import '../screens/login_page.dart';
import '../screens/todo_list_page.dart';

import '../utils/utils.dart';

class ServiceProvider extends ChangeNotifier {
  bool signInGoogleLoading = false;
  bool signInEmailLoading = false;
  bool registerLoading = false;
  bool isObscurePassword = true;

  void changePasswordVisibility() {
    isObscurePassword = !isObscurePassword;
    notifyListeners();
  }

  ///google signIn
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
          context,
          MaterialPageRoute(
            builder: (context) => TodoHome(),
          ),
        );
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

  ///email and password login
  Future<void> emailLogin(
    BuildContext context,
    String inputEmail,
    String inputPassword,
  ) async {
    try {
      signInEmailLoading = true;
      notifyListeners();
      final response = await AuthService().auth.signInWithEmailAndPassword(
            email: inputEmail,
            password: inputPassword,
          );
      if (response.user!.uid.isNotEmpty) {
        signInEmailLoading = false;
        notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TodoHome(),
          ),
        );
      } else {
        signInEmailLoading = false;
        notifyListeners();
        return todoModelBox(context, 'Login failed');
      }
    } on FirebaseAuthException catch (ex) {
      signInEmailLoading = false;
      notifyListeners();
      if (ex.message == AppStr.noInternetErrorStr) {
        return todoModelBox(context, 'No Internet Available');
      }
    } catch (e) {
      signInEmailLoading = false;
      notifyListeners();
      return todoModelBox(context, '${e.toString()}');
    }
  }

  ///register a new user
  Future<void> registerUser(
      BuildContext context, String inputEmail, String inputPassword) async {
    try {
      registerLoading = true;
      notifyListeners();
      final response = await AuthService().auth.createUserWithEmailAndPassword(
            email: inputEmail,
            password: inputPassword,
          );

      if (response.user!.uid.isNotEmpty) {
        registerLoading = false;
        notifyListeners();
        todoToast('Register Successful');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        registerLoading = false;
        notifyListeners();
        return todoModelBox(context, "User registered failed");
      }
    } on FirebaseAuthException catch (ex) {
      registerLoading = false;
      notifyListeners();
      if (ex.message == AppStr.noInternetErrorStr) {
        return todoModelBox(context, 'No Internet Available');
      }
    } catch (e) {
      registerLoading = false;
      notifyListeners();
      return todoModelBox(context, '${e.toString()}');
    }
  }

  ///send recovery email
  void sendRecoveryEmail(BuildContext context, String inputEmail) async {
    try {
      await AuthService().auth.sendPasswordResetEmail(email: inputEmail);
      showAlertPasswordDialog(context);
    } on FirebaseAuthException catch (ex) {
      if (ex.message == AppStr.noInternetErrorStr) {
        todoModelBox(context, 'No Internet Available');
      }
    } catch (e) {
      todoModelBox(context, '${e.toString()}');
    }
  }
}
