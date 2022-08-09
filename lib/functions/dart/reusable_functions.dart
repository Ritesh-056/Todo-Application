import 'package:fluttertoast/fluttertoast.dart';


void todoToast(text){

  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      fontSize: 16.0
  );
}

