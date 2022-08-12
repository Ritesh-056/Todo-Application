import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';



class PasswordVisibility extends ChangeNotifier{

   bool pass_visible = true;
   int count  = 0;

   void enablePasswordVisibility(){
     count++;
     if(count % 2 != 0){
       pass_visible = false;
     }else{
       pass_visible = true;
     }

     notifyListeners();
   }

}