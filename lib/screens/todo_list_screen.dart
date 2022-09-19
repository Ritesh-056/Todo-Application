import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/provider/generic_function_provider.dart';
import 'package:flutter_app/screens/update_task.dart';
import 'package:flutter_app/widgets/reusable_widgets.dart';
import 'package:provider/provider.dart';
import '../const.dart';
import '../functions/dart/todohome_functions.dart';

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
        backgroundColor:colorsName,
        title: Text('Task',
            style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20)),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              itemMenuList(0, "Theme"),
              itemMenuList(1, "Sign out"),
              itemMenuList(2, "Exit")
            ],
            onSelected: (dynamic item) => SelectedItem(context, item),
          ),
        ],
      ),
      floatingActionButton: TodoFloatingActionButton(context, custom: true),
      body: showTodoListData(context),
    ));
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
              color: colorsName,
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
            trailing: GestureDetector(
                onTap: () => deleteTodoItem(doc.id),
                child: Icon(
                  Icons.delete,
                  color: colorsName,
                  size: 30,
                )),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UpdateTodoData(
                          title: doc['title'],
                          date: doc['date'],
                          docsId: doc.id)));
            },
          ),
        )
        .toList();
  }

  void deleteTodoItem(String docId) {
    showAlertDialog(
        context, "Are you sure want to delete todo?", "Delete", "Delete todo",
        () {
      deleteSelectedTodo(docId);
    });
  }

  void deleteSelectedTodo(String docId) async {
    try {
      await collectionReference.doc(docId).delete();
      Navigator.of(context).pop();
    } catch (ex) {
      log("Error! Todo deletion");
    }
  }
}
