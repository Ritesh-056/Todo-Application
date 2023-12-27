import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../res/app_color.dart';
import '../auth_services.dart';
import '../screens/login_page.dart';

void todoToast(text) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.CENTER,
    fontSize: 16.0,
    backgroundColor: AppColor.kPrimaryAppTextColor,
  );
}

void todoModelBox(BuildContext context, String textStr) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: new Icon(
                    Icons.error,
                    size: 50,
                    color: AppColor.kPrimaryAppColor,
                  ),
                  title: new Text('Oops...!',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  subtitle: new Text(textStr,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  trailing: new IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 20,
                    color: Color.fromRGBO(20, 20, 20, 0.9),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void dialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Loading"),
          ],
        ),
      );
    },
  );
}

void colorPickerAlertDialog(BuildContext context) {
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
          pickerColor: AppColor.kPrimaryAppColor!,
          pickerAreaHeightPercent: 0.5,
          onColorChanged: (colors) {
            AppColor.kPrimaryAppColor = colors;
          },
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          child: Text(
            'Close',
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
    Function(BuildContext context) onPressAction) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text("Cancel", style: TextStyle(color: AppColor.kPrimaryAppColor)),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  Widget continueButton = TextButton(
      child:
          Text(doneButton, style: TextStyle(color: AppColor.kPrimaryAppColor)),
      onPressed: () {
        onPressAction(context);
        Navigator.pop(context);
      });

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

void funcExit(BuildContext context) {
  exit(0);
}

Future<void> selectDropDownOption(BuildContext context, item) async {
  switch (item) {
    case 0:
      colorPickerAlertDialog(context);
      break;

    case 1:
      if (AuthService().auth.currentUser?.uid != null) {
        showAlertDialog(
            context, "Are you sure want to logout?", "Log out", "Log out",
            (context) {
          funcSignOut(context);
        });
      } else {
        print("No user found...!");
      }
      break;

    case 2:
      showAlertDialog(
          context,
          "Are you sure want to exit ? App will close instantly.",
          "Exit",
          "Exit App", (context) {
        funcExit(context);
      });
      break;
  }
}
