import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';


showAlertDialog(BuildContext context){
  var alert =  new AlertDialog(
    title: Center(child: Text('Invalid input..!',style: TextStyle(color: colorsName, fontWeight: FontWeight.w600),)),
    content: Text('Please check the email & Password',style: TextStyle(color: colorsName,fontWeight: FontWeight.w400)),
    actions: [
      new FlatButton(
        child: Text('Okay',style: TextStyle(color: colorsName,fontWeight: FontWeight.w500)),
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