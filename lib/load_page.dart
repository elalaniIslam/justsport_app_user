import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:pfeapp/Screens/cart_screen.dart';
import 'package:pfeapp/Screens/new_screen.dart';
import 'package:pfeapp/Screens/category_screen.dart';
import 'package:pfeapp/Screens/profile_screen.dart';
import 'package:pfeapp/Screens/test_screen.dart';
import 'package:pfeapp/components.dart';

import 'constants.dart';
enum Page { home ,cart , categories,profile}

class LoadPage extends StatefulWidget {
   final  selectedPage;
   LoadPage({@required this.selectedPage});
  @override
  _LoadPageState createState() => _LoadPageState();
}


class _LoadPageState extends State<LoadPage> {
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

  @override
  Widget build(BuildContext context) {

    switch(widget.selectedPage){
      case Page.home:
        return TestScreen();
      case Page.cart:
        return CartScreen();
      case Page.categories:
        return CategoryScreen();
      case Page.profile:
        return ProfileScreen();

    }
  }
}
