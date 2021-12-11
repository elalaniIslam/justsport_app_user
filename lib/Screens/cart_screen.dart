import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pfeapp/Screens/checkOut_screen.dart';
import 'package:pfeapp/Screens/signin_screen.dart';
import 'package:pfeapp/constants.dart';
import 'package:pfeapp/round_button.dart';

class CartScreen extends StatefulWidget {
  static final String id = "cart_screen";
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  bool existe = false;
  void getCurrentUser() async {
    final user = await _auth.currentUser();

    try {
      if (user != null) {
        setState(() {
          existe = true;
        });
        loggedUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  final _fireStore = Firestore.instance;

  var productsList2 = [];
  @override
  Widget build(BuildContext context) {
    return existe
        ? Scaffold(
            //================== AppBar ===============================
            backgroundColor: Color(0xffededf3),

            appBar: AppBar(
                centerTitle: true,
                iconTheme: IconThemeData(color: kColorBlack),
                elevation: 0,
                backgroundColor: Color(0xffededf3),
                title: Text(
                  'My cart',
                  style: TextStyle(color: kColorBlack, fontSize: 25),
                )),

            //======================== Body ========================

            body: StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection('cart')
                    .document(loggedUser.uid)
                    .collection('productsCart')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: Text('Loading...'));
                  }
                  final prodsCart = snapshot.data.documents;
                  var productsList = [];
                  for (var product in prodsCart) {
                    productsList.add(product);
                    productsList2.add(product);
                  }

                  return ListView.builder(
                    itemCount: productsList.length,
                    itemBuilder: (context, index) {
                      return Container(
                        height: 100.0,
                        margin: new EdgeInsets.all(10.0),
                        decoration: new BoxDecoration(
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(10.0)),
                          gradient: new LinearGradient(
//                                colors: [kColorOrange,Colors.orange[200]],
                            colors: [Color(0xff00C6C2), Colors.lightBlueAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            tileMode: TileMode.clamp,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 4,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 90,
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10.0)),
                                ),
                                child: ClipRRect(
                                  borderRadius: new BorderRadius.all(
                                      new Radius.circular(10.0)),
                                  child: Image(
                                    image: NetworkImage(
                                        productsList[index]['images']),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: ListTile(
                                      title: Text(
                                        productsList[index]['name'],
                                        style: kProductTitleStyle.copyWith(
                                            color: Colors.white, fontSize: 20),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child:Padding(
                                            padding: const EdgeInsets.only(left:17.0),
                                            child: Container(
                                                width: 300,
                                                child: Text(
                                                    '${productsList[index]['price']} Dh',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 17
                                                  ),
                                                ),
                                              ),
                                          ),
                                        ),
                                        Expanded(
                                          child:  Center(
                                                child: Text(
                                                    'Qté: ${productsList[index]['selectedQte']}',
                                                  style: TextStyle(
                                                    fontSize: 16
                                                  ),
                                                )),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                                padding: EdgeInsets.all(8),
                                iconSize: 40,
                                color: kColorBlack,
                                focusColor: Colors.red[900],
                                hoverColor: Colors.red[900],
                                onPressed: () async {
                                  await _fireStore
                                      .collection('cart')
                                      .document(loggedUser.uid)
                                      .collection('productsCart')
                                      .document(productsList[index]['id'])
                                      .delete()
                                      .then((_) {
                                    Fluttertoast.showToast(msg: 'Item remove');
                                  });
                                },
                                icon: Icon(Icons.delete))
                          ],
                        ),
                      );
                    },
                  );
                }),

            //================= Bottom navigation Bar =======================

            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Color(0xffededf3),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text('Total :'),
                      subtitle: StreamBuilder<QuerySnapshot>(
                          stream: _fireStore
                              .collection('cart')
                              .document(loggedUser.uid)
                              .collection('productsCart')
                              .snapshots(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(child: Text('Loading...'));
                            }
                            final prodsCart = snapshot.data.documents;
                            var productsList = [];
                            for (var product in prodsCart) {
                              productsList.add(product);
                            }
                            double tot=0;

                            for(int i=0 ;i<productsList.length;i++){
                              tot+=double.parse(productsList[i]['price'])*productsList[i]['selectedQte'];
                            }
                            return Text('$tot Dh');
                          }),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: 10,
                      ),
                      child: FlatButton(
                          padding: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Color(0xff00C6C2),
                          onPressed: () {
                            Navigator.pushNamed(context, CheckOutScreen.id);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                "CHECK OUT",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.forward,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                  )
                ],
              ),
            ),
          )
        : NotLoginPage();
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
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
          ),
          Text(
            "Please Sign in",
            style: TextStyle(fontSize: 40),
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
    ));
  }
}
