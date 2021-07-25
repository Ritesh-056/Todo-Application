import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/loginRegister/signUpPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'showDetails/showTask.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

//flutter packages importing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginRegister/loginPage.dart';

const text_color_white = Colors.white;
const padding_number = 8.0;

Color colorsName = Colors.green[500];


// this is main methods for
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginDesign());
}



class LoginDesign extends StatelessWidget {
  var auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: colorsName,
          fontFamily: 'Monotype Coursiva', //3, //3
        ),
        home: new SafeArea(
          child: Scaffold(
            body: AnimatedSplashScreen(
              duration: 3000,
              splash: new Image.asset('assets/Spinner.gif'),
              splashTransition: SplashTransition.slideTransition,
              backgroundColor: text_color_white,
              splashIconSize: 100,
              nextScreen: auth.currentUser?.uid == null
                  ? LoginPage()
                  : TodoHome(email: auth.currentUser.email, password: null),
            ),
          ),
        ),
    );
  }
}

