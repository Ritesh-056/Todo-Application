import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provider/todo_provider.dart';
import 'package:flutter_app/res/app_string.dart';
import 'package:provider/provider.dart';

import '../res/app_color.dart';
import '../shared/widgets/widgets.dart';
import '../utils/utils.dart';

class AddTaskHome extends StatefulWidget {
  @override
  _AddTaskHomeState createState() => _AddTaskHomeState();
}

class _AddTaskHomeState extends State<AddTaskHome> {
  TextEditingController _titleInsertController = TextEditingController();
  TextEditingController _dateInsertController = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  var collectionReferences = FirebaseFirestore.instance.collection('todos');

  @override
  Widget build(BuildContext context) {
    final todoServiceProvider = Provider.of<TodoServiceProvider>(context);
    return new SafeArea(
      child: Scaffold(
        floatingActionButton: floatActionBtn(context),
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
                color: AppColor.kPrimaryAppColor,
              ),
            ),
            new Container(
              height: 230,
              width: 330,
              decoration: todoContainerDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: new TextField(
                      cursorColor: AppColor.kPrimaryAppColor,
                      restorationId: "email_id",
                      controller: _titleInsertController,
                      decoration: InputDecoration(
                          hintText: "Insert Task", border: InputBorder.none),
                    ),
                  ),
                  widgetDateTimePicker(),
                  SizedBox(
                    height: 20,
                  ),
                  new GestureDetector(
                    onTap: () {
                      if (_titleInsertController.text.isEmpty)
                        return todoModelBox(context, AppStr.titleTodoError);
                      if (_dateInsertController.text.isEmpty)
                        return todoModelBox(
                            context, AppStr.dateAndTimeTodoError);
                      todoServiceProvider.onCreateNewTodo(
                        context,
                        _titleInsertController.text,
                        _dateInsertController.text,
                      );
                    },
                    child: todoBtn(context, "Add Task"),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget positionWrapperFirst() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: new Text(
        'Assign your Task',
        style: TextStyle(
            color: AppColor.kPrimaryAppColor,
            fontSize: 18,
            fontWeight: FontWeight.bold),
      )),
    );
  }

  BoxDecoration todoContainerDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: AppColor.kPrimaryAppColor!, width: 1.25),
      color: Colors.white70,
    );
  }

  Widget widgetDateTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.kPrimaryAppColor!,
          ),
        ),
        child: DateTimePicker(
          controller: _dateInsertController,
          cursorColor: AppColor.kPrimaryAppColor,
          type: DateTimePickerType.dateTimeSeparate,
          dateMask: 'd MMM, yyyy',
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          icon: Icon(
            Icons.event,
            color: AppColor.kPrimaryAppColor,
            size: 30,
          ),
          dateLabelText: 'Date',
          timeLabelText: "Hour",
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleInsertController.dispose();
    _dateInsertController.dispose();
    super.dispose();
  }
}
