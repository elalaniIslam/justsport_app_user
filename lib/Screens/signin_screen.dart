import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pfeapp/Screens/new_screen.dart';
import 'package:pfeapp/Screens/profile_screen.dart';
import 'package:pfeapp/Screens/registration_screen.dart';
import 'package:pfeapp/Screens/test_screen.dart';
import 'package:pfeapp/constants.dart';
import 'package:pfeapp/db/auth.dart';
import 'package:pfeapp/round_button.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';


class SigninScreen extends StatefulWidget {
  static final String id ="signin_screen";

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final FirebaseAuth firebaseAuth= FirebaseAuth.instance;
  final GoogleSignIn googleSignIn=GoogleSignIn();
  SharedPreferences preferences ;

  bool isLogedIn=false;
  bool loading=false;

  bool _obscureText=true;

  void _showHide() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }


  @override
  void initState() {
    super.initState();
    isSignIn();
  }

  void isSignIn() async {
    setState(() {
      showSpinner=true;
    });
    preferences =await SharedPreferences.getInstance();
    isLogedIn=await googleSignIn.isSignedIn();
    if(isLogedIn) {
      Navigator.pushReplacementNamed(context, NewScreen.id);//pour ne revien pas a login page
    }
    setState(() {
      showSpinner=false;
    });
  }


  final _formKey = GlobalKey<FormState>();


  TextEditingController _emailColtroller = TextEditingController();
  TextEditingController _passwordColtroller = TextEditingController();

  String email;
  String mdpss;

  bool emptyEmail=false;
  bool emptyPassword=false;

  bool showSpinner=false;
  @override
  Widget build(BuildContext context) {


    return ModalProgressHUD(
      color: Colors.lightBlueAccent,
      inAsyncCall: showSpinner,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Signin_back.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,10,0,50),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: (){
                            Navigator.pushNamed(context, NewScreen.id);
                          },
                        )
                      ),
                    ),
                    Container(
                      width: double.infinity,
                    ),

                    SizedBox(height: 5,),
                    Text(
                      "Hello",
                      style: TextStyle(
                        fontSize: 85,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0,0,0,30),
                      child: Text(
                        "Sign in to your account",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Material(
                        elevation: 4,
                        shadowColor: Colors.blue,

                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextFormField(
                          controller: _emailColtroller,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder:emptyEmail ? OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red,width: 2),
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                            ) : InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            hintText: "E-mail",
                            prefixIcon: Icon(Icons.person),
                            contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 14, right: 15),
                          ),

                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Material(
                        elevation: 4,
                        shadowColor: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: TextFormField(
                            controller: _passwordColtroller,
                            obscureText: _obscureText,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: emptyPassword ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ) : InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Password",
                              prefixIcon: Icon(Icons.lock),
                              suffixIcon: IconButton(
                                padding: EdgeInsets.all(0),
                                icon:_obscureText ? Icon(Icons.remove_red_eye,):Icon(Icons.visibility_off),
                                onPressed:_showHide ,
                              ),
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 14, right: 15),
                            ),

                        ),
                      ),
                    ),
                    SizedBox(height: 40,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "Sign in",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize:30,
                            color: kColorBlack
                          ),
                        ),

                        RaisedButton(

                          onPressed: () async{
                            if(_formKey.currentState.validate()) {
                              if(_emailColtroller.text.isNotEmpty) {
                                setState(() {
                                  emptyEmail=false;
                                });
                                if(_passwordColtroller.text.isNotEmpty) {
                                  setState(() {
                                    showSpinner=true;
                                    emptyEmail=false;
                                    emptyPassword=false;
                                  });
                                  try {
                                    final user=await firebaseAuth.
                                    signInWithEmailAndPassword(email: _emailColtroller.text
                                        , password: _passwordColtroller.text);
                                    if(user!=null) {
                                      setState(() {
                                        showSpinner=true;
                                        emptyEmail=false;
                                        emptyPassword=false;
                                      });
                                      Navigator.pushReplacementNamed(context,NewScreen.id);
                                      Fluttertoast.showToast(msg: "Login success",backgroundColor: Colors.grey);
                                    }
                                  } catch (e) {
                                    print(e);
                                    Fluttertoast.showToast(msg: "Login failed",backgroundColor: Colors.grey);
                                    setState(() {
                                      emptyEmail=false;
                                      emptyPassword=false;
                                    });
                                  }
                                }else if(_passwordColtroller.text.length <6){
                                  setState(() {
                                    emptyPassword=true;
                                  });
                                  Fluttertoast.showToast(msg:"password field must be sup to 6",backgroundColor: Colors.red);
                                }else if(_passwordColtroller.text.isEmpty) {
                                  setState(() {
                                    emptyPassword=true;
                                  });
                                  Fluttertoast.showToast(msg:"password field is empty",backgroundColor: Colors.red);
                                }
                              }else if(_emailColtroller.text.isEmpty){
                                setState(() {
                                  emptyEmail=true;
                                });
                                Fluttertoast.showToast(msg:"email field is empty",backgroundColor: Colors.red);
                              }
                            }
                          },
                          elevation: 0,
                          color: Colors.white,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.all(new Radius.circular(30.0)),
                              gradient: new LinearGradient(
                                colors: [kColorOrange,Colors.orange[200]],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                tileMode: TileMode.clamp,
                              ),
                              boxShadow:  [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: Offset(0, 5), // changes position of shadow
                              ),
                            ],
                            ),
                            width:50,
                            height: 40,
                            child: Icon(Icons.arrow_forward,size: 30,color: Colors.white,),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 100,),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        text: TextSpan(
                          text:"Don't have an account? ",
                          style: TextStyle(
                            fontSize: 15,
                            color: kColorBlack
                          ),
                          children: [

                            TextSpan(
                              text: "Create",
                              style: TextStyle(
                                fontSize: 17,
                                color: kColorBlack,
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap=(){
                                Navigator.pushNamed(context, RegistrationScreen.id);
                                }
                            )
                          ]
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}