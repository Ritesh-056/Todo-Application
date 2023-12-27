import 'package:flutter/material.dart';

class CustomScreenShape extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    double height = size.height;
    double width  = size.width;

    var path = Path();
    path.lineTo(0, height);
    path.lineTo(width, height);
    path.lineTo(width, 0);


    //initial control points
    var firstControlPoint = Offset(0, 0);
    var sendEndControlPoint = Offset(width * .2, height * .3);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        sendEndControlPoint.dx, sendEndControlPoint.dy);


    //middle control points
    var middleControlPoint = Offset(width * .3, height * .5);
    var middleEndControlPoint = Offset(width * .23, height * .6);
    path.quadraticBezierTo(middleControlPoint.dx, middleControlPoint.dy,
        middleEndControlPoint.dx, middleEndControlPoint.dy);


    //last control points
    var lastControlPoint = Offset(0, height);
    var lastEndControlPoint = Offset(width, height);
    path.quadraticBezierTo(lastControlPoint.dx, lastControlPoint.dy,
        lastEndControlPoint.dx, lastEndControlPoint.dy);

    path.lineTo(0, size.height);
    path.close();

    return path ;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }


}