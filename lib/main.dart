import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
//flutter packages importing
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/generic_function_provider.dart';
import 'package:flutter_app/provider/password_field_checker.dart';
import 'package:provider/provider.dart';

import 'const.dart';
import 'screens/login_page.dart';
import 'screens/todo_list_screen.dart';

var auth = FirebaseAuth.instance;
BuildContext? mContext;

// this is main methods for
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PasswordVisibility()),
      ChangeNotifierProvider(create: (context) => GenericHelperProvider()),
    ],
    child: LoginDesign(),
  ));
}

class LoginDesign extends StatelessWidget {
  double iconSize = 100;
  int durationTime = 3000;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorsName,
        iconTheme: new IconThemeData(color: colorsName),
        fontFamily: 'Monotype Coursiva',
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: colorsName), //3, //3
      ),
      home: LoadHome(),
    );
  }

  Widget LoadHome() {
    return SafeArea(
      child: Scaffold(
        body: AnimatedSplashScreen(
          duration: durationTime,
          splash: new Image.asset('assets/Spinner.gif'),
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: text_color_white,
          splashIconSize: iconSize,
          nextScreen: auth.currentUser?.uid == null ? LoginPage() : TodoHome(),
        ),
      ),
    );
  }
}
