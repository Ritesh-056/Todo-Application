import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:flutter_app/widgets/reusable_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../const.dart';



class UpdateTodoData extends StatefulWidget {
   var title;
   var date;
   var docsId;

   UpdateTodoData({
      this.title,
      this.date,
      this.docsId,
  });

  @override
  State<UpdateTodoData> createState() => _UpdateTodoDataState(title,date,docsId);
}

class _UpdateTodoDataState extends State<UpdateTodoData> {
   var title;
   var date;
   var docsId;
  _UpdateTodoDataState(this.title, this.date, this.docsId);

   var updatedTitle="";
   var updatedDate ="";
   var countTitle=0,countDate=0;


    var documentsRef = FirebaseFirestore.instance.collection('todos')
       .doc(auth.currentUser.uid)
       .collection('user_todo');


   void checkDocs(String value1,String value2){
     documentsRef
         .doc(docsId)
         .update({
       'title': value1,
       'date':  value2
     });
   }


   Widget toast(text){
     Fluttertoast.showToast(
         msg: text,
         toastLength: Toast.LENGTH_SHORT,
         gravity: ToastGravity.CENTER,
         timeInSecForIosWeb: 5,
         fontSize: 16.0
     );
   }




  @override
  Widget build(BuildContext context) {

     // titleController.text = title;
     // dateController.text = date;



    return new SafeArea(
        child: Scaffold(
          floatingActionButton:TodoFloatingActionButton(context),
          body: Center(
            child: new Stack(
                fit: StackFit.passthrough,
                children: [
                  Positioned(
                    top: -80.0,
                    left: 20,
                    right: 20,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: new Text(
                            'Update your Task',
                            style: TextStyle(
                                color: colorsName,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ),
                  Positioned(
                    top: -48.0,
                    left: 65,
                    right: 65,
                    child: Divider(
                      thickness: 3,
                      color: colorsName,
                    ),
                  ),
                  new Container(
                    height: 200,
                    width: 330,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
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
                          child:  TextFormField(
                              cursorColor: colorsName,
                              initialValue: title,
                              onChanged: (val){
                                setState(() {
                                   countTitle++;
                                });
                                updatedTitle = val;
                              },
                              decoration: InputDecoration(
                                  hintText: "Insert Task",
                                  border: InputBorder.none),
                            ),
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: ColorScheme.light(
                                  primary: colorsName,
                                ),
                              ),
                              child: DateTimePicker(
                                  cursorColor: colorsName,
                                  type: DateTimePickerType.dateTime,
                                  dateMask: 'd MMM, yyyy',
                                  firstDate: DateTime(2000),
                                  initialValue: date,
                                  onChanged: (val){
                                    setState(() {
                                      countDate++;
                                    });
                                    updatedDate = val;
                                  },
                                  lastDate: DateTime(2100),
                                  icon: Icon(
                                    Icons.event,
                                    color: colorsName,
                                    size: 30,
                                  ),
                                  dateLabelText: 'Date',
                                  timeLabelText: "Hour",
                                  selectableDayPredicate: (date) {
                                    // Disable weekend days to select from the calendar
                                    if (date.weekday == 6 || date.weekday == 7) {
                                      return false;
                                    }
                                    return true;
                                  },
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        new GestureDetector(
                          onTap: () async {
                              if (
                                  updatedDate !=null &&
                                  updatedTitle !=null) {
                                if (auth.currentUser.uid != null) {
                                  try {
                                         if( countTitle > 0 && countDate >0){
                                          checkDocs(updatedTitle, updatedDate);

                                         }else if(countTitle >0){
                                           checkDocs(updatedTitle, date);

                                         }else if(countDate >0){
                                           checkDocs(title, updatedDate);

                                         }else{
                                           checkDocs(title, date);
                                         }

                                  }on Exception catch (e) {
                                      print('\n\n\n');
                                      print('========== Exception ============');
                                       print(e.toString());
                                  }

                                } else {
                                  print("User is called on a null");
                                }
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TodoHome(email:null,password:null)));
                                toast('Updated Successfully');
                              } else {
                                 showModel('Make sure you have inserted task, date and time.');
                              }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: new Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: colorsName,
                              ),
                              child: Center(
                                  child: Text(
                                    'Update',
                                    style: TextStyle(
                                        color: text_color_white, fontSize: 16),
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
          ),
        ));
  }

  Widget showModel(text){
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: new Icon(
                    Icons.error,
                    size: 50,
                    color:
                    colorsName,
                  ),
                  title: new Text('Oops...!',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  subtitle: new Text(
                      text,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
                  trailing: new IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 20,
                    color:
                    Color.fromRGBO(20, 20, 20, 0.9),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          );
        });
  }


}
