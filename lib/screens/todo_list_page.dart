import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/res/app_color.dart';
import 'package:flutter_app/screens/update_task_page.dart';

import '../shared/widgets/alert_dialog.dart';
import '../shared/widgets/widgets.dart';
import '../utils/utils.dart';

class TodoHome extends StatefulWidget {
  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  late CollectionReference collectionReference;

  @override
  void initState() {
    setState(() => collectionReference = FirebaseFirestore.instance
        .collection('todos')
        .doc(user!.uid)
        .collection("user_todo"));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Task',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
          ),
          actions: [
            PopupMenuButton(
              itemBuilder: (context) => [
                itemMenuList(0, "Theme"),
                itemMenuList(1, "Sign out"),
                itemMenuList(2, "Exit")
              ],
              onSelected: (dynamic item) => selectDropDownOption(context, item),
            ),
          ],
        ),
        floatingActionButton: floatActionBtn(context, custom: true),
        body: showTodoListData(context),
      ),
    );
  }

  PopupMenuEntry itemMenuList(itemValue, itemTitle) {
    return PopupMenuItem<int>(
      value: itemValue,
      child: Text(
        itemTitle,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget showTodoListData(BuildContext context) {
    return new StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return Center(child: new Text("Empty Data"));
          if (snapshot.hasData)
            return ListView(children: getTodoListItems(snapshot));
          if (snapshot.hasError)
            return new Center(
              child: Text('Error! no data available.'),
            );
          return new Center(
            child: Text('Loading! Please wait.'),
          );
        });
  }

  getTodoListItems(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs
        .map(
          (doc) => ListTile(
            leading: Icon(
              Icons.event,
              color: AppColor.kPrimaryAppColor,
              size: 30,
            ),
            title: Text(
              '${doc['title']}.',
              style: TextStyle(fontSize: 15),
            ),
            subtitle: Text(
              doc['date'],
              style: TextStyle(fontSize: 12),
            ),
            trailing: SizedBox(
              width: 60,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateTodoData(
                            title: doc['title'],
                            date: doc['date'],
                            docsId: doc.id,
                          ),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.edit,
                      color: AppColor.kPrimaryAppColor,
                      size: 25,
                    ),
                  ),
                  SizedBox(width: 8,),
                  GestureDetector(
                    onTap: () {
                      deleteTodoItem(context, doc.id);
                    },
                    child: Icon(
                      Icons.delete,
                      color: AppColor.kPrimaryAppColor,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  void deleteTodoItem(BuildContext context, String docId) {
    showAlertDialog(
        context, "Are you sure want to delete todo?", "Delete", "Delete todo",
        (context) async {
      try {
        await collectionReference.doc(docId).delete();
      } catch (ex) {
        log("Error! Todo deletion");
      }
    });
  }


}
