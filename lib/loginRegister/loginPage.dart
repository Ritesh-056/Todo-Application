import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/bezierContainer.dart';
import 'package:flutter_app/loginRegister/signUpPage.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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

  Widget _GoogleButton() {
    return GestureDetector(
      onTap: (){
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
                child: Text('Continue with Google',
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

  Widget _model(customText){

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
                      customText,
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
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff5f5f6),
                          filled: true),
                      onChanged: (val){
                         loginEmail = val;
                      },
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Password',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          fillColor: Color(0xfff5f5f6),
                          filled: true),
                      onChanged: (val){
                        loginPassword = val;
                      },
                    )
                    ,
                    SizedBox(
                      height: 50,
                    ),
                    InkWell(
                      onTap: () async {

                              if( _emailController.text.length    ==0 &&
                                  _passwordController.text.length ==0){

                               return _model('Make sure you have inserted email and password.');

                              }

                              else{

                                 try {
                                   await auth.signInWithEmailAndPassword(
                                       email: _emailController.text,
                                       password: _passwordController.text
                                   );
                                 } on FirebaseAuthException catch  (e) {
                                   _model('Failed with error code: ${e.code}');
                                   _model(e.message);
                                 }


                              //    if(auth.currentUser.uid !=null){
                              //      return Navigator.push(
                              //          context,MaterialPageRoute(
                              //          builder: (context)=> TodoHome(
                              //              email: _emailController.text,
                              //              password: null
                              //          ))
                              //      );
                              //    }
                              // }



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
                              fontSize: 13,
                              color:colorsName,
                              fontWeight: FontWeight.w400)
                      ),
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
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600),
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
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await auth.signInWithCredential(credential);
      if(auth.currentUser.uid !=null){
        return Navigator.push(context,
            MaterialPageRoute(builder:
                (context)=>
                TodoHome(email: auth.currentUser.email,
                    password: null)
            )
        );

      }
  }

  // checkUserId(check){
  //   if(check.user.uid !=null){
  //     return Navigator.push(context,
  //         MaterialPageRoute(builder:
  //             (context)=>
  //             TodoHome(email: check.user.email,
  //                 password: null)
  //         )
  //     );
  //   }else{
  //     return EasyLoading.showError('Something went wrong');
  //     print("No account signed in");
  //   }
  // }
  
}


