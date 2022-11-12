import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class GenericHelperProvider extends ChangeNotifier {
  bool checkLoading = false;
  void onGoogleLoginPressed() {
    checkLoading = true;
    notifyListeners();
  }


}
