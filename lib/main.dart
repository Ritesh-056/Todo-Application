import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/loginRegister/signUpPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'showDetails/showTask.dart';

//flutter packages importing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginRegister/loginPage.dart';

const text_color_white = Colors.white;
const padding_number = 8.0;

Color colorsName = Colors.green[500];
Color colorsNameLess = Colors.green[600];

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
          primarySwatch: Colors.green,
          fontFamily: 'Monotype Coursiva', //3, //3
        ),
        home: new SafeArea(
          child: Scaffold(
            body: AnimatedSplashScreen(
              duration: 3000,
              splash: new Image.asset('assets/Spinner.gif'),
              splashTransition: SplashTransition.slideTransition,
              backgroundColor: text_color_white,
              // nextScreen: new LoginPage(),
              splashIconSize: 100,
              nextScreen: auth.currentUser?.uid == null
                  ? LoginPage()
                  : TodoHome(email: auth.currentUser.email, password: null),
            ),
          ),
        ));
  }
}

///in checkAuth class your were not returning anything but it is expected to return a widget.
///Ritesh sir, you created a StateLessWidget just to check the condition which could have been done
///by using simple ternary operator as shown above
// class CheckAuth extends StatelessWidget {
//   var auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context) {
//     if (auth.currentUser?.uid == null) {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (context) => LoginPage()));
//     } else {
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => TodoHome(
//                     email: auth.currentUser.email,
//                     password: null,
//                   )));
//     }
//   }
// }
