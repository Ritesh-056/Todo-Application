import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/components/signUpPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'task.dart';

//flutter packages importing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginPage.dart';


  const text_color_white = Colors.white;
  const padding_number = 8.0;

   Color colorsName = Colors.green[500];
   Color colorsNameLess = Colors.green[600];




  // this is main methods for
Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginDesign());
}


  class LoginDesign extends StatelessWidget {

    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
         theme: ThemeData(
           primarySwatch: Colors.green,
             fontFamily: 'Monotype Coursiva',   //3, //3
         ),
          home:new SafeArea(
            child: AnimatedSplashScreen(
                duration: 3000,
                splash: new Image.asset('assets/Spinner.gif'),
                splashTransition: SplashTransition.slideTransition,
                backgroundColor:text_color_white,
                nextScreen: new LoginPage(),
                splashIconSize: 100,

            ),
          )

      );
    }
  }

