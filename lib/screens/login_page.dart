import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/service_provider.dart';
import 'package:flutter_app/screens/forget_password.dart';
import 'package:flutter_app/screens/sign_up_page.dart';
import 'package:provider/provider.dart';

import '../res/app_color.dart';
import '../shared/geometry/geometric_container.dart';
import '../utils/utils.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                color: AppColor.kPrimaryAppColor,
              ),
            ),
            Positioned(
              top: -height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              // child: BezierContainer()
              child: ScreenGeometricCurve(),
            ),
            _buildLogin(height),
          ],
        ),
      )),
    );
  }

  Widget _buildLogin(double height) {
    final serviceProvider = Provider.of<ServiceProvider>(context);
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
                  color: AppColor.kPrimaryAppColor,
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
              cursorColor: AppColor.kPrimaryAppColor,
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: AppColor.kPrimaryAppColor,
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff5f5f6),
                  hoverColor: AppColor.kPrimaryAppColor,
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
              cursorColor: AppColor.kPrimaryAppColor,
              controller: _passwordController,
              obscureText: serviceProvider.isObscurePassword,
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.lock_outlined,
                    color: AppColor.kPrimaryAppColor,
                  ),
                  suffixIcon: Consumer<ServiceProvider>(
                    builder: (context, serviceProvider, child) => IconButton(
                      icon: Icon(
                        serviceProvider.isObscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColor.kPrimaryAppColor,
                      ),
                      color: AppColor.kPrimaryAppColor,
                      onPressed: () =>
                          serviceProvider.changePasswordVisibility(),
                    ),
                  ),
                  border: InputBorder.none,
                  fillColor: Color(0xfff5f5f6),
                  filled: true),
            ),
            SizedBox(
              height: 50,
            ),

            serviceProvider.signInEmailLoading
                ? Center(child: CircularProgressIndicator())
                : InkWell(
                    onTap: () => validInputEmailPassword(serviceProvider),
                    child: Container(
                      height: 45,
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
                        borderRadius: BorderRadius.circular(8.5),
                        color: AppColor.kPrimaryAppColor,
                      ),
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
                      builder: (context) => ForgetPassword(),
                    ),
                  );
                },
                child: Text('Forgot Password ?',
                    style: TextStyle(
                        fontSize: 13,
                        color: AppColor.kPrimaryAppColor,
                        fontWeight: FontWeight.w400)),
              ),
            ),
            _divider(),
            _googleSignInUI(),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                print('tapped');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SignUpPage(),
                  ),
                );
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
                          color: AppColor.kPrimaryAppColor,
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
                color: Colors.black.withOpacity(0.2),
              ),
            ),
          ),
          Text('Or Social',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.black.withOpacity(0.2),
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

  Widget _googleSignInUI() {
    final signInProvider = Provider.of<ServiceProvider>(context);

    return GestureDetector(
      onTap: () {
        signInProvider.signInWithGoogle(context);
      },
      child: Container(
        height: 45,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(187, 0, 27, 0.9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.5),
                    topLeft: Radius.circular(8.5),
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
                      bottomRight: Radius.circular(8.5),
                      topRight: Radius.circular(8.5)),
                ),
                alignment: Alignment.center,
                child: signInProvider.signInGoogleLoading
                    ? Padding(
                        padding: const EdgeInsets.only(
                            right: 32.0, top: 8, bottom: 8),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(right: 32.0),
                        child: Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validInputEmailPassword(ServiceProvider serviceProvider) {
    if (_emailController.text.isEmpty) {
      return todoModelBox(context, 'please insert email');
    }
    if (_passwordController.text.isEmpty) {
      return todoModelBox(context, 'please insert password');
    } else {
      //login with email & password
      serviceProvider.emailLogin(
        context,
        _emailController.text,
        _passwordController.text,
      );
    }
  }
}
