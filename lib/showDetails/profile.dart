import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';



class ProfileDetails extends StatelessWidget{
FirebaseAuth _auth = FirebaseAuth.instance;


 Widget _text( title, size,color,weight) {
    return Text(
      title,
      style: TextStyle(
          fontSize: size,
          color: color,
          fontWeight: weight
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(


          floatingActionButton: FloatingActionButton(
            backgroundColor: colorsName,
            child: Icon(Icons.close),
            onPressed: (){
              Navigator.pop(context);
            },
          ),



          body:Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                child:
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:NetworkImage("${_auth?.currentUser?.photoURL}"),
                        ),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          border: new Border.all(
                            color: colorsName,
                            width: 2.0,
                          ),
                        ),
                      ),

                      _text("${_auth?.currentUser?.displayName}",
                          15.0,
                          null,
                          FontWeight.w500 ),
                      _text("${_auth?.currentUser?.email}",
                          13.0,
                          null,
                          FontWeight.w500 ),

                  ],)
              ),
            ),
          ),
      ),
    );
  }
}
