import 'package:flutter/material.dart';
import 'package:flutter_app/screens/insert_task.dart';

import '../../res/app_color.dart';

Widget floatActionBtn(BuildContext context, {bool custom = false}) {
  return custom
      ? FloatingActionButton(
          child: Icon(Icons.add),
          tooltip: 'Add task',
          backgroundColor: AppColor.kPrimaryAppColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskHome(),
              ),
            );
          },
        )
      : FloatingActionButton(
          child: Icon(Icons.close),
          backgroundColor: AppColor.kPrimaryAppColor,
          onPressed: () {
            Navigator.pop(context);
          },
        );
}

Widget todoBtn(BuildContext context, String btnPerformingName) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: new Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.kPrimaryAppColor,
      ),
      child: Center(
          child: Text(
        btnPerformingName,
        style: TextStyle(
          color: AppColor.kPrimaryAppTextColor,
          fontSize: 16,
        ),
      )),
    ),
  );
}
