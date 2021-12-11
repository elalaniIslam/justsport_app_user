//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pfeapp/Screens/cart_screen.dart';
import 'package:pfeapp/Screens/signin_screen.dart';
import 'package:pfeapp/load_page.dart';
import 'package:pfeapp/model/product.dart';
import 'package:pfeapp/constants.dart';
import 'package:pfeapp/components.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


enum Page { home ,cart , categories,profile}
class NewScreen extends StatefulWidget {
  static final String id = "new_screen";
  final index;

  NewScreen({this.index});

  @override
  _NewScreenState createState() => _NewScreenState();
}

class _NewScreenState extends State<NewScreen> {


  Page _selectedPage = Page.home;

  final _fireStore=Firestore.instance;
  final googleAuth=GoogleSignIn();
  final _auth=FirebaseAuth.instance;
  FirebaseUser loggedUser;
  String userName="User Name";
  String userEmail="User email";
  String userPicUrl;

  Product product=Product();



  Widget imageCarousell =Container(
    height: 200,
    child: Carousel(
      dotSize: 8,
      dotIncreaseSize: 1.1,
      dotColor: kColorBlue,
      dotBgColor: Colors.transparent,
      dotIncreasedColor: kColorOrange,
      boxFit: BoxFit.cover,
      images: [
        AssetImage('images/s1.jpg'),
        AssetImage('images/s2.jpg'),
        AssetImage('images/s3.jpg'),
      ],
      autoplay: false,
      animationCurve: Curves.fastOutSlowIn,
      animationDuration: Duration(milliseconds: 1000),
      indicatorBgPadding:0,
      showIndicator: true,

    ),
  );


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Page> _pageOptions = <Page>[
    Page.home,
    Page.cart,
    Page.categories,
    Page.profile
  ];


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController = new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 75; // set bottom bar height
  double _bottomBarOffset = 0;
  @override
  void initState() {
    super.initState();
    setIndex();
  }

  void setIndex(){
    if(widget.index!=null) {
      setState(() {
        _selectedIndex=widget.index;
      });
    }else setState(() {
      _selectedIndex=0;
    });
  }
  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }
  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }







  //===============Builder==================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffededf3),

        // =================== Body ==============================

        body: LoadPage(
          selectedPage : _pageOptions.elementAt(_selectedIndex),
        ),
      bottomNavigationBar: _getBottomBar(),
    );
  }


  Widget _getBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black38, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius:  BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          selectedIconTheme: IconThemeData(
            size: 25,
            color: Colors.blue[800]
          ),
//          elevation:8,
          showSelectedLabels: true,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.home),
              title: Text('Home',),
            ),

            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.shoppingCart),
              title: Text('My Cart'),
//            backgroundColor: kColorOrange
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.cubes),
              title: Text('Category'),
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.solidUserCircle),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedLabelStyle: TextStyle(
            color: Colors.blue[900],
            fontWeight: FontWeight.bold
          ),
          selectedItemColor: Colors.blue[900],
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

}









