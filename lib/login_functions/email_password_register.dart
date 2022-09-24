import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/login_page.dart';

onRegisterUser(
    BuildContext context, String inputEmail, String inputPassword) async {
  try {
    final response = await auth.createUserWithEmailAndPassword(
        email: inputEmail, password: inputPassword);

    if (response.user!.uid.isNotEmpty) {
      todoToast('Register Successful');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      return todoModelBox(context, "User registered failed");
    }
  } on FirebaseAuthException catch (ex) {
    if (ex.message == noInternetError) {
     return todoModelBox(context, 'No Internet Available');
    }
  } catch (e) {
    return todoModelBox(context, '${e.toString()}');
  }
}
