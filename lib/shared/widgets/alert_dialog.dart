import 'package:flutter/material.dart';

import '../../res/app_color.dart';

showAlertPasswordDialog(BuildContext context) {
  // set up the buttons
  Widget okayButton = TextButton(
    child: Text(
      "Okay",
      style: TextStyle(
        color: AppColor.kPrimaryAppColor,
      ),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Center(
      child: Text(
        "Check your email",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    content: Text(
      "Please check the email for resetting the password.",
      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
    ),
    actions: [
      okayButton,
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
