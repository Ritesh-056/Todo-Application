import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationManager extends StatefulWidget {


    String title="Main Notifier" ;
    String taskTime;
    // NotificationManager({
    //       @required this.title,
    //       @required this.taskTime });
    // title: title ,
    // taskTime: taskTime


  @override
  _NotificationManagerState createState()
         => _NotificationManagerState(

         );
}

class _NotificationManagerState extends State<NotificationManager> {

  String title;
  String taskTime;
  _NotificationManagerState({
    this.title ,
    this.taskTime});

  var _timer;
  var  flutterNotification = new FlutterLocalNotificationsPlugin();


 // initializing the native functions or methods for notification popup.
  @override
  void initState() {

    super.initState();
    var androidInitilize = new AndroidInitializationSettings('app_icon');
    var iOSinitilize     = new IOSInitializationSettings();
    var initilizationsSettings =
    new InitializationSettings(
        android: androidInitilize,
        iOS: iOSinitilize);

    flutterNotification
        .initialize(
        initilizationsSettings,
        onSelectNotification: notificationSelected);


    _showNotification();


    // _timer = new Timer(
    //     const Duration(
    //         milliseconds: 100),
    //         (){
    //
    //            });

  }


  // overriding the runner timer.
  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }


  //main method scaffold for displaying the UI.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
           body: Center(
            child: Text('Click for notification'),
           ),
    );
  }



  //Future for notification handler function
  Future _showNotification() async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID",
        "Local Notification",
        "Notification content",
        importance: Importance.max);

    var iSODetails = new IOSNotificationDetails();

    var generalNotificationDetails = new NotificationDetails(
        android: androidDetails,
        iOS: iSODetails );

    await flutterNotification.show(
        0,
        "Task Tracker Alert",
        "$title",
        generalNotificationDetails,
        payload: "Task"
    );


    // var scheduledTime = DateTime.now()
    //     .add(
    //     Duration(
    //         minutes : 1 )
    // );

  //   flutterNotification
  //       .schedule(
  //       1,
  //       "Task Tracker Alert",
  //       '$title',
  //       scheduledTime,
  //       generalNotificationDetails );
  }


  //Alert after clicking the notification
  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }
}

