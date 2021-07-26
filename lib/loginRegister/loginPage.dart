import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/bezierContainer.dart';
import 'package:flutter_app/loginRegister/signUpPage.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:flutter_app/main.dart';
import '../components/alertDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  // final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserCredential> userCredential;
  bool isLoading = false;

  String loginEmail = "";
  String loginPassword = "";
  // var textController = new TextEditingController();

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1.5,
              ),
            ),
          ),
          Text('Social',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }


  Widget dialog(BuildContext context){
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
  
  Widget _modelBox(text){

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: new Icon(
                    Icons.error,
                    size: 50,
                    color: Color.fromRGBO(180, 0, 20, 0.9),),
                  title: new Text(
                      'Oops...!',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700)),
                  subtitle: new Text(
                      text,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700)),
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
          );
        });
  }

  Widget _GoogleButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          isLoading = true;
        });
        signInWithGoogle();
      },
      child: Container(
        height: 50,
        margin: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(187, 0, 27, 0.9),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    topLeft: Radius.circular(50),
                  ),
                ),
                alignment: Alignment.center,
                child: Text('G',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
              ),
            ),

            Expanded(
              flex: 5,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(180, 0, 20, 0.9),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(50),
                      topRight: Radius.circular(50)),
                ),
                alignment: Alignment.center,
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Continue with Google',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Container(
           height: height,
           child: Stack(
            children: <Widget>[
            Positioned(
              top: 25,
              left: 20,
              child: Icon(
                Icons.arrow_back_ios,
                color: colorsName,
              ),
            ),
            Positioned(
                top: -height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer()),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: colorsName,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                    Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff5f5f6),
                          filled: true),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    SizedBox(height: 10,),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff5f5f6),
                          filled: true),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () {
                        String errorMessage="";
                        try{
                          if(_emailController.text.length ==0 &&
                             _passwordController.text.length ==0){
                            
                             _modelBox('Make sure you have inserted email and password.');
                            
                          }else{
                            auth.signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);


                            if(auth.currentUser.uid !=null){
                                return Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) =>
                                TodoHome(email: auth.currentUser.email, password: null)));
                                } else {
                                print("No account signed in");
                                }

                            }
                          }

                           catch (error) {
                              switch (error.code) {
                              case "ERROR_INVALID_EMAIL":
                              errorMessage = "Your email address appears to be malformed.";
                              break;
                              case "ERROR_WRONG_PASSWORD":
                              errorMessage = "Your password is wrong.";
                              break;
                              case "ERROR_USER_NOT_FOUND":
                              errorMessage = "User with this email doesn't exist.";
                              break;
                              case "ERROR_USER_DISABLED":
                              errorMessage = "User with this email has been disabled.";
                              break;
                              case "ERROR_TOO_MANY_REQUESTS":
                              errorMessage = "Too many requests. Try again later.";
                              break;
                              case "ERROR_OPERATION_NOT_ALLOWED":
                              errorMessage = "Signing in with Email and Password is not enabled.";
                              break;
                              default:
                              errorMessage = "An undefined Error happened.";
                              }

                              return _modelBox(errorMessage.toString());
                          }
                          },
                      child: Container(
                        height: 50,
                        child: Center(
                          child: Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: colorsName,
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ),

                    ///submit button
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.centerRight,
                      child: Text('Forgot Password ?',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.w400)),
                    ),
                    _divider(),
                    _GoogleButton(),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        print('tapped');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 20),
                        padding: EdgeInsets.all(15),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Don\'t have an account ?',
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Register',
                              style: TextStyle(
                                  color: colorsName,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Positioned(top: 20, left: 0, child: _backButton()),
          ],
        ),
      )),
    );
  }

  //function to login user from google
  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    var checkAuth = await auth.signInWithCredential(credential);
    if (checkAuth.user.uid != null) {
      setState(() {
        isLoading = false;
      });
      return Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TodoHome(email: checkAuth.user.email, password: null)));
    } else {
      print("No account signed in");
    }
  }
}
