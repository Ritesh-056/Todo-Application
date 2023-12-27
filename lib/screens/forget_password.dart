import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/functions/dart/create_new_password.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/res/app_color.dart';
import 'package:flutter_app/res/app_string.dart';
import 'package:flutter_app/widgets/reusable_widgets.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  var _emailController = new TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      floatingActionButton: floatActionBtn(context),
      body: Center(
        child: SafeArea(
          child: new Stack(fit: StackFit.passthrough, children: [
            Positioned(
              top: -80.0,
              left: 20,
              right: 20,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: new Text(
                  'Forget your Password?',
                  style: TextStyle(
                      color: AppColor.kPrimaryAppColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Positioned(
              top: -48.0,
              left: 60,
              right: 60,
              child: Divider(
                thickness: 3,
                color: AppColor.kPrimaryAppColor,
              ),
            ),
            new SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: new Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white70,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 0,
                          offset: Offset(3, 4) // changes position of shadow
                          ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Email',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: new TextField(
                          style: TextStyle(fontSize: 14),
                          controller: _emailController,
                          decoration: InputDecoration(
                              hintText: "******@gmail.com",
                              border: InputBorder.none,
                              fillColor: Color(0xfff3f1f1),
                              filled: true),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new GestureDetector(
                        onTap: validateEmail,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: new Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: AppColor.kPrimaryAppColor,
                            ),
                            child: Center(
                                child: Text(
                              'Send',
                              style: TextStyle(
                                  color: AppColor.kPrimaryAppTextColor,
                                  fontSize: 14),
                            )),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppStr.forgetPasswordStr,
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ]),
        ),
      ),
    ));
  }

  void validateEmail() {
    if (_emailController.text.isEmpty) {
      todoModelBox(context, 'Please, make sure you have inserted email.');
    } else {
      sendRecoveryEmail(context, _emailController.text);
    }
  }
}
