// import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';
//
// class CheckConnectivity extends StatefulWidget {
//   @override
//   _CheckConnectivityState createState() => _CheckConnectivityState();
// }
//
// class _CheckConnectivityState extends State<CheckConnectivity> {
//    var subscription;
//
//    bool isConnecting = false;
//
//   checkConnection() async{
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       // print("Connected to Internet[Mobile Network]");
//       setState(() {
//         isConnecting = true;
//       });
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       // print("Connected to Internet[wifi]");
//       setState(() {
//         isConnecting = true;
//       });
//     } else{
//       setState(() {
//         isConnecting = false;
//       });
//       // print("No Internet Connection");
//     }
//     return isConnecting;
//   }
//
//   @override
//   initState() {
//     subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//       // Got a new connectivity status!
//
//     });
//   }
//
//   @override
//   dispose() {
//
//     subscription.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: checkConnection() ?
//       Center(child: Container(child: Text('Connected to Internet'),))
//           :Center(child: Container(child: Text('Not connected to Internet'),))
//     );
//   }
// }
//
//
//
//
