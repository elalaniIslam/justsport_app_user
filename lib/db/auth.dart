import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';




final FirebaseAuth firebaseAuth= FirebaseAuth.instance;
final GoogleSignIn googleSignIn=GoogleSignIn();
SharedPreferences preferences ;

Future handlGoogleSignIn() async {
  preferences = await SharedPreferences.getInstance();

  GoogleSignInAccount googleUser= await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleSignInAuthentication.accessToken,
    idToken: googleSignInAuthentication.idToken,
  );
  FirebaseUser firebaseUser = (await firebaseAuth.signInWithCredential(credential)).user;
  if(firebaseUser != null) {
    final QuerySnapshot result = await Firestore.instance.collection("users")
        .where("id",isEqualTo: firebaseUser.uid).getDocuments();
    final List<DocumentSnapshot> documents  = result.documents;
    if(documents.length ==0 ){
      Firestore.instance
          .collection("users")
          .document(firebaseUser.uid)
          .setData({
        "id":firebaseUser.uid,
        "name":firebaseUser.displayName,
        "profilePicture":firebaseUser.photoUrl,
        "email":firebaseUser.email,
        "mobile":"",
        "address":"",
      });

      await preferences.setString("id", firebaseUser.uid);
      await preferences.setString("name", firebaseUser.displayName);
      await preferences.setString("profilePicture", firebaseUser.photoUrl);
      await preferences.setString("email", firebaseUser.email);

    }else {
      await preferences.setString("id", documents[0]["id"]);
      await preferences.setString("name", documents[0]["name"]);
      await preferences.setString("profilePicture", documents[0]["profilePicture"]);
      await preferences.setString("email", documents[0]["email"]);

    }
    Fluttertoast.showToast(msg: "Login was successful");


  }else Fluttertoast.showToast(msg: "Login failed !!");

  return firebaseUser;
}