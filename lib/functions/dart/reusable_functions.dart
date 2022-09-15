import 'package:flutter/material.dart';
import 'package:flutter_app/const.dart';
import 'package:fluttertoast/fluttertoast.dart';

void todoToast(text) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      fontSize: 16.0);
}

void todoModelBox(BuildContext context, String textStr) {
  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: new Icon(Icons.error, size: 50, color: colorsName),
                  title: new Text('Oops...!',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  subtitle: new Text(textStr,
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  trailing: new IconButton(
                    icon: Icon(Icons.close),
                    iconSize: 20,
                    color: Color.fromRGBO(20, 20, 20, 0.9),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

void dialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            new CircularProgressIndicator(),
            new Text("Loading"),
          ],
        ),
      );
    },
  );
}
