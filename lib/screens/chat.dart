// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_app/main.dart';
//
// class ChatMessage extends StatefulWidget {
//   const ChatMessage({Key key}) : super(key: key);
//
//   @override
//   _ChatMessageState createState() => _ChatMessageState();
// }
//
// class _ChatMessageState extends State<ChatMessage> {
//   var firestore = FirebaseFirestore.instance;
//   var controller = new TextEditingController();
//
//   var userMe = auth.currentUser.uid;
//
//
//
//   @override
//   Widget build(BuildContext context)  {
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Chat Messages',style: TextStyle(color: Colors.white),),
//           backgroundColor: colorsName,
//         ),
//         body: Container(
//           child: StreamBuilder<QuerySnapshot>(
//             // <2> Pass `Stream<QuerySnapshot>` to stream
//               stream:FirebaseFirestore
//                   .instance.collection('todos')
//                   .doc(auth.currentUser.uid)
//                   .collection('user_message')
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   print('Data is loaded successfully.');
//                   // <3> Retrieve `List<DocumentSnapshot>` from snapshot
//                   final  List<DocumentSnapshot> documents =  snapshot.data.docs;
//
//
//                   return Container(
//                     child: ListView.builder(
//                         itemCount: documents.length,
//                         shrinkWrap: true,
//                         physics: BouncingScrollPhysics(),
//                         padding: EdgeInsets.only(top: 8, bottom: 8),
//                         // physics: NeverScrollableScrollPhysics(),
//
//                         itemBuilder: (context, index) {
//
//
//                           //for testing purpose.
//                           if(index == 0) {
//                             print("Testing the id");
//                             print(documents[index]['sender_id']);
//                             print(userMe);
//                           }
//
//                           return documents[index]['sender_id'] == userMe ?
//                               checkerLayout(Alignment.bottomLeft, auth.currentUser.photoURL, auth.currentUser.displayName, documents[index]['msg']):
//                               checkerLayout(Alignment.topLeft, auth.currentUser.photoURL, auth.currentUser.displayName, documents[index]['msg']);
//
//                         }),
//                   );
//
//                 } else if (snapshot.hasError) {
//                   print('Here entered on else-if case');
//
//                   return Center(child: Container(child: Text("It's Error!")));
//                 } else {
//                   print('Here entered on if case');
//                   return Center(
//                       child: Container(child: Text('Loading..please wait')));
//                 }
//               }),
//         ),
//         bottomNavigationBar: BottomAppBar(
//           child: sendMessage(controller),
//         ),
//       ),
//     );
//   }
//
//
//   checkerLayout(Alignment alignment, displayImg,displayName, displayMessage) =>  Align(
//     alignment: alignment,
//     child: Container(
//       padding: EdgeInsets.only(
//           left: 8, right: 8, top: 2, bottom: 2),
//       child: Row(
//         children: [
//         Container(
//         height: 34,
//         width: 34,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(50),
//             image:DecorationImage(
//               image: NetworkImage(displayImg),
//             )
//         ),),
//       SizedBox(width: 2,),
//       Column(
//         children: [
//         Text(
//         displayName,
//         style: TextStyle(fontSize: 12, color: Colors.black),
//       ),
//       Container(
//         width: 200,
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20),
//             color:Colors.blue.shade600),
//
//         padding: EdgeInsets.all(8.0),
//         child: Text(
//             displayMessage,
//             style: TextStyle(fontSize: 15, color: Colors.white)),
//       ),
//     ],
//   ),
//   ],
//   ),
//   ),
//   );
//
//   sendMessage(controller) => Container(
//     child: Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           hintText: 'Type your message',
//           suffixIcon: IconButton(
//               color: Colors.blue,
//               icon: Icon(Icons.send),
//               onPressed: () async {
//                 print('====>Button tapped<====');
//
//                 if (controller.text.length > 0) {
//                   await firestore.collection('todos').doc(auth.currentUser.uid).collection('user_message').add({
//                     'msg': controller.text,
//                     'sender_id': auth.currentUser.uid,
//                     'time' : DateTime.now().toString(),
//                   });
//                   print('Message sent Successfully');
//                   controller.clear();
//                 } else {
//                   print('Message is empty');
//                   controller.clear();
//                 }
//               }),
//         ),
//       ),
//     ),
//   );
// }
