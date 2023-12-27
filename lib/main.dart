import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/auth_services.dart';
import 'package:flutter_app/provider/service_provider.dart';
import 'package:flutter_app/provider/todo_provider.dart';
import 'package:flutter_app/res/app_color.dart';
import 'package:flutter_app/res/app_theme.dart';
import 'package:provider/provider.dart';

import 'screens/login_page.dart';
import 'screens/todo_list_page.dart';

///entry app to project
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoginDesign());
}

class LoginDesign extends StatelessWidget {
  double iconSize = 100;
  int durationTime = 3000;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServiceProvider()),
        ChangeNotifierProvider(create: (_) => TodoServiceProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appTheme(),
        home: _loadHome(),
      ),
    );
  }

  Widget _loadHome() {
    return SafeArea(
      child: Scaffold(
        body: AnimatedSplashScreen(
          duration: durationTime,
          splash: new Image.asset('assets/Spinner.gif'),
          splashTransition: SplashTransition.slideTransition,
          backgroundColor: AppColor.kScaffoldBackColor,
          splashIconSize: iconSize,
          nextScreen:
              AuthService().authAuthUser() == null ? LoginPage() : TodoHome(),
        ),
      ),
    );
  }
}
