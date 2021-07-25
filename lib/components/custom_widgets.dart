import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

//  custom text
Widget _text( title, size,color,weight){
  return Text(
    title,
    style:TextStyle(
        fontSize: size,
        color:color,
        fontWeight: weight
    ),
  );

}
