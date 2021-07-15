import 'package:flutter/material.dart';


showAlertDialog(BuildContext context){
  var alert =  new AlertDialog(
    title: Text('Invalid input..!'),
    content: Text('Please check the email & Password'),
    actions: [
      new FlatButton(
        child: Text('Yes'),
        onPressed: (){
          Navigator.of(context).pop();
        },
      )
    ],
  );

  showDialog(
      context: context,
      builder: (context){
        return alert;
      });
}