import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class CheckConnectivity extends StatefulWidget {

  @override
  _CheckConnectivityState createState() => _CheckConnectivityState();
}

class _CheckConnectivityState extends State<CheckConnectivity> {
   var subscription;
   var  connectingMedium;
   bool isConnecting = false;


   checkConnection(BuildContext context) async{
     var connectivityResult = await Connectivity().checkConnectivity();
     if (connectivityResult == ConnectivityResult.mobile) {
       setState(() {
         isConnecting = true;
         connectingMedium = "Mobile Network";
       });
     } else if (connectivityResult == ConnectivityResult.wifi) {
       setState(() {
         isConnecting = true;
         connectingMedium = "Wifi";
       });
     } else{
       setState(() {
         isConnecting = false;
       });
     }
   }

   @override
   void initState(){
     super.initState();
       WidgetsBinding.instance.addPostFrameCallback((_) => checkConnection(context));
   }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isConnecting ?
        Center(child: Container(child: Text('Connected to Internet==> $connectingMedium'),))
            :Center(child: Container(child: Text('Not connected to Internet'),))
      ),
    );
  }
}




