// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';
//
// class CheckConnectivity extends StatefulWidget {
//
//   @override
//   _CheckConnectivityState createState() => _CheckConnectivityState();
// }
//
// class _CheckConnectivityState extends State<CheckConnectivity> {
//    StreamSubscription streamSubscription;
//    ConnectivityResult oldResult;
//    bool isConnecting = false;
//
//
//    @override
//    void initState(){
//      super.initState();
//
//        streamSubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
//          if (result == ConnectivityResult.none) {
//            setState(() {
//              isConnecting = false;
//
//                _internetCheckBtnSheet('Oops..!',Icon(Icons.signal_wifi_connected_no_internet_4,color: Colors.white,size: 20,),'No internet',Colors.black);
//
//            });
//            print('Not Connected');
//
//          } else if (oldResult == ConnectivityResult.none) {
//            setState(() {
//              isConnecting = true;
//                _internetCheckBtnSheet('Connected..!',Icon(Icons.wifi,color: Colors.white,size: 20,),'Back Online',Colors.blue);
//            });
//            print('Connected');
//          }
//          oldResult = result;
//        });
//
//    }
//
//    @override
//    dispose() {
//      super.dispose();
//      streamSubscription.cancel();
//    }
//
//    Widget _internetCheckBtnSheet( customText,mainText,customIcon,text, Color colorsMain){
//
//      try{  showModalBottomSheet(
//          context: context,
//          builder: (context) {
//            return Ink(
//              color: colorsMain,
//              child: Column(
//                mainAxisSize: MainAxisSize.min,
//                children: <Widget>[
//                  ListTile(
//                    leading: customIcon,
//                    title: new Text(
//                        customText,
//                        style: TextStyle(
//                            fontSize: 12,
//                            color:Colors.white,
//                            fontWeight: FontWeight.w700)),
//                    subtitle: new Text(
//                        text,
//                        style: TextStyle(
//                            fontSize: 12,
//                            color:Colors.white,
//                            fontWeight: FontWeight.w700)),
//                    trailing: new IconButton(
//                      icon: Icon(Icons.close),
//                      iconSize: 20,
//                      color: Colors.white,
//                      onPressed: () {
//                        Navigator.pop(context, true);
//                      },
//                    ),
//
//                  ),
//                ],
//              ),
//            );
//          });
//
//      }catch(ex){
//        print("===============Error handled=================");
//        print(ex.toString());
//      }
//
//    }
//
//
//
//
//    @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//           body: Center(child: Container(child: Text('Internet Check'))),
//
//       )
//     );
//   }
//
// }
//
//
//
//
