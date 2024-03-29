import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/res/app_color.dart';
import 'package:provider/provider.dart';

import '../provider/todo_provider.dart';
import '../res/app_string.dart';
import '../shared/widgets/widgets.dart';
import '../utils/utils.dart';

class UpdateTodoData extends StatefulWidget {
  final title;
  final date;
  final docsId;

  UpdateTodoData({
    required this.title,
    required this.date,
    required this.docsId,
  });

  @override
  State<UpdateTodoData> createState() => _UpdateTodoDataState();
}

class _UpdateTodoDataState extends State<UpdateTodoData> {
  TextEditingController _titleUpdatingController = TextEditingController();
  TextEditingController _dateUpdatingController = TextEditingController();
  CollectionReference? collectionReference;

  @override
  void initState() {
    _titleUpdatingController.text = widget.title;
    _dateUpdatingController.text = widget.date;
    super.initState();
  }

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
            child: positionedChildren(),
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
                todoTitleField(),
                todoDateTimePicker(),
                SizedBox(
                  height: 20,
                ),
                new GestureDetector(
                  onTap: () {
                    if (_titleUpdatingController.text.isEmpty)
                      return todoModelBox(context, AppStr.titleTodoError);
                    if (_dateUpdatingController.text.isEmpty)
                      return todoModelBox(context, AppStr.dateAndTimeTodoError);
                    todoServiceProvider.updateTodoItems(
                      context,
                      widget.docsId,
                      _titleUpdatingController.text,
                      _dateUpdatingController.text,
                    );
                  },
                  child: todoBtn(context, "Update"),
                )
              ],
            ),
          )
        ]),
      ),
    ));
  }

  Widget positionedChildren() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: new Text(
        'Update your Task',
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

  Widget todoTitleField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        cursorColor: AppColor.kPrimaryAppColor,
        controller: _titleUpdatingController,
        decoration:
            InputDecoration(hintText: "Insert Task", border: InputBorder.none),
      ),
    );
  }

  Widget todoDateTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColor.kPrimaryAppColor!,
          ),
        ),
        child: DateTimePicker(
          cursorColor: AppColor.kPrimaryAppColor,
          type: DateTimePickerType.dateTime,
          dateMask: 'd MMM, yyyy',
          firstDate: DateTime(2000),
          controller: _dateUpdatingController,
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
    _titleUpdatingController.dispose();
    _titleUpdatingController.dispose();
    super.dispose();
  }
}
