import 'package:flutter/material.dart';
import 'package:pfeapp/Screens/cart_screen.dart';
import 'package:pfeapp/Screens/checkOut_screen.dart';
import 'package:pfeapp/Screens/new_screen.dart';
import 'package:pfeapp/Screens/product_screen.dart';
import 'package:pfeapp/Screens/registration_screen.dart';
import 'package:pfeapp/Screens/category_screen.dart';
import 'package:pfeapp/Screens/signin_screen.dart';
import 'package:animated_splash/animated_splash.dart';
import 'package:custom_splash/custom_splash.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Function duringSplash = () {
      print('Something background process');
      int a = 123 + 23;
      print(a);

      if (a > 100)
        return 1;
      else
        return 2;
    };
    Map<int, Widget> op = {1: NewScreen(), 2: NewScreen()};
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CustomSplash(
        imagePath: 'images/new_logo.png',
        home: NewScreen(),
        customFunction: duringSplash,
        backGroundColor: Color(0xffededf3),
        duration: 2500,
        type: CustomSplashType.BackgroundProcess,
        outputAndHome: op,
      ),
//      initialRoute:NewScreen.id,
      routes:{
        CartScreen.id: (context)=>CartScreen(),
        RegistrationScreen.id: (context)=>RegistrationScreen(),
        ProductScreen.id:(context)=> ProductScreen(),
        SigninScreen.id:(context)=> SigninScreen(),
        NewScreen.id:(context)=> NewScreen(),
        CategoryScreen.id:(context)=> CategoryScreen(),
        CheckOutScreen.id:(context)=> CheckOutScreen(),
      },
    );
  }
}
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Center(
            child: Text('My Cool App',
                style: TextStyle(color: Colors.black, fontSize: 20.0))));
  }
}