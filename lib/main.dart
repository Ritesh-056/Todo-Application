import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/screens/signUpPage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'components/notification_manager.dart';
import 'showDetails/showTask.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

//flutter packages importing
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/loginPage.dart';
import 'package:workmanager/workmanager.dart';


const text_color_white = Colors.white;
const padding_number = 8.0;
Color colorsName = Colors.green[500];
var auth = FirebaseAuth.instance;

BuildContext mContext;
const myTask = "syncWithTheBackEnd";
var  flutterNotification = new FlutterLocalNotificationsPlugin();
String title="Main Notifier" ;



// this is main methods for
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager.initialize(callbackDispatcher);
  Workmanager.registerPeriodicTask(
    "2",
     myTask,
    frequency: Duration(minutes: 15), // change duration according to your needs
  );
  await Firebase.initializeApp();
  runApp(LoginDesign());

}


void callbackDispatcher() {
// this method will be called every hour
  Workmanager.executeTask((task, inputdata) async {
    switch (task) {
      case myTask:
        print("this method was called from native!");
        _showNotification();
        // Fluttertoast.showToast(msg: "this method was called from native!");
        break;

      case Workmanager.iOSBackgroundTask:
        print("iOS background fetch delegate ran");
        break;
    }

    //Return true when the task executed successfully or not
    return Future.value(true);
  });
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
    context: mContext,
    builder: (context) => AlertDialog(
      content: Text("Notification : $payload"),
    ),
  );
}

class LoginDesign extends StatelessWidget {



  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorsName,
        accentColor: colorsName,
        fontFamily: 'Monotype Coursiva', //3, //3
      ),
      home: new SafeArea(
        child: Scaffold(
          body: AnimatedSplashScreen(
            duration: 3000,
            splash: new Image.asset('assets/Spinner.gif'),
            splashTransition: SplashTransition.slideTransition,
            backgroundColor: text_color_white,
            splashIconSize: 100,
            nextScreen: auth.currentUser?.uid == null
                ? LoginPage()
                : TodoHome(
                email: auth.currentUser.email,
                password: null),
          ),
        ),
      ),
    );
  }


  @override
  void initState() {
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


  }




  //
  // //Future for notification handler function
  // Future _showNotification() async {
  //   var androidDetails = new AndroidNotificationDetails(
  //       "Channel ID",
  //       "Local Notification",
  //       "Notification content",
  //       importance: Importance.max);
  //
  //   var iSODetails = new IOSNotificationDetails();
  //
  //   var generalNotificationDetails = new NotificationDetails(
  //       android: androidDetails,
  //       iOS: iSODetails );
  //
  //   await flutterNotification.show(
  //       0,
  //       "Task Tracker Alert",
  //       "$title",
  //       generalNotificationDetails,
  //       payload: "Task"
  //   );
  //
  //
  //   // var scheduledTime = DateTime.now()
  //   //     .add(
  //   //     Duration(
  //   //         minutes : 1 )
  //   // );
  //
  //   //   flutterNotification
  //   //       .schedule(
  //   //       1,
  //   //       "Task Tracker Alert",
  //   //       '$title',
  //   //       scheduledTime,
  //   //       generalNotificationDetails );
  // }
  //
  //
  // //Alert after clicking the notification
  // Future notificationSelected(String payload) async {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       content: Text("Notification : $payload"),
  //     ),
  //   );
  // }
}




//
// void main() {
//
//   // needs to be initialized before using workmanager package
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // initialize Workmanager with the function which you want to invoke after any periodic time
//   Workmanager.initialize(callbackDispatcher);
//
//   // Periodic task registration
//   Workmanager.registerPeriodicTask(
//     "2",
//     // use the same task name used in callbackDispatcher function for identifying the task
//     // Each task must have a unique name if you want to add multiple tasks;
//     myTask,
//     // When no frequency is provided the default 15 minutes is set.
//     // Minimum frequency is 15 min.
//     // Android will automatically change your frequency to 15 min if you have configured a lower frequency than 15 minutes.
//     frequency: Duration(hours: 1), // change duration according to your needs
//   );
//
//   runApp(MyApp()); // at last lines, you can call runApp()
// }