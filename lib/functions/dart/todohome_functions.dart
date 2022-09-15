import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/const.dart';
import 'package:flutter_app/functions/dart/reusable_functions.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/login_page.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn();

void funcSignOut(BuildContext context) {
  //sign out functions
  _signOutFirebase(context);
  _signOutGoogle(context);

  todoToast('Log out Successful');
}

Future<LoginPage?> _signOutFirebase(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
}

Future<LoginPage?> _signOutGoogle(BuildContext context) async {
  await _googleSignIn.signOut();
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginPage()));
}

void funcExit() {
  exit(0);
}

Future<void> SelectedItem(BuildContext context, item) async {
  switch (item) {
    case 0:
      colorPickerAlertDialog(context);
      break;

    case 1:
      if (auth.currentUser?.uid != null) {
        showAlertDialog(context, "Are you sure want to logout?", "Log out",
            "Log out", funcSignOut);
      } else {
        print("No user found...!");
      }
      break;

    case 2:
      showAlertDialog(
          context,
          "Are you sure want to exit ? App will close instantly.",
          "Exit",
          "Exit App",
          funcExit);
      break;
  }
}

colorPickerAlertDialog(BuildContext context) {
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
      child: Text(
        'Pick Your Color',
        style: TextStyle(fontSize: 13),
      ),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ColorPicker(
          // showLabel: false,
          pickerColor: colorsName!,
          showLabel: false,
          labelTextStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          pickerAreaHeightPercent: 0.5,
          onColorChanged: (colors) {
            colorsName = colors;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          child: Text(
            'SELECT',
            style: TextStyle(fontSize: 13),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

showAlertDialog(BuildContext context, alertTitle, doneButton, alertMainTitle,
    callBackMethod) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel", style: TextStyle(color: colorsName)),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text(doneButton, style: TextStyle(color: colorsName)),
    onPressed: callBackMethod,
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
      child: Text(
        alertMainTitle,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    content: Text(
      alertTitle,
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

Widget showLoadingPlaceHolder() => Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  color: colorsName,
                ),
              ),
              Text('Loading..!'),
            ],
          ),
        ),
      ),
    );

Widget showEmptyPlaceHolder() {
  return Center(
    child: Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.hourglass_empty_outlined,
              color: colorsName,
              size: 50,
            ),
            Text('Empty data..!'),
          ],
        ),
      ),
    ),
  );
}
