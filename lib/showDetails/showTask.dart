import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/screens/login_page.dart';
import 'package:flutter_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/screens/insert_task.dart';
import 'package:flutter_app/screens/update_task.dart';
import 'package:flutter_app/widgets/reusable_widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../const.dart';
import '../functions/dart/reusable_functions.dart';
import '../functions/dart/todohome_functions.dart';

class TodoHome extends StatefulWidget {

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  var title, date;
  var counter = 0;
  int helloAlarmID = 1;
  var itemValue;
  var docId;
  BuildContext? mContext;

  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController eCtrl = new TextEditingController();
  var documentRef = FirebaseFirestore.instance.collection('todos');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: colorsName,
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
            floatingActionButton:
                TodoFloatingActionButton(context, custom: true),
            // body: showTodoList(context),
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





 Widget  showTodoList(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return new Container(
        child: new StreamBuilder<QuerySnapshot>(
            stream: documentRef.doc(user!.uid).collection('user_todo').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapShot) {
              if(! snapShot.hasData){
                return showEmptyPlaceHolder();
              }else if(snapShot.hasError){
                return Center(child: Container(
                    child: Text("It's Error! Something went wrong")));
              }
              else if (snapShot.hasData) {

                List<QueryDocumentSnapshot<Object?>> snapshots  = snapShot.data!.docs;

                  return ListView(
                      children: snapshots
                          .map((doc) =>
                          Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            shadowColor: Colors.black45,
                            elevation: 10,
                            child: ListTile(
                              leading: Icon(
                                Icons.event,
                                color: Colors.black54,
                                size: 30,
                              ),
                              title: Text(
                                doc.get("title"),
                                // doc['title'],
                                style: TextStyle(fontSize: 15),
                              ),
                              subtitle: Text(
                                // doc['date'],
                                doc["date"],
                                style: TextStyle(fontSize: 12),
                              ),
                              // trailing: Icon(Icons.delete,color: colorsName,size: 30, ),
                              trailing: IconButton(
                                tooltip: 'Delete',
                                onPressed: () {
                                  docId = doc.id;
                                  showAlertDialog(context,
                                      "Are you sure want to delete ?",
                                      "Confirm",
                                      "Delete Task",
                                      funcTaskDelete);
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: colorsName,
                                  size: 30,
                                ),
                              ),
                              //goto task screen.
                              onTap: () {
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateTodoData(title: doc['title'],
                                            date: doc['date'],
                                            docsId: doc.id)));
                              },
                            ),
                          ))
                          .toList());
              }
              return showLoadingPlaceHolder();
            }),
      );
    } else {
      return new Center(
          child: Container(
            child: Text('Sorry no user found.'),
          ));
    }
  }


  void funcTaskDelete() {
     try{
       documentRef.doc(user!.uid).collection('user_todo').doc(docId).delete();
       todoToast('Deleted Successfully');
       Navigator.of(context).pop();
     }catch(ex){
       log("Error occured while deleting!");
     }
  }
}
