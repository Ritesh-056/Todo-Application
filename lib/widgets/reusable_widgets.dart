import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const.dart';

Widget TodoFloatingActionButton(BuildContext context) => FloatingActionButton(
      child: Icon(Icons.close),
      backgroundColor: colorsName,
      onPressed: () {
        Navigator.pop(context);
      },
    );


