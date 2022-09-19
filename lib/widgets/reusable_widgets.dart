import 'package:flutter/material.dart';
import 'package:flutter_app/screens/insert_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const.dart';

Widget TodoFloatingActionButton(BuildContext context, {bool custom = false}) {
  return custom
      ? FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add task',
          backgroundColor: colorsName,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTaskHome()));
          },
        )
      : FloatingActionButton(
          child: Icon(Icons.close),
          backgroundColor: colorsName,
          onPressed: () {
            Navigator.pop(context);
          },
        );
}

Widget TodoGenericButton(BuildContext context, String btnPerformingName) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: new Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorsName,
      ),
      child: Center(
          child: Text(
        btnPerformingName,
        style: TextStyle(color: text_color_white, fontSize: 16),
      )),
    ),
  );
}
