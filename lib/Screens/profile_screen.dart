import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pfeapp/Screens/cart_screen.dart';
import 'package:pfeapp/Screens/new_screen.dart';
import 'package:pfeapp/Screens/signin_screen.dart';
import 'package:pfeapp/constants.dart';
import 'package:pfeapp/round_button.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final _fireStore=Firestore.instance;
  final googleAuth=GoogleSignIn();
  final _auth=FirebaseAuth.instance;
  FirebaseUser loggedUser;
  String userName="User Name";
  String userEmail="User email";
  String userPhone="User phone";
  String userAddress="User address";
  String userPicUrl;

  GlobalKey<FormState> _numFormKey = GlobalKey();

  TextEditingController numController = TextEditingController();

  GlobalKey<FormState> _addressFormKey = GlobalKey();

  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();

  }
  bool existe=false;
  void getCurrentUser()async{
    final user= await _auth.currentUser();
    final googleUser = googleAuth.currentUser ;
    try {
      if(user!=null || googleUser!=null) {
        setState(() {
          existe=true;
        });
        if(user !=null)loggedUser=user;
        if(googleUser !=null)loggedUser=googleUser as FirebaseUser;

        //================== Set User infos =========================

        final result= await _fireStore.collection("users")
            .where("id",isEqualTo: loggedUser.uid)
            .getDocuments();
        for(var info in result.documents) {
          setState(() {
            userName=info.data['name'];
            userEmail=info.data['email'];
            userPicUrl=info.data['profilePicture'];
            userPhone=info.data['mobile']!=null
                ?info.data['mobile']
                :"not define";
            userAddress=info.data['address']!=null
                ?info.data['address']
                :"not define";
          });
        }
      }
    }catch (e) {
      print(e);
    }
  }

  void signOut(){
          setState(() {
            existe=false;
          });
          googleAuth.signOut();
          _auth.signOut();
          Navigator.pushReplacementNamed(context, NewScreen.id);
  }


  @override
  Widget build(BuildContext context) {
    return existe? Scaffold(
        backgroundColor: Color(0xffededf3),
        body:Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: <Widget>[
            Stack(
              overflow:Overflow.visible,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    /*borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),*/
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purple[300]],
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      tileMode: TileMode.mirror,
                    ),
                  ),
                ),
                Positioned(
                  top: 65,
                  left: 20,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                                Radius.circular(50)
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset: Offset(0, 3),

                              )
                            ]
                        ),
                        child: ClipRRect(
                          borderRadius:BorderRadius.all(
                              Radius.circular(60)
                          ),
                          child: Image(
                            image:userPicUrl==null
                                ? AssetImage('images/default_user.png')
                                :NetworkImage(userPicUrl),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(userName,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 22,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                            SizedBox(height: 10,),
                            Text("Welcome to your profile",
                              style:TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w300
                              ) ,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                InfoWidget(
                  title: "YOUR EMAIL",
                  content: userEmail,
                ),
                Divider(indent: 40,endIndent: 40,color: Colors.grey,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: InfoWidget(
                        title: "YOUR PHONE",
                        content: userPhone,
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.mode_edit),
                        onPressed: (){
                          _numAlert(loggedUser.uid);
                        },
                      ),
                    )
                  ],
                ),
                Divider(indent: 40,endIndent: 40,color: Colors.grey,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    InfoWidget(
                      title: "YOUR ADDRESS",
                      content: userAddress,
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.mode_edit),
                        onPressed: (){
                          _addressAlert(loggedUser.uid);
                        },
                      ),
                    )
                  ],
                ),
                Divider(indent: 40,endIndent: 40,color: Colors.grey,),
              ],
            ),
            SizedBox(
              height: 60,
            ),


          ],
        ),
        floatingActionButton:FloatingActionButton(
          onPressed: (){
            signOut();
          },
          child:Center(child: Icon(FontAwesomeIcons.signOutAlt)) ,
        )

    ):NotLoginPage();
  }
  void _numAlert(String id) {
    var alert = new AlertDialog(
      content: Form(
        key: _numFormKey,

        child: TextFormField(
          controller: numController,
          keyboardType: TextInputType.numberWithOptions(),
          validator: (value){
            if(value.isEmpty){
              return 'price cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "New price"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(numController.text != null){
            _fireStore.collection('users')
                .document(id).updateData({'mobile':numController.text})
                .then((_){
                  setState(() {
                    userPhone=numController.text;
                  });
              Fluttertoast.showToast(msg: 'num updated');
            });
          }
          numController.clear();
          Navigator.pop(context);
        }, child: Text('Update')),
        FlatButton(
            onPressed: ()  {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
  void _addressAlert(String id) {
    var alert = new AlertDialog(
      content: Form(
        key: _addressFormKey,
        child: TextFormField(
          controller: addressController,
          validator: (value){
            if(value.isEmpty){
              return 'address cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
              hintText: "New address"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(addressController.text != null){
            _fireStore.collection('users')
                .document(id).updateData({'address':addressController.text})
                .then((_){
              setState(() {
                userAddress=addressController.text;
              });
              Fluttertoast.showToast(msg: 'Address updated');
            });
          }
          numController.clear();
          Navigator.pop(context);
        }, child: Text('Update')),
        FlatButton(
            onPressed: ()  {
              Navigator.pop(context);
            },
            child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}

class NotLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("images/signin_up2.jpg"),
          fit: BoxFit.cover,),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
            ),
            Text("Please Sign in",
              style: TextStyle(
                fontSize: 40
              ),
            ),
            SizedBox(
              height: 50,
            ),
            RoundButton(
              color: Color(0xff00C6C2),
              textColor: Colors.white,
              text: 'Sign In',
              onPress: () {
                Navigator.pushNamed(context, SigninScreen.id);
              },
            ),
          ],
        ),
      )
    );
  }

}




class InfoWidget extends StatelessWidget {

  final title;
  final content;


  InfoWidget({this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(60,8,0,0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: Colors.grey,
                fontSize: 12
            ),
          ),
          SizedBox(height: 12,),
          Text(
            content,
            style: TextStyle(
                color: Colors.blueGrey,
                fontSize: 20
            ),
          ),
          SizedBox(height: 5,),
        ],
      ),
    );
  }
}
