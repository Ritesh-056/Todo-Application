import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  late User user;

  User? authAuthUser() {
    if(auth.currentUser !=null){
      user = auth.currentUser!;
      return user;
    }
    return null;
  }
}
