import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import '../main.dart';

class AddTaskHome extends StatefulWidget {
  @override
  _AddTaskHomeState createState() => _AddTaskHomeState();
}

class _AddTaskHomeState extends State<AddTaskHome> {
  final TextEditingController eCtrl = new TextEditingController();
  var listItem = "";
  var dateTimePicker = "";

  FirebaseAuth auth = FirebaseAuth.instance;
  User user = FirebaseAuth.instance.currentUser;
  var documentRef = FirebaseFirestore.instance.collection('todos');

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
        child: Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.close),
        backgroundColor: colorsName,
        onPressed: () {
          setState(() {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => TodoHome()));
          });
        },
      ),
      body: Center(
        child: new Stack(
            fit: StackFit.passthrough,
            overflow: Overflow.visible,
            children: [
              Positioned(
                top: -80.0,
                left: 20,
                right: 20,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: new Text(
                    'Assign your Task',
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
                      child: new TextField(
                          cursorColor: colorsName,
                          restorationId: "email_id",
                          decoration: InputDecoration(
                              hintText: "Insert Task",
                              border: InputBorder.none),
                          onChanged: (value) {
                            listItem = value;
                          }),
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
                              type: DateTimePickerType.dateTimeSeparate,
                              dateMask: 'd MMM, yyyy',
                              // initialValue: DateTime.now().toString(),
                              firstDate: DateTime(2000),
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
                              onChanged: (val) {
                                dateTimePicker = val;
                                dateTimePicker.toString();
                              },
                              validator: (val) {
                                dateTimePicker = val;
                                dateTimePicker.toString();
                                print(val);
                                return null;
                              },
                              onSaved: (val) {
                                print(val);
                                dateTimePicker = val;
                                dateTimePicker.toString();
                              }),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    new GestureDetector(
                      onTap: () {
                        setState(() {
                          if (listItem.isNotEmpty &&
                              dateTimePicker.isNotEmpty) {
                            if (user.uid != null) {
                              documentRef
                                  .doc(auth.currentUser.uid)
                                  .collection('user_todo')
                                  .doc()
                                  .set({
                                'title': listItem,
                                'date': dateTimePicker
                              });
                              listItem = null;
                              dateTimePicker = null;
                            } else {
                              print("User is called on a null");
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TodoHome()));
                          } else {
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
                                                Color.fromRGBO(180, 0, 20, 0.9),
                                          ),
                                          title: new Text('Oops...!',
                                              style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700)),
                                          subtitle: new Text(
                                              'Make sure you have inserted task, date and time.',
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
                        });
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
                            'Assign',
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
}
