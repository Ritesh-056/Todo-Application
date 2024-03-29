import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../auth_services.dart';
import '../screens/todo_list_page.dart';
import '../utils/utils.dart';

class TodoServiceProvider extends ChangeNotifier {
  ///update todo
  Future<void> updateTodoItems(
    BuildContext context,
    String todoItemId,
    String titleTodo,
    String dateTimeTodo,
  ) async {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('todos')
        .doc(AuthService().auth.currentUser!.uid)
        .collection("user_todo");

    try {
      // checkData(titleTodo, dateTimeTodo);
      await collectionReference.doc(todoItemId).update({
        'title': titleTodo,
        'date': dateTimeTodo,
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => TodoHome()));
      todoToast('Todo Updated Successful');
    } on Exception catch (e) {
      todoToast('Todo update failed');
      log("Updating todo error: ${e.toString()}");
    }
  }

  ///create new todo
  void onCreateNewTodo(
      BuildContext context, String titleTodo, String dateTimeTodo) {
    CollectionReference collectionReference = FirebaseFirestore.instance
        .collection('todos')
        .doc(AuthService().auth.currentUser!.uid)
        .collection("user_todo");

    try {
      collectionReference.doc().set({'title': titleTodo, 'date': dateTimeTodo});
      todoToast('Added Successfully');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodoHome(),
        ),
      );
    } catch (ex) {
      log("Error! while inserting todo :  ${ex.toString()}");
      return;
    }
  }
}
