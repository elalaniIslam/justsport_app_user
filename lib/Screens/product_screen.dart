import 'package:carousel_pro/carousel_pro.dart';
import 'package:carousel_slider/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pfeapp/Screens/new_screen.dart';
import 'package:pfeapp/Screens/signin_screen.dart';
import 'package:pfeapp/constants.dart';

class ProductScreen extends StatefulWidget {
  static final String id = 'product_screen';

  final String name;
  final String description;
  final pictures;
  final String price;
  final String category;
  final String brand;
  final int qte;
  final sizes;
  final String prodId;

  ProductScreen(
      {this.name,
      this.description,
      this.pictures,
      this.price,
      this.qte,
      this.sizes,
      this.category,
      this.brand,
      this.prodId});

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedQte = 1;
  String selSize;
  Color sizeColor=Colors.white;
  final _fireStore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser;


  List<String> selectedSizes=[];
  @override
  void initState() {
    super.initState();
    getCurrentUser();
//    myScroll();
  }

 /* @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }*/

  void getCurrentUser() async {
    final user = await _auth.currentUser();
    if (user != null) {
      loggedUser = user;
    }
  }

  bool _showAppbar = true; //this is to show app bar
  ScrollController _scrollBottomBarController =
      new ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 75; // set bottom bar height

  List<String> productsId = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffededf3),
      extendBodyBehindAppBar: true,

      body: ListView(
        controller: _scrollBottomBarController,
        padding: EdgeInsets.zero,
        children: <Widget>[
          //==================== image de produit ========================

          Stack(
            children: <Widget>[
              Container(
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
              ),
              Container(
                  height: 380,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(0)),
                    /* boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 4,
                          offset: Offset(0, 3),
                        )
                      ]*/),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(00)),
                    child: Carousel(
                      dotSize: 8,
                      dotIncreaseSize: 1.1,
                      dotColor: kColorBlue,
                      dotBgColor: Colors.transparent,
                      dotIncreasedColor: Colors.deepPurple,
                      boxFit: BoxFit.cover,
                      images: [
                        NetworkImage(widget.pictures[0]),
                        NetworkImage(widget.pictures[1]),
                        NetworkImage(widget.pictures[2]),
                      ],
                      autoplay: false,
                      animationCurve: Curves.fastOutSlowIn,
                      animationDuration: Duration(milliseconds: 1000),
                      indicatorBgPadding: 0,
                      showIndicator: true,
                      dotVerticalPadding: 6,
                    ),
                  )),
              SafeArea(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      heroTag: ('return'),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back,color: Colors.purple,),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FloatingActionButton(
                      backgroundColor: Colors.white,
                      heroTag: ('cart'),
                      onPressed: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewScreen(
                                  index: 1  ,
                                )));
                      },
                      child: Icon(Icons.shopping_cart,color: Colors.purple,),
                    ),
                  ),
                ),
              ),

            ],
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,12),
            child: Column(
//              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //====================== Titre du Produit & price ========================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 250,
                      child: Text(widget.name.toUpperCase(),
                        style: TextStyle(
                          color: Color(0xff402E32),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      width: 100,
                      child: Text("${widget.price} Dh",
                        style: TextStyle(
                          color: Color(0xffA37F53),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30,),

                //===================== Category & brand ====================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(

                      children: <Widget>[
                        Text("Category :",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(right:8.0),
                          child: Text("${widget.category} ",
                            style: TextStyle(
                                color: Color(0xffA37F53),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontStyle: FontStyle.italic
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text("Brand :",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                        Text("${widget.brand} ",
                          style: TextStyle(
                              color: Color(0xffA37F53),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontStyle: FontStyle.italic
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                //===================== Quantity ==========================

                SizedBox(height: 40,),
                Text("Select Quantity :",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Container(
                      height: 35,
                      width: 35,
                      child: FloatingActionButton(
                        foregroundColor: Color(0xffD2E6EE),
                        heroTag: ('btn1'),
                        backgroundColor: Color(0xff6DA0B5),
                        onPressed: () {
                          if(selectedQte>1) {
                            setState(() {
                              selectedQte--;
                            });
                          }

                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            topLeft: Radius.circular(10),
                          )
                        ),
                        child: Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                        elevation: 0,
                      ),
                    ),
                    SizedBox(width: 2,),
                    Container(
                      height: 35,
                      width: 35,
                      color: Color(0xff6DA0B5),
                      child: Center(
                        child: Text(
                          "$selectedQte",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 2,),
                    Container(
                      height: 35,
                      width: 35,
                      child: FloatingActionButton(
                        foregroundColor: Color(0xffD2E6EE),
                        heroTag: ('btn2'),
                        backgroundColor: Color(0xff6DA0B5),
                        onPressed: () {
                          if(selectedQte<widget.qte) {
                            setState(() {
                              selectedQte++;
                            });
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        elevation: 0,
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 30,),

                //====================== Sizes ===========================
                Text("Select Size :",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 20,),

                GridView.builder(
                  padding: EdgeInsets.all(0),
                    shrinkWrap: true,
                    controller: ScrollController(
                      keepScrollOffset: false,
                    ),
                    itemCount:widget.sizes.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing:8,
                      crossAxisSpacing: 2,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (BuildContext context,int index){
                      return GestureDetector(
                        onTap: (){


                          if(selectedSizes.contains(widget.sizes[index])) {
                            setState(() {
                              selectedSizes.removeAt(selectedSizes.indexOf(widget.sizes[index]));
                            });
                          }else if(selectedSizes.length< selectedQte){
                            setState(() {
                              selectedSizes.add(widget.sizes[index]);
                            });
                          }else{
                            setState(() {
                              selectedSizes.removeLast();
                              selectedSizes.add(widget.sizes[index]);
                            });
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: selectedSizes.contains(widget.sizes[index])
                                ?Colors.lightBlueAccent
                                :Colors.white
                              ,
                            border:Border.all(
                              color: Colors.grey,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10)
                            )
                          ),
                          child: Center(child: Text("${widget.sizes[index]}",
                            style: TextStyle(fontSize: 20),
                          )),
                        ),
                      );
                    }
                ),

                //=======================Button adding to shopping cart====================
                SizedBox(height: 40,),
                Text("Product details :",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  ),
                ),
                SizedBox(height: 20,),
                Text(widget.description,
                  style:TextStyle(
                    color: Colors.grey[700],
                    fontSize: 15
                  ) ,
                ),
              ],
            ),
          )
        ],
      ),
      //=======================Button adding to shopping cart====================

      floatingActionButton: Container(
        height: 80,
        width: 80,
        child: FloatingActionButton(
          backgroundColor: Color(0xff00C6C2),
          onPressed: () async {
            if (loggedUser != null) {

              if(selectedSizes.isEmpty) {
                showDialog<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("you should select size !"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("OK"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),

                        ],
                      );
                    });
              }else{
                await _fireStore.collection('cart')
                    .document(loggedUser.uid)
                    .collection('productsCart')
                    .document(widget.prodId)
                    .setData({
                  'id':widget.prodId,
                  'name': widget.name,
                  'category':widget.category,
                  'brand':widget.brand,
                  'qte':widget.qte,
                  'images':widget.pictures[0],
                  'sizes':widget.sizes,
                  'price':widget.price,
                  'description': widget.description,
                  'selectedQte': selectedQte,
                  'selectedSizes': selectedSizes,
                }).then((_) {
                  Fluttertoast.showToast(msg: 'Product added');
                });
              }
            } else {
              showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("you should Sign in first"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        FlatButton(
                          child: Text("Sign in"),
                          onPressed: () {
                            Navigator.pushNamed(
                                context, SigninScreen.id);
                          },
                        ),
                      ],
                    );
                  });
            }
          },
          child: Center(child: Icon(Icons.add_shopping_cart,size: 35,)),
        ),
      ),
    );
  }
}
