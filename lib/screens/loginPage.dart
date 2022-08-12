import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/customContainer.dart';
import 'package:flutter_app/functions/dart/authentication_function.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/login_functions/email_password_login.dart';
import 'package:flutter_app/provider/generic_function_provider.dart';
import 'package:flutter_app/provider/password_field_checker.dart';
import 'package:flutter_app/screens/forget_password.dart';
import 'package:flutter_app/screens/signUpPage.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:flutter_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../const.dart';

class LoginPage extends StatefulWidget {
  // final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String loginEmail = "";
  String loginPassword = "";
  bool securePass = true;
  var count = 0;
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserCredential>? userCredential;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Icon icon = Icon(
    Icons.visibility_off_outlined,
    color: colorsName,
  );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Container(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 25,
              left: 20,
              child: Icon(
                Icons.arrow_back_ios,
                color: colorsName,
              ),
            ),

            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),

            LoginHomeContainer(height),
            // Positioned(top: 20, left: 0, child: _backButton()),
          ],
        ),
      )),
    );
  }

  Widget LoginHomeContainer(double height) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: height * .2),
            Center(
              child: Text(
                'Login',
                style: TextStyle(
                  color: colorsName,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(height: 50),
            Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              cursorColor: colorsName,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: colorsName,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff5f5f6),
                  hoverColor: colorsName,
                  filled: true),
            ),
            SizedBox(height: 20),
            Text(
              'Password',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              cursorColor: colorsName,
              controller: _passwordController,
              obscureText:
                  Provider.of<PasswordVisibility>(context).pass_visible,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: colorsName,
                  ),
                  suffixIcon: Consumer<PasswordVisibility>(
                    builder: (context, passCheck, child) => IconButton(
                      icon: passCheck.pass_visible
                          ? Icon(
                              Icons.visibility_off_outlined,
                              color: colorsName,
                            )
                          : Icon(
                              Icons.visibility_outlined,
                              color: colorsName,
                            ),
                      color: colorsName,
                      onPressed: () {
                        passCheck.enablePasswordVisibility();
                      },
                    ),
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff5f5f6),
                  filled: true),
            ),
            SizedBox(
              height: 50,
            ),

            InkWell(
              onTap: validInputEmailPassword,
              child: Container(
                height: 50,
                child: Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: colorsName, borderRadius: BorderRadius.circular(20)),
              ),
            ),

            ///submit button
            Container(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ForgetPassword()));
                },
                child: Text('Forgot Password ?',
                    style: TextStyle(
                        fontSize: 13,
                        color: colorsName,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            _divider(),
            _GoogleLoginContainer(),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                print('tapped');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUpPage()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.all(15),
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have an account ?',
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Register',
                      style: TextStyle(
                          color: colorsName,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1.5,
              ),
            ),
          ),
          Text('Social',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _GoogleLoginContainer() {
    return GestureDetector(
      onTap:(){
        Provider.of<GenericHelperProvider>(context,listen: false).onGoogleLoginPressed();
        signInWithGoogle(context);
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(187, 0, 27, 0.9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
                alignment: Alignment.center,
                child: Text('G',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(180, 0, 20, 0.9),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                alignment: Alignment.center,
                child: context.watch<GenericHelperProvider>().checkLoading
                    ? Padding(
                        padding: const EdgeInsets.only(
                            right: 32.0, top: 8, bottom: 8),
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Text('Continue with Google',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  void validInputEmailPassword(){

    if(_emailController.text.isEmpty){
      todoModelBox(context, 'please insert email');
    }
    if(_passwordController.text.isEmpty){
      todoModelBox(context, 'please insert password');
    }else{
      onEmailPasswordLogin(context,_emailController.text, _passwordController.text);
    }
  }
}
