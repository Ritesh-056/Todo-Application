import 'package:flutter/material.dart';
import 'package:flutter_app/components/bezierContainer.dart';
import 'package:flutter_app/loginRegister/signUpPage.dart';
import 'package:flutter_app/showDetails/showTask.dart';
import 'package:flutter_app/main.dart';
import '../components/alertDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserCredential> userCredential;




  String loginEmail="";
  String loginPassword="";
  // var textController = new TextEditingController();



  void userlogin(String email, String password){

    try {
          userCredential =  auth.signInWithEmailAndPassword(
          email: email,
          password: password
          );
          print('Login Successfully');

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }


  Widget _backButton() {
    return InkWell(
      onTap: () {
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
        child: Row(
          children: <Widget>[
            Container(
              child: Text('Welcome\nTask Tracker',
                  style: TextStyle(fontSize: 18,color: colorsName, fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,String tracker,{bool isPassword = false}) {

    Widget _checkField(){

      if(tracker == "e"){
        return new TextField(
            onChanged: (val){
              setState(() {
                loginEmail = val;

              });
            },

            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f6),
                filled: true)
        );

      }else{
        return new TextField(

          // obscureText: isPassword,
            onChanged: (val){
              setState(() {
                loginPassword = val;
              });
            },
            obscureText: true,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f6),
                filled: true)
        );
      }

    }



    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(
            height: 10,
          ),
          _checkField(),
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: (){

        setState(() {
             if(loginEmail.isNotEmpty && loginPassword.isNotEmpty ){
                 userlogin(loginEmail,loginPassword);
                 print("Email:$loginEmail");
                 print("Password: $loginPassword");

                 Navigator.push(context,MaterialPageRoute(builder: (context)=>TodoHome(email: loginEmail, password: loginPassword)));
             }else{
                setState(() {
                  showAlertDialog(context);
                });
             }
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [colorsName, colorsNameLess])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

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
          Text('Social', style:TextStyle(fontSize: 13,fontWeight: FontWeight.w400)),
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

  Widget _facebookButton() {
    return Container(
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
                    topRight: Radius.circular(50)
                ),),
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
    );
  }


  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
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
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
    );
  }

  Widget _title() {
    return Text(
      'Login',
      style: TextStyle(
        color: colorsName,
        fontSize: 20,
        fontWeight: FontWeight.w700,

      ),
    );
  }


  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Email id","e"),
        _entryField("Password","p",isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Forgot Password ?',
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w400)),
                      ),
                      _divider(),
                      _facebookButton(),
                      SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 20, left: 0, child: _backButton()),
            ],
          ),
        ));
  }
}