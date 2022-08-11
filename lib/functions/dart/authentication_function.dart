

//function to login user from google
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:google_sign_in/google_sign_in.dart';



signInWithGoogle(BuildContext context) async {

  bool isLoading ;

  try{
    final GoogleSignInAccount googleUser = await (GoogleSignIn().signIn() as FutureOr<GoogleSignInAccount>);
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await auth.signInWithCredential(credential);

    if (auth.currentUser!.uid != null) {
      // setState(() {
      //   isLoading = false;
      // });
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TodoHome(email: auth.currentUser!.email, password: null)));
    }
  } on FirebaseAuthException catch(ex){
    // setState(() {
    //   isLoading = false;
    // });
    print("==========Error[FirebaseAuth]=============");

    print('${ex.message}');
    todoModelBox(context,'${ex.message}');

  }
  catch(e){
    // setState(() {
    //   isLoading = false;
    // });
    print("==========Error[catch]=============");
    String errorResult = 'PlatformException(network_error, com.google.android.gms.common.api.ApiException: 7: , null, null)';
    if( e.toString() == errorResult){
      print('No internet Available');
      return todoModelBox(context,'No Internet Available');
    }
    print('${e.toString()}');
    todoModelBox(context,'${e.toString()}');
  }
}