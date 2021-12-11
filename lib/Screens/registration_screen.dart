import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pfeapp/Screens/new_screen.dart';
import 'package:pfeapp/Screens/signin_screen.dart';
import 'package:pfeapp/constants.dart';
import 'package:pfeapp/db/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';


class RegistrationScreen extends StatefulWidget {
  static final String id ="registration_screen";

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth=FirebaseAuth.instance;
  final _fireStore= Firestore.instance;
  bool showSpinner=false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();

  bool _obscureText=true;

  bool emptyEmail=false;
  bool emptyPassword=false;
  bool emptyName=false;
  bool emptyAddress=false;
  bool emptyMobile=false;

  void _showHide() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("images/Signup_back.jpg"),
              fit: BoxFit.fill,
            )
        ),
        child: ModalProgressHUD(
          color: Colors.lightBlueAccent,
          inAsyncCall: showSpinner,
          child:  Scaffold(
              backgroundColor: Colors.transparent,
              body: SafeArea(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0,20,0,0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            IconButton(
                              alignment: Alignment.centerLeft,
                              onPressed: (){
                                Navigator.pushNamed(context, SigninScreen.id);
                              },
                              icon: Icon(Icons.arrow_back_ios),
                            ),
                            SizedBox(width: 45,),
                            Text(
                              "Create account",
                              style: TextStyle(
                                fontSize:25,
                                color: Color(0xff344955),
                                fontFamily: 'Lato',
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: emptyName ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ) : InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Name",
                              prefixIcon: Icon(Icons.person),
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 14, right: 15),
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: emptyEmail ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ) : InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "E-mail",
                              prefixIcon: Icon(Icons.email),
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 14, right: 15),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextFormField(
                            controller: _passwordController,
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

                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.blue,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          child: TextFormField(
                            controller: _addressController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: emptyAddress ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ) : InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Address",
                              prefixIcon: Icon(Icons.location_on),
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

                            controller: _mobileController,
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: emptyMobile ? OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red,width: 2),
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ) : InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              hintText: "Mobile",
                              prefixIcon: Icon(Icons.phone),
                              contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 14, right: 15),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 50,),
                     Row(
                       mainAxisAlignment: MainAxisAlignment.end,
                       children: <Widget>[
                         Text(
                           "Create",
                           style: TextStyle(
                               fontWeight: FontWeight.w900,
                               fontSize:30,
                               color: kColorBlack
                           ),
                         ),

                         RaisedButton(

                           onPressed: ()async {
                             if(_formKey.currentState.validate()) {
                               if(_nameController.text.isNotEmpty && _emailController.text.isNotEmpty
                               && _passwordController.text.isNotEmpty && _nameController.text.isNotEmpty
                               && _mobileController.text.isNotEmpty
                               ) {
                                 setState(() {
                                   emptyName=false;
                                   emptyMobile=false;
                                   emptyEmail=false;
                                   emptyPassword=false;
                                   emptyAddress=false;
                                   emptyMobile=false;
                                   showSpinner=true;

                                 });
                                 try {
                                   final newUser= await _auth.createUserWithEmailAndPassword(email:_emailController.text, password: _passwordController.text);
                                   if(newUser!=null) {
                                     _fireStore.collection("users").document(newUser.user.uid).setData(
                                         {
                                           "id":newUser.user.uid,
                                           "name":_nameController.text ,
                                           "email":_emailController.text,
                                           "address":_addressController.text,
                                           "mobile":_mobileController.text,
                                         }
                                     );
                                     _fireStore.collection('cart').document(newUser.user.uid).setData(
                                       {
                                         'productsIds':FieldValue.arrayUnion(['']),
                                         'userId':newUser.user.uid,
                                       }
                                     );
                                     Navigator.pushNamed(context,SigninScreen.id);
                                   }
                                   setState(() {
                                     emptyName=false;
                                     showSpinner=false;
                                   });
                                 } catch (e) {
                                   print(e);
                                 }
                               }if(_nameController.text.isEmpty) {
                                 setState(() {
                                   emptyName=true;
                                 });
                               }if(_emailController.text.isEmpty) {
                                 setState(() {
                                   emptyEmail=true;
                                 });
                               }if(_passwordController.text.isEmpty) {
                                 setState(() {
                                   emptyPassword=true;
                                 });
                               }if(_addressController.text.isEmpty) {
                                 setState(() {
                                   emptyAddress=true;
                                 });
                               }if(_mobileController.text.isEmpty) {
                                 setState(() {
                                   emptyMobile=true;
                                 });
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
                      Text("Or create account using Google",textAlign: TextAlign.center,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          height: 35,
                          width: 35,
                          child: FloatingActionButton(
                            onPressed: ()async {
                              setState(() {
                                showSpinner=true;
                              });
                              await handlGoogleSignIn().then((_){
                                Navigator.pushReplacementNamed(context, NewScreen.id);
                                setState(() {
                                  showSpinner=false;
                                });
                              });
                            },
                            elevation: 4,
                            child:Image(
                              image: AssetImage("images/google.png",),
                              height: 25,
                              width: 25,
                              color:kColorBlue ,
                            ) ,
                          ),
                        ),
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }
}