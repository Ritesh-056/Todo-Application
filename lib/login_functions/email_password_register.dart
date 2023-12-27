import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth_services.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/screens/login_page.dart';

import '../res/app_string.dart';

onRegisterUser(
    BuildContext context, String inputEmail, String inputPassword) async {
  try {
    final response = await AuthService().auth.createUserWithEmailAndPassword(
        email: inputEmail, password: inputPassword);

    if (response.user!.uid.isNotEmpty) {
      todoToast('Register Successful');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      return todoModelBox(context, "User registered failed");
    }
  } on FirebaseAuthException catch (ex) {
    if (ex.message == AppStr.noInternetErrorStr) {
      return todoModelBox(context, 'No Internet Available');
    }
  } catch (e) {
    return todoModelBox(context, '${e.toString()}');
  }
}
