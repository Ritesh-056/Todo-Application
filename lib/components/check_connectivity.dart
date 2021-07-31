import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

class CheckConnectivity extends StatefulWidget {

  @override
  _CheckConnectivityState createState() => _CheckConnectivityState();
}

class _CheckConnectivityState extends State<CheckConnectivity> {
   StreamSubscription streamSubscription;
   ConnectivityResult oldResult;
   var  connectingMedium;
   bool isConnecting = false;



   @override
   void initState(){
     super.initState();
     streamSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
       if (result == ConnectivityResult.none) {
           isConnecting = false;
         print('Not Connected');
       } else if (oldResult == ConnectivityResult.none) {
           isConnecting = true;
         print('Connected');

       }
          oldResult = result;
     });
   }

   @override
   dispose() {
     super.dispose();
     streamSubscription.cancel();
   }

   Widget _internetCheckBtnSheet( customIcon,text, Color colorsMain){

     try{ showModalBottomSheet(
         context: context,
         builder: (context) {
           return Ink(
             color: colorsMain,
             child: Column(
               mainAxisSize: MainAxisSize.min,
               children: <Widget>[
                 ListTile(
                   leading: customIcon,
                   title: new Text(
                       'Oops...!',
                       style: TextStyle(
                           fontSize: 12,
                           color:Colors.white,
                           fontWeight: FontWeight.w700)),
                   subtitle: new Text(
                       text,
                       style: TextStyle(
                           fontSize: 12,
                           color:Colors.white,
                           fontWeight: FontWeight.w700)),
                   trailing: new IconButton(
                     icon: Icon(Icons.close),
                     iconSize: 20,
                     color: Colors.white,
                     onPressed: () {
                       Navigator.pop(context);
                     },
                   ),

                 ),
               ],
             ),
           );
         });

     }catch(ex){
       print("===============Error handled=================");
       print(ex.toString());
     }

   }



   @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       body: isConnecting ?
         _internetCheckBtnSheet(Icon(Icons.wifi,color: Colors.white,size: 20,),'Back Online',Colors.blue)
        :_internetCheckBtnSheet(Icon(Icons.signal_wifi_connected_no_internet_4,color: Colors.white,size: 20,),'No internet',Colors.black)


    )
    );
  }

}




