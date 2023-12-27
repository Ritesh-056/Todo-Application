import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/service_provider.dart';
import '../res/app_color.dart';
import '../shared/geometry/geometric_container.dart';
import '../utils/utils.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserCredential>? userCredential;

  var _emailController = new TextEditingController();
  var _passwordController = new TextEditingController();
  var _userNameController = new TextEditingController();

  String registerEmail = "";
  String registerPassword = "";
  String registerUsername = "";

  bool securePass = true;
  var count = 0;
  Icon icon = Icon(
    Icons.visibility_off_outlined,
    color: AppColor.kPrimaryAppColor,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: AppColor.kPrimaryAppColor,
                size: 40,
              ),
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 15,
                    color: AppColor.kPrimaryAppColor,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(
    String title,
    String tracker, {
    ServiceProvider? serviceProvider,
  }) {
    Widget _checkField() {
      if (tracker == "e") {
        return new TextField(
            cursorColor: AppColor.kPrimaryAppColor,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.email_outlined,
                  color: AppColor.kPrimaryAppColor,
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f6),
                filled: true));
      } else if (tracker == "p") {
        return new TextField(
            cursorColor: AppColor.kPrimaryAppColor,
            obscureText: serviceProvider!.isObscurePassword,
            controller: _passwordController,
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
                    onPressed: () {
                      serviceProvider.changePasswordVisibility();
                    },
                  ),
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f6),
                filled: true));
      } else {
        return new TextField(
          cursorColor: AppColor.kPrimaryAppColor,
          controller: _userNameController,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.account_circle_outlined,
              color: AppColor.kPrimaryAppColor,
            ),
            border: InputBorder.none,
            fillColor: Color(0xfff5f5f6),
            filled: true,
          ),
        );
      }
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          _checkField(),
        ],
      ),
    );
  }

  Widget _submitButton(ServiceProvider serviceProvider) =>
      serviceProvider.registerLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GestureDetector(
              onTap: () => validInputEmailPasswordToRegister(serviceProvider),
              child: Container(
                height: 45,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.5),
                  color: AppColor.kPrimaryAppColor,
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text(
                'Login',
                style: TextStyle(
                    color: AppColor.kPrimaryAppColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'Register',
      style: TextStyle(
        color: AppColor.kPrimaryAppColor,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _emailPasswordWidget(ServiceProvider serviceProvider) {
    return Column(
      children: <Widget>[
        _entryField("Username", "u"),
        _entryField("Email ", "e"),
        _entryField("Password", "p", serviceProvider: serviceProvider),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final serviceProvider = Provider.of<ServiceProvider>(context);

    return new SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: ScreenGeometricCurve(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),
                      _emailPasswordWidget(serviceProvider),
                      SizedBox(
                        height: 20,
                      ),
                      _submitButton(serviceProvider),
                      SizedBox(height: 32),
                      _loginAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: _backButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void validInputEmailPasswordToRegister(ServiceProvider serviceProvider) {
    if (_emailController.text.isEmpty) {
      return todoModelBox(context, 'please insert email');
    }
    if (_passwordController.text.isEmpty) {
      return todoModelBox(context, 'please insert password');
    } else {
      //register user
      serviceProvider.registerUser(
        context,
        _emailController.text,
        _passwordController.text,
      );
    }
  }
}
