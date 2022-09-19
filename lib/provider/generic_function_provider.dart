import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/const.dart';

class GenericHelperProvider extends ChangeNotifier {
  bool checkLoading = false;
  void onGoogleLoginPressed() {
    checkLoading = true;
    notifyListeners();
  }


}
