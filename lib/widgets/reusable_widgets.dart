import 'package:flutter/material.dart';
import 'package:flutter_app/screens/insert_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const.dart';

Widget TodoFloatingActionButton(BuildContext context, {bool custom = false}) {
 return custom ?  FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add task',
          backgroundColor: colorsName,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddTaskHome()));
          },
        )
      :  FloatingActionButton(
          child: Icon(Icons.close),
          backgroundColor: colorsName,
          onPressed: () {
            Navigator.pop(context);
          },
        );
}
