import 'dart:io';
import 'dart:isolate';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/screens/loginPage.dart';
import 'package:flutter_app/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/showDetails/insert_task.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  var counter = 0;
  int helloAlarmID = 1;
  var itemValue;
  final TextEditingController eCtrl = new TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  GoogleSignIn _googleSignIn = GoogleSignIn();
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
              PopupMenuItem<int>(
                value: 0,
                child: Text(
                  "Theme",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<int>(
                value: 3,
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text(
                  "Sign out",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text(
                  "Exit",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
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
              context, MaterialPageRoute(builder: (context) => AddTaskHome()));
        },
      ),
      body: check_userNull(context),
    ));
  }

  Future<void> SelectedItem(BuildContext context, item) async {
    switch (item) {
      case 0:
        colorPickerAlertDialog(context);
        break;

      case 1:
        if (auth.currentUser?.uid != null) {
          _signOutFirebase();
          _signOutGoogle();
        } else {
          print("No user found...!");
        }
        break;

      case 2:
        showAlertDialog(context);
        break;

      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfileDetails()));
        break;
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel",
          style:TextStyle(color: colorsName)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Exit",
          style:TextStyle(color: colorsName)),
      onPressed: () {
        exit(0);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Center(
        child: Text(
          "Exit App",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      content: Text(
        "Are you sure want to exit ? App will close instantly.",
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
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<LoginPage> _signOutGoogle() async {
    await _googleSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }

  check_userNull(BuildContext context) {
    if (FirebaseAuth.instance.currentUser?.uid != null) {
      return new Container(
        child: new StreamBuilder(
            stream:
                documentRef.doc(user.uid).collection('user_todo').snapshots(),
            builder: (context, snapShot) {
              if (snapShot.hasData) {
                final List<DocumentSnapshot> documents = snapShot.data.docs;

                if (documents.isNotEmpty) {
                  return ListView(
                      children: documents
                          .map((doc) => Card(
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
                                      onPressed: () {
                                        setState(() {
                                          //something is going to happen here..
                                          documentRef
                                              .doc(user.uid)
                                              .collection('user_todo')
                                              .doc(doc.id)
                                              .delete();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: colorsName,
                                        size: 30,
                                      )),
                                ),
                              ))
                          .toList());
                } else {
                  return Center(
                    child: Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.hourglass_empty_outlined,
                              color: colorsName,
                              size: 100,
                            ),
                            Text('Empty data..!'),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } else if (snapShot.hasError) {
                return Center(child: Container(child: Text("It's Error!")));
              }

              return Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
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
            pickerColor: Colors.red,
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

  // void pickColor(BuildContext context) {
  //     showDialog(
  //         context: context,
  //         builder: (context)=>AlertDialog(
  //           title:Center(
  //             child: Text('Pick Your Color',
  //             style: TextStyle(fontSize: 15),
  //             ),
  //           ),
  //           content:
  //               Container(
  //                 child: Column(
  //                   children: [
  //                     buildColorPicker(),
  //                     SizedBox(height: 20,),
  //                     TextButton(
  //                       child:Text('SELECT',
  //                         style:TextStyle(fontSize: 13),
  //                       ),
  //                       onPressed: (){
  //                         Navigator.of(context).pop();
  //                       },
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //
  //
  //           ));
  //
  // }

}
