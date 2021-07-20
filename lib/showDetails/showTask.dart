
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/components/alertDialog.dart';
import 'package:flutter_app/loginRegister/loginPage.dart';
import 'package:flutter_app/main.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/showDetails/insert_task.dart';
import 'package:flutter_app/components/custom_widgets.dart';




class TodoHome extends StatefulWidget {


  final String password,email;
  TodoHome({Key key, @required this.email,@required this.password, }):super(key: key);



  @override
  _TodoHomeState createState() => _TodoHomeState();
}




class _TodoHomeState extends State<TodoHome> {

  FirebaseAuth auth = FirebaseAuth.instance;
  User user =   FirebaseAuth.instance.currentUser;
  var documentRef = FirebaseFirestore.instance.collection('todos');


  final TextEditingController eCtrl = new TextEditingController();




  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(

            title: Text('Task', style: TextStyle ( fontWeight: FontWeight.w500, fontSize: 20)),
            actions: [
              PopupMenuButton(
                itemBuilder: (context) =>
                [
                  PopupMenuItem<int>(
                    value: 0,
                    child: Text("Settings", style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child: Text("Exit", style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),),
                  ),

                  PopupMenuItem<int>(
                    value: 2,
                    child: Text("Sign out", style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),),
                  ),
                ],
                onSelected: (item) => SelectedItem(context, item),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            tooltip: 'Add task',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddTaskHome()));
            },
          ),

          body: Container(
            child:new StreamBuilder(
                stream: documentRef.doc(user.uid).collection('user_todo').snapshots(),
                builder: (context, snapShot) {
                  if (snapShot.hasData) {
                    final List<DocumentSnapshot> documents = snapShot.data.docs;

                    if (documents.isNotEmpty) {
                      return ListView(
                          children: documents.
                          map((doc) =>
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                shadowColor: Colors.black45,
                                elevation: 10,
                                child: ListTile(
                                  leading: Icon(
                                    Icons.event, color: Colors.black54, size: 30,),
                                  title: Text(doc['title'],
                                    style: TextStyle(fontSize: 15),),
                                  subtitle: Text(doc['date'],
                                    style: TextStyle(fontSize: 12),),
                                  // trailing: Icon(Icons.delete,color: colorsName,size: 30, ),
                                  trailing: IconButton(
                                      tooltip: 'Delete',
                                      onPressed: () {
                                        setState(() {
                                          //something is going to happen here..
                                          documentRef.doc(user.uid).collection('user_todo').doc(doc.id).delete();
                                        });
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: colorsName,
                                        size: 30,)),
                                ),
                              )).toList());
                    } else {
                      return Center(
                        child: Container(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Icon(Icons.hourglass_empty_outlined,
                                color: colorsName, size: 100,),
                              Text('Empty data..!'),
                            ],
                          ),
                        ),),
                      );
                    }
                  } else if (snapShot.hasError) {
                    return Center(child: Container(child: Text("It's Error!")));
                  }

                  return Center(
                    child: Container(child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: CircularProgressIndicator(strokeWidth: 4,),
                          ),
                          Text('Loading..!'),
                        ],
                      ),
                    ),),
                  );
                })
            ,
          ),
        )

    );
  }




  void SelectedItem(BuildContext context, item) {
    switch (item) {
      case 0:

        break;
      case 1:
        show_alertDialog(context);
        break;

      case 2:


        if(user !=null){

          setState(() {
            _signOut();
          });
        }else{
          print("No user found...!");
        }
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
    }
  }


  Future <LoginPage> _signOut()  async{
   await FirebaseAuth.instance.signOut();
   Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
  }


  check_userNull() {
    if(  user.uid.isNotEmpty ){
      new StreamBuilder(
          stream: documentRef.doc(user.uid).collection('user_todo').snapshots(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              final List<DocumentSnapshot> documents = snapShot.data.docs;

              if (documents.isNotEmpty) {
                return ListView(
                    children: documents.
                    map((doc) =>
                        Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          shadowColor: Colors.black45,
                          elevation: 10,
                          child: ListTile(
                            leading: Icon(
                              Icons.event, color: Colors.black54, size: 30,),
                            title: Text(doc['title'],
                              style: TextStyle(fontSize: 15),),
                            subtitle: Text(doc['date'],
                              style: TextStyle(fontSize: 12),),
                            // trailing: Icon(Icons.delete,color: colorsName,size: 30, ),
                            trailing: IconButton(
                                tooltip: 'Delete',
                                onPressed: () {
                                  setState(() {
                                    //something is going to happen here..
                                    documentRef.doc(user.uid).collection('user_todo').doc(doc.id).delete();
                                  });
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: colorsName,
                                  size: 30,)),
                          ),
                        )).toList());
              } else {
                return Center(
                  child: Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Icon(Icons.hourglass_empty_outlined,
                          color: colorsName, size: 100,),
                        Text('Empty data..!'),
                      ],
                    ),
                  ),),
                );
              }
            } else if (snapShot.hasError) {
              return Center(child: Container(child: Text("It's Error!")));
            }

            return Center(
              child: Container(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(strokeWidth: 4,),
                    ),
                    Text('Loading..!'),
                  ],
                ),
              ),),
            );
          });
    }else{
      print("Sorry! No user listed");
    }
  }



  show_alertDialog(BuildContext context){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: Center(child: Text("Exit App",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),)),
          content: Center(
            child: Text("Are you sure want to exit ?",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          ),
          actions: [
            FlatButton(onPressed: () {
              Navigator.pop(context);
            },
                child: Text('NO', style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorsName))),

            FlatButton(onPressed: () {
              exit(0);
            },
                child: Text('YES', style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colorsName))),


          ],
        );
      },
    );
  }


}

