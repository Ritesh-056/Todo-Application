import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/screens/chat.dart';
import 'package:flutter_app/screens/loginPage.dart';
import 'package:flutter_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/screens/insert_task.dart';
import 'package:flutter_app/screens/updateTask.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'profile.dart';

class TodoHome extends StatefulWidget {
  final String password, email;
  TodoHome({
    Key key,
    @required this.email,
    @required this.password,
  });

  @override
  _TodoHomeState createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {


  BuildContext mContext;

  var title, date;
  var counter = 0;
  int helloAlarmID = 1;
  var itemValue;
  var docId ;
  final TextEditingController eCtrl = new TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  var documentRef = FirebaseFirestore.instance.collection('todos');


  Widget toast(text) {

    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        fontSize: 16.0
    );

  }



  PopupMenuEntry  itemMenuList(itemValue, itemTitle){
   return PopupMenuItem<int>(
      value: itemValue,
      child: Text(
        itemTitle,
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600),
      ),
    );
  }


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
                itemBuilder: (context) =>
                [
                 itemMenuList(0,"Theme"),
                 itemMenuList(1,"Profile"),
                 itemMenuList(2,"Sign out"),
                 itemMenuList(3,"Exit")
                ],
                onSelected: (item) => SelectedItem(context, item),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add task',
            backgroundColor: colorsName,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddTaskHome()));
            },
          ),
          body: showTodoList(context),
        ));
  }


  void funcSignOut() {
    //sign out functions
    _signOutFirebase();
    _signOutGoogle();

    toast('Log out Successful');
  }


  Future<void> SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        colorPickerAlertDialog(context);
        break;

      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileDetails()));
        break;

      case 2:
        if (auth.currentUser?.uid != null) {
          showAlertDialog(
              context, "Are you sure want to logout?", "Log out", "Log out",
              funcSignOut);
        } else {
          print("No user found...!");
        }
        break;

      case 3:
        showAlertDialog(
            context, "Are you sure want to exit ? App will close instantly.",
            "Exit", "Exit App", funcExit);
        break;
    }
  }


  showAlertDialog(BuildContext context, alertTitle, doneButton, alertMainTitle,
       callBackMethod) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",
          style: TextStyle(color: colorsName)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(doneButton,
          style: TextStyle(color: colorsName)),
      onPressed: callBackMethod,
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          alertMainTitle,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      content: Text(
        alertTitle,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }




  Future<LoginPage> _signOutFirebase() async {
    await FirebaseAuth.instance.signOut();
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }




  Future<LoginPage> _signOutGoogle() async {
    await _googleSignIn.signOut();
    return Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }


   void funcExit(){
    exit(0);
  }


  showTodoList(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return new Container(
        child: new StreamBuilder(
            stream:
            documentRef.doc(user.uid).collection('user_todo').snapshots(),
            builder: (context, snapShot) {

              mContext = context ;

              if (snapShot.hasData) {
                final List<DocumentSnapshot> documents = snapShot.data.docs;

                if (documents.isNotEmpty) {
                  return ListView(
                      children: documents
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
                                doc['title'],
                                style: TextStyle(fontSize: 15),
                              ),
                              subtitle: Text(
                                doc['date'],
                                style: TextStyle(fontSize: 12),
                              ),
                              // trailing: Icon(Icons.delete,color: colorsName,size: 30, ),
                              trailing: IconButton(
                                tooltip: 'Delete',
                                onPressed: (){

                                  docId = doc.id ;
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
                } else {
                   funcShowEmptyData();
                }
              } else if (snapShot.hasError) {
                return Center(child: Container(
                    child: Text("It's Error! Something went wrong")));
              }

              return Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 4,
                            color: colorsName,
                          ),
                        ),
                        Text('Loading..!'),
                      ],
                    ),
                  ),
                ),
              );
            }),
      );
    } else {
      return new Center(
          child: Container(
            child: Text('Sorry no user found.'),
          ));
    }
  }


   funcShowEmptyData(){
    return Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_empty_outlined,
                color: colorsName,
                size: 50,
              ),
              Text('Empty data..!'),
            ],
          ),
        ),
      ),
    );
  }


  colorPickerAlertDialog(BuildContext context) {
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          'Pick Your Color',
          style: TextStyle(fontSize: 13),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ColorPicker(
            // showLabel: false,
            pickerColor: colorsName,
            showLabel: false,
            labelTextStyle:
            TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            pickerAreaHeightPercent: 0.5,
            onColorChanged: (colors) {
              setState(() {
                colorsName = colors;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          TextButton(
            child: Text(
              'SELECT',
              style: TextStyle(fontSize: 13),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


 void funcTaskDelete() {
    documentRef
        .doc(user.uid)
        .collection('user_todo')
        .doc(docId)
        .delete();
    toast('Deleted Successfully');

    Navigator.of(context).pop();
  }



}