
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_app/main.dart';
import 'package:date_time_picker/date_time_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


class AddTaskHome extends StatefulWidget {

  @override
  _AddTaskHomeState createState() => _AddTaskHomeState();
}


class _AddTaskHomeState extends State<AddTaskHome> {

  var documentRef = FirebaseFirestore.instance.collection('todos');

  final TextEditingController eCtrl = new TextEditingController();
  var listItem ="";
  var dateTimePicker =""; 
  
  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(

          floatingActionButton: FloatingActionButton(
            child:Icon(Icons.close),
            onPressed: (){
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoHome()));
              });
            },
          ),

        body:Center(
          child: new Stack(
              fit: StackFit.passthrough,
              overflow: Overflow.visible,
              children: [
                Positioned(
                   top:-80.0,
                   left: 20,
                   right: 20,
                   child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: new Text('Assign your Task',style: TextStyle(color: colorsName, fontSize: 18, fontWeight: FontWeight.bold),)),
                  ),),
                Positioned(
                  top:-48.0,
                  left: 65,
                  right: 65,
                  child:Divider(
                    thickness: 3,
                    color: colorsName,
                  ),),
               new Container(
                  height: 200,
                  width: 330,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color:Colors.white70,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 0,
                          offset: Offset(3, 4) // changes position of shadow
                      ),
                    ],

                  ),
                  child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: new TextField(
                            restorationId: "email_id",
                            decoration: InputDecoration(
                                hintText: "Insert Task",
                                border: InputBorder.none
                            ),
                            controller: eCtrl,
                            onChanged: (value){
                              listItem =value;
                            }
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child:DateTimePicker(
                              type: DateTimePickerType.dateTimeSeparate,
                              dateMask: 'd MMM, yyyy',
                              initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              icon: Icon(Icons.event,color: colorsName,size: 30,),
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
                                dateTimePicker = val;
                                dateTimePicker.toString();
                              },
                              validator: (val){
                                dateTimePicker = val;
                                dateTimePicker.toString();
                                print(val);
                                return null;
                              },
                              onSaved: (val){
                                print(val);
                                dateTimePicker = val;
                                dateTimePicker.toString();
                              }
                          )
                      ),

                       SizedBox(height: 10,),
                       new GestureDetector(
                         onTap: (){
                           setState(() {
                             if(listItem !=null && dateTimePicker!=null){
                               documentRef.add({'title' : listItem ,'date' : dateTimePicker });
                               eCtrl.clear();
                               listItem =null;
                               dateTimePicker=null;
                               Navigator.push(context, MaterialPageRoute(builder: (context)=>TodoHome()));
                             }
                           });
                         },
                         child: Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 16.0),
                           child: new Container(
                             height:50,
                             width:MediaQuery.of(context).size.width,
                             decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20),
                               color: colorsName,
                             ),
                             child: Center(child: Text('Assign',style: TextStyle(color: text_color_white, fontSize: 16),)),
                           ),
                         ),
                       )

                    ],
                  ),
               )
          ]
      ),
    ),
        ));
  }
}



class TodoHome extends StatefulWidget {

  final String password,email;
  TodoHome({Key key, @required this.email,@required this.password, }):super(key: key);



  @override
  _TodoHomeState createState() => _TodoHomeState();
}


class _TodoHomeState extends State<TodoHome> {


  var documentRef = FirebaseFirestore.instance.collection('todos');


   final TextEditingController eCtrl = new TextEditingController();
   @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
           title: Text('Task',style: TextStyle(fontSize: 15)),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_off),
              tooltip: 'Show text message',
              onPressed: () {
                setState(() {
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.add_alert),
              tooltip: 'Show text message',
              onPressed: () {
                setState(() {
                  _showAlertDialog(context);
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.border_bottom_outlined),
              tooltip: 'Show text message',
              onPressed: () {
                setState(() {

                  _settingModalBottomSheet(context);

                });
              },
            ),

          ],
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=>AddTaskHome()));
          },
        ),

        body: Container(
              child: new StreamBuilder(
                stream: FirebaseFirestore.instance.collection('todos').snapshots(),
                        builder: (context,snapShot) {
                          if (snapShot.hasData) {
                            final List<DocumentSnapshot> documents = snapShot.data.docs;

                            if(documents.isNotEmpty){
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
                                            leading:Icon(Icons.event,color: colorsName,size: 30,),
                                            title: Text('${doc['title']}.',style: TextStyle(fontSize: 15),),
                                            subtitle: Text(doc['date'],style: TextStyle(fontSize: 12),),
                                            trailing: Icon(Icons.delete,color: colorsName,size: 30, ),
                                            onTap: (){
                                              setState(() {
                                                //something is going to happen here..
                                                documentRef.doc(doc.id).delete();

                                              });
                                            }
                                        ),
                                      )).toList());
                            }else{
                              return  Center(
                                child: Container(child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Icon(Icons.hourglass_empty_outlined,color: colorsName, size: 100,),
                                      Text('Empty data..!'),
                                    ],
                                  ),
                                ),),
                              );

                            }

                          } else if (snapShot.hasError) {
                            return Center(child: Container(child: Text("It's Error!")));
                          }

                          return  Center(
                            child: Container(child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: CircularProgressIndicator(strokeWidth: 10,),
                                  ),
                                  Text('Loading..!'),
                                ],
                              ),
                            ),),
                          );
                        }),
          ),
        )

      );

  }

   void _settingModalBottomSheet(context){
     showModalBottomSheet(
         context: context,
         builder: (BuildContext bc){
           return Container(
             child: new Wrap(
               children: <Widget>[
                 new ListTile(
                     leading: new Icon(Icons.music_note),
                     title: new Text('Music'),
                     trailing: new Icon(Icons.menu),
                     onTap: () => {}
                 ),
                 new ListTile(
                   leading: new Icon(Icons.videocam),
                   title: new Text('Video'),
                   trailing: new Icon(Icons.menu),
                   onTap: () => {},
                 ),
                 new ListTile(
                     leading: new Icon(Icons.music_note),
                     title: new Text('Music'),
                     trailing: new Icon(Icons.menu),
                     onTap: () => {}
                 ),
                 new ListTile(
                   leading: new Icon(Icons.videocam),
                   title: new Text('Video'),
                   trailing: new Icon(Icons.menu),
                   onTap: () => {},
                 ),
                 new ListTile(
                     leading: new Icon(Icons.music_note),
                     title: new Text('Music'),
                     trailing: new Icon(Icons.menu),
                     onTap: () => {}
                 ),
                 new ListTile(
                   leading: new Icon(Icons.videocam),
                   title: new Text('Video'),
                   trailing: new Icon(Icons.menu),
                   onTap: () => {},
                 ),
               ],
             ),
           );
         }
     );
   }




void _showAlertDialog(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context) {
    return new AlertDialog(
      title: Center(child: Text("Exit App", style: TextStyle(fontSize: 16),)),
      content: Text("Are you sure want to exit ?",style: TextStyle(fontSize: 12)),
      actions: [


        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('NO',style: TextStyle(fontSize: 12))),

        FlatButton(onPressed: (){

             exit(0);

             }, child: Text('YES',style: TextStyle(fontSize: 12))),


      ],
    );
  },
  );
}

}
