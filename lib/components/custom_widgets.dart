import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';



//  custom text

 _text( title, size,color,weight){
  var text = Text(
    title,
    style:TextStyle(
        fontSize: size,
        color:color,
        fontWeight: weight
    ),
  );
  return text;
}
