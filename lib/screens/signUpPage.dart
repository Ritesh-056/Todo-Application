import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/components/customContainer.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/screens/loginPage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../const.dart';


class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<UserCredential>? userCredential ;



  var _emailController    = new TextEditingController();
  var _passwordController = new TextEditingController();
  var _userNameController = new TextEditingController();

  String registerEmail    ="";
  String registerPassword ="";
  String registerUsername ="";

  bool securePass = true;
  var count =0;
  Icon icon = Icon(Icons.visibility_off_outlined,color: colorsName,);



  void toast(text){
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 5,
        fontSize: 16.0
    );
  }


  void _modelBox(text){

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
                    color: colorsName),
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

  Widget _entryField(String title,String tracker) {

    Widget _checkField(){

      if(tracker == "e"){
        return new TextField(
            cursorColor: colorsName,
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.email_outlined,color: colorsName,),
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f6),
                filled: true)
        );

      }else if( tracker  == "p"){
        return new TextField(
            cursorColor: colorsName,
            obscureText: securePass,
            controller: _passwordController,
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock_outlined,color: colorsName,),
                suffixIcon: IconButton(
                  icon: icon,
                  onPressed: (){
                    setState(() {

                      count++;

                      if(count % 2 != 0){
                        securePass = false;
                        icon = Icon(Icons.visibility_outlined,color: colorsName,);
                      }else{
                        securePass = true;
                        icon = Icon(Icons.visibility_off_outlined,color: colorsName,);
                      }

                    });
                  },
                ),
                border: InputBorder.none,
                fillColor: Color(0xfff5f5f6),
                filled: true)
        );
      }else{
          return new TextField(
            cursorColor: colorsName,
          controller: _userNameController,
          decoration: InputDecoration(
          prefixIcon: Icon(
          Icons.account_circle_outlined,
            color: colorsName,
          ),
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




  Widget _submitButton() => GestureDetector(
      onTap: () async {


          try{
            if(_emailController.text.length > 0 &&
                _passwordController.text.length >0  &&
                _userNameController.text.length > 0){

              await  auth.createUserWithEmailAndPassword(
                  email: _emailController.text,
                  password: _passwordController.text);

              toast('SignUp Successful...!');
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=>LoginPage()));


            }else{
              _modelBox("Make sure you have inserted your email, password and username.");
            }
          } on FirebaseAuthException catch (e){

            String text = 'A network error (such as timeout, interrupted connection or unreachable host) has occurred.';
            if(e.message == text){
              print('No internet available');
              return _modelBox('No Internet Available');
            }
            _modelBox('${e.message}');
            print("========Error[firebaseAuth]========");
            print(e.message);
          } catch(ex){
            _modelBox('${ex.toString()}');
            print("========Error[Catch]========");
            print(ex.toString());

          }
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
                colors: [ colorsName!, colorsName!])),
        child: Text(
          'Sign Up',
          style: TextStyle(
              fontSize: 15,
              color: Colors.white,
              fontWeight: FontWeight.w600),
        ),
      ),
    );



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
        _entryField("Email ","e"),
        _entryField("Password","p"),
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

