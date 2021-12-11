//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pfeapp/Screens/product_screen.dart';
import 'package:pfeapp/components.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:pfeapp/constants.dart';

enum Brands { nike, adidas, reebok, puma }

class TestScreen extends StatefulWidget {
  static final String id = "test_screen";
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final _fireStore = Firestore.instance;

  @override
  void initState() {
    super.initState();
  }
  Color activeColor=Colors.red[800];
  Color inactiveColor=Colors.black;
  Brands _selectedBrand=Brands.nike;
  String _brandSelected='Nike';
  //===============Builder==================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffededf3),
      body: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.deepPurple, Colors.purple[300]],
                    begin: Alignment.bottomRight,
                    end: Alignment.topLeft,
                    tileMode: TileMode.mirror,
                  ),
                ),
              ),
              SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () {
                        showSearch(context: context, delegate: ProductSearch());
                      },
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                              child: Icon(
                                Icons.search,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              "Search by name",
                              style: TextStyle(
                                  fontSize: 20, color: Colors.grey[700]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100,
                left: (MediaQuery.of(context).size.width) / 3 + 20,
//                right: MediaQuery.of(context).size.width/3+20,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image(
                      height: 100,
                      width: 100,
                      fit: BoxFit.contain,
                      image: AssetImage("images/new_logo_inter.png"),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 20),
            child: Text(
              "Features",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _fireStore
                .collection("products")
                .where('feature', isEqualTo: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text("Loading..."),
                );
              }
              final products = snapshot.data.documents;
              var featureProds = [];
              for (var product in products) {
                featureProds.add(product.data);
              }
              return CarouselSlider(
                options: CarouselOptions(
                  aspectRatio: 2.4,
                  viewportFraction: 0.8,
//                  autoPlay: false,
                  enlargeCenterPage: true,
                ),
                items: featureProds.map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8),
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 3,
                                blurRadius: 4,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        color: Colors.blue,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        child: Image(
                                          image: i['images'][0] == null
                                              ? Text("Loading...")
                                              : NetworkImage(
                                                  '${i['images'][0]}'),
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          width:140,
                                          child: Text(
                                            "${i['name']}",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w900,
                                              fontSize: 17,
                                            ),
                                          ),
                                        ),
                                        Text("${i['price']} dh"),
                                        RaisedButton(
                                          color: Colors.grey[800],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          child: Text(
                                            "Buy Now",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(builder:
                                                    (BuildContext context) {
                                              return ProductScreen(
                                                name: i["name"],
                                                description: i['description'],
                                                category: i['category'],
                                                brand: i['brand'],
                                                pictures: i['images'],
                                                price: i['price'],
                                                sizes: i['sizes'],
                                                qte: i['qte'],
                                                prodId: i['id'],
                                              );
                                            }));
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                    },
                  );
                }).toList(),
              );
            },
          ),
          SizedBox(height: 25,),
          Row(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedBrand=Brands.nike;
                      _brandSelected='Nike';
                    });
                  },
                  child: brandIcon(
                      'images/brands/nike.png',
                      'NIKE',
                      _selectedBrand==Brands.nike?activeColor:inactiveColor

                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedBrand=Brands.adidas;
                      _brandSelected='Adidas';

                    });
                  },
                  child: brandIcon(
                      'images/brands/adidas.png',
                      'ADIDAS',
                    _selectedBrand==Brands.adidas?activeColor:inactiveColor
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedBrand=Brands.reebok;
                      _brandSelected='Reebok';

                    });
                  },
                  child: brandIcon(
                      'images/brands/reebok.png',
                      'REEBOK',
                      _selectedBrand==Brands.reebok?activeColor:inactiveColor
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedBrand=Brands.puma;
                      _brandSelected='Puma';

                    });
                  },
                  child: brandIcon(
                      'images/brands/puma.png',
                      'Puma',
                      _selectedBrand==Brands.puma?activeColor:inactiveColor
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Products(_brandSelected),
          )
        ],
      ),
    );
  }

  Widget brandIcon(String link, String title,Color color) {
    return Container(
      height: 80,
      width: 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Image(
              image: AssetImage(link),
              color: color,
              /*height: 40,
              width: 40,*/
            ),
          ),
          Expanded(
              child: Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 20,
            ),
          ))
        ],
      ),
    );
  }
}

class ProductSearch extends SearchDelegate {
  final _fireStore = Firestore.instance;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection("products").snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "No data",
              style: TextStyle(color: Colors.black),
            ),
          );
        }
        final products = snapshot.data.documents;
        var featureProds = [];
        for (var product in products) {
          String str = product.data['name'];
          if (str.toLowerCase().contains(query.toLowerCase())) {
            featureProds.add(product);
          }
        }
        return GridView.builder(
            shrinkWrap: true,
            controller: ScrollController(
              keepScrollOffset: false,
            ),
            itemCount: featureProds.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 2,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ProductScreen(
                      name: featureProds[index]['name'],
                      description: featureProds[index]['description'],
                      category: featureProds[index]['category'],
                      brand: featureProds[index]['brand'],
                      pictures: featureProds[index]['images'],
                      price: featureProds[index]['price'],
                      sizes: featureProds[index]['sizes'],
                      qte: featureProds[index]['qte'],
                    );
                  }));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                  elevation: 4,
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              width: itemWidth - 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  height: 400,
                                  image: featureProds[index]['images'][0] ==
                                          null
                                      ? AssetImage("images/image_not_found.png")
                                      : NetworkImage(
                                          featureProds[index]['images'][0]),
                                  fit: featureProds[index]['images'][0] == null
                                      ? BoxFit.contain
                                      : BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  featureProds[index]['name'],
                                  style: TextStyle(
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 25,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Center(
                                    child: Text(
                                      "${featureProds[index]['qte']} Items",
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${featureProds[index]['price']} DH',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection("products").snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Text(
              "No data",
              style: TextStyle(color: Colors.black),
            ),
          );
        }
        final products = snapshot.data.documents;
        var featureProds = [];
        for (var product in products) {
          String str = product.data['name'];
          if (str.toLowerCase().contains(query.toLowerCase())) {
            featureProds.add(product);
          }
        }
        return GridView.builder(
            shrinkWrap: true,
            controller: ScrollController(
              keepScrollOffset: false,
            ),
            itemCount: featureProds.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 2,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ProductScreen(
                      name: featureProds[index]['name'],
                      description: featureProds[index]['description'],
                      category: featureProds[index]['category'],
                      brand: featureProds[index]['brand'],
                      pictures: featureProds[index]['images'],
                      price: featureProds[index]['price'],
                      sizes: featureProds[index]['sizes'],
                      qte: featureProds[index]['qte'],
                    );
                  }));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                  elevation: 4,
//                  color: Colors.black,
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              width: itemWidth - 20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  height: 400,
                                  image: featureProds[index]['images'][0] ==
                                          null
                                      ? AssetImage("images/image_not_found.png")
                                      : NetworkImage(
                                          featureProds[index]['images'][0]),
                                  fit: featureProds[index]['images'][0] == null
                                      ? BoxFit.contain
                                      : BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  featureProds[index]['name'],
                                  style: TextStyle(
                                    color: kColorBlack,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 17,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  height: 25,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: Center(
                                    child: Text(
                                      "${featureProds[index]['qte']} Items",
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontSize: 13),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${featureProds[index]['price']} DH',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            });
      },
    );
  }
}
