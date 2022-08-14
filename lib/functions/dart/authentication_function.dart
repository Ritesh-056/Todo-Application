//function to login user from google
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/provider/generic_function_provider.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

signInWithGoogle(BuildContext context) async {


  try {

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    final response = await auth.signInWithCredential(credential);

    if (response.user!.uid.isNotEmpty) {
      Provider.of<GenericHelperProvider>(context).checkLoading = false;
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TodoHome(email: auth.currentUser!.email, password: null)));
    } else {
      todoModelBox(context, 'Google login failed');
      Provider.of<GenericHelperProvider>(context).checkLoading = false;
    }


  } on FirebaseAuthException catch (ex) {
    if (ex.message == noInternetError) {
      todoModelBox(context, 'No Internet Available');
    }
  } catch (ex) {
    todoModelBox(context, '${ex.toString()}');
  }
}
