import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/showDetails/showTask.dart';

onEmailPasswordLogin(
    BuildContext context, String inputEmail, String inputPassword) async {
  try {
    final response = await auth.signInWithEmailAndPassword(
        email: inputEmail, password: inputPassword);
    if (response.user!.uid.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TodoHome(email: auth.currentUser!.email, password: null)));
    } else {
      todoModelBox(context, 'Login failed');
    }
  } on FirebaseAuthException catch (ex) {
    if (ex.message == noInternetError) {
      todoModelBox(context, 'No Internet Available');
    }
  } catch (e) {
    todoModelBox(context, '${e.toString()}');
  }
}
