import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/bezierContainer.dart';
import 'package:flutter_app/main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserCredential> userCredential ;



  var textEditingController = new TextEditingController();
  String registerEmail    ="";
  String registerPassword ="";
  String registerUsername ="";


  void registerUser(String email , String password){

    try {
          userCredential = auth.createUserWithEmailAndPassword(
          email: registerEmail,
          password: registerPassword
      );

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }




  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: 0,
                  top: 10,
                  bottom: 10),
              child: Icon(
                Icons.keyboard_arrow_left,
                color: colorsName,
                size: 40,),
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 15,
                    color: colorsName,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,String tracker, {bool isPassword = false}) {

    Widget _checkField(){

      if(tracker == "e"){
        return new TextField(
            onChanged: (val){
              setState(() {
                registerEmail = val;
              });
            },
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f6),
                filled: true)
        );

      }else if( tracker  == "p"){
        return new TextField(
          // obscureText: isPassword,
            onChanged: (val){
              setState(() {
                registerPassword = val;

              });
            },
            obscureText: true,
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
                  registerUsername = val;
                  });
          },
          decoration: InputDecoration(
          border: InputBorder.none,
          fillColor: Color(0xfff5f5f6),
          filled: true));

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
            if(registerEmail.length > 0  && registerPassword.length >0  && registerUsername.length > 0){
              registerUser(registerEmail, registerPassword);
            }else{
              Fluttertoast.showToast(
                  msg: "Oops..! Make sure you have inserted your email, password and username.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 5,
                  fontSize: 16.0
              );
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
                colors: [ colorsName, colorsName])),
        child: Text(
          'Sign Up',
          style: TextStyle(fontSize: 15, color: Colors.white,fontWeight: FontWeight.w600),
        ),
      ),
    );
  }



  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            GestureDetector(
              onTap: (){
                setState(() {
                  Navigator.pop(context);
                });
              },
              child: Text(
                'Login',
                style: TextStyle(
                    color: colorsName,
                    fontSize: 13,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(
      'Register',
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
        _entryField("Username","u"),
        _entryField("Email id","e"),
        _entryField("Password","p", isPassword: true),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return new SafeArea(
      child: Scaffold(
        body: Container(
          height: height,
          color: Colors.white,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -MediaQuery.of(context).size.height * .15,
                right: -MediaQuery.of(context).size.width * .4,
                child: BezierContainer(),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(
                        height: 50,
                      ),
                      _emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      _submitButton(),
                      SizedBox(height: height * .14),
                      _loginAccountLabel(),
                    ],

                  ),
                ),
              ),
              Positioned(top: 0, left: 0, child: _backButton()),
            ],
          ),
        ),
      ),
    );
  }
}

