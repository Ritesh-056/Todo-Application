import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:flutter_app/widgets/reusable_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const.dart';
import '../functions/dart/reusable_functions.dart';

class AddTaskHome extends StatefulWidget {
  @override
  _AddTaskHomeState createState() => _AddTaskHomeState();
}

class _AddTaskHomeState extends State<AddTaskHome> {
  String? listItem = "";
  String? dateTimePicker = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  var documentRef = FirebaseFirestore.instance.collection('todos');

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      floatingActionButton: TodoFloatingActionButton(context),
      body: Center(
        child: new Stack(fit: StackFit.passthrough, children: [
          Positioned(
            top: -80.0,
            left: 20,
            right: 20,
            child: positionWrapperFirst(),
          ),
          Positioned(
            top: -48.0,
            left: 65,
            right: 65,
            child: Divider(
              thickness: 3,
              color: colorsName,
            ),
          ),
          new Container(
            height: 200,
            width: 330,
            decoration: boxDecoration(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: new TextField(
                      cursorColor: colorsName,
                      restorationId: "email_id",
                      decoration: InputDecoration(
                          hintText: "Insert Task", border: InputBorder.none),
                      onChanged: (value) {
                        setState(() => listItem = value);
                      }),
                ),
                widgetDateTimePicker(),
                SizedBox(
                  height: 10,
                ),
                new GestureDetector(
                  onTap: onAssignTodoMethodClicked,
                  child: Padding(
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
                        'Assign',
                        style: TextStyle(color: text_color_white, fontSize: 16),
                      )),
                    ),
                  ),
                )
              ],
            ),
          )
        ]),
      ),
    ));
  }

  Widget positionWrapperFirst() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: new Text(
        'Assign your Task',
        style: TextStyle(
            color: colorsName, fontSize: 18, fontWeight: FontWeight.bold),
      )),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: Colors.white70,
      boxShadow: [
        BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 0,
            offset: Offset(3, 4) // changes position of shadow
            ),
      ],
    );
  }

  Widget widgetDateTimePicker() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: colorsName!,
            ),
          ),
          child: DateTimePicker(
              cursorColor: colorsName,
              type: DateTimePickerType.dateTimeSeparate,
              dateMask: 'd MMM, yyyy',
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              icon: Icon(
                Icons.event,
                color: colorsName,
                size: 30,
              ),
              dateLabelText: 'Date',
              timeLabelText: "Hour",
              selectableDayPredicate: (date) {
                // Disable weekend days to select from the calendar
                if (date.weekday == 6 || date.weekday == 7) {
                  return false;
                }
                return true;
              },
              onChanged: (val) {
                setState(() => dateTimePicker = val);
              }),
        ));
  }

  void onAssignTodoMethodClicked() {
    if (listItem!.isEmpty) {
      return todoModelBox(context, "Make sure you have inserted todo item.");
    }

    if (dateTimePicker!.isEmpty) {
      return todoModelBox(
          context, "Make sure you have inserted task, date and time.");
    }

    if (auth.currentUser!.uid.isNotEmpty) {
      try {
        documentRef
            .doc(auth.currentUser!.uid)
            .collection('user_todo')
            .doc()
            .set({'title': listItem, 'date': dateTimePicker});

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TodoHome(
                     )));

        todoToast('Added Successfully');
      } catch (ex) {
        log("Exception while insert ${ex.toString()}");
      }
    }
  }
}
