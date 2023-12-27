import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/screens/todo_list_screen.dart';

import '../auth_services.dart';
import '../res/app_string.dart';

onEmailPasswordLogin(
    BuildContext context, String inputEmail, String inputPassword) async {
  try {
    final response = await AuthService()
        .auth
        .signInWithEmailAndPassword(email: inputEmail, password: inputPassword);
    if (response.user!.uid.isNotEmpty) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TodoHome()));
    } else {
      return todoModelBox(context, 'Login failed');
    }
  } on FirebaseAuthException catch (ex) {
    if (ex.message == AppStr.noInternetErrorStr) {
      return todoModelBox(context, 'No Internet Available');
    }
  } catch (e) {
    return todoModelBox(context, '${e.toString()}');
  }
}
