import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:pfeapp/Screens/new_screen.dart';
import 'package:pfeapp/constants.dart';

class CheckOutScreen extends StatefulWidget {
  static final String id = "checkOut_screen";

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedUser;
  bool isLoading=false;
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
  var productsListOrder = [];
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          elevation: 0,
          title: Text("Confirm order",style: TextStyle(color: Colors.black),),
        ),
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
                productsListOrder.add(product);
              }

              return ListView.builder(
                itemCount: productsList.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 200.0,
                    margin: new EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                      border: Border.fromBorderSide(BorderSide(
                        color: Colors.grey,
                      ))
                    ),
                    child: Row(
                      children: <Widget>[

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
                                        color: Colors.black, fontSize: 20),
                                  ),
                                  subtitle: Text(
                                    productsList[index]["description"],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: ListTile(
                                        title: Text(
                                            '${productsList[index]['price']} Dh'),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        title: Center(
                                            child: Text(
                                                'Qté selected: ${productsList[index]['selectedQte']}')),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: Text(
                                      'selected Sizes : ${productsList[index]['selectedSizes'].toString()}'
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),

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
                      onPressed: ()async {

                        for(int i=0;i<productsListOrder.length;i++) {
                         await _fireStore.collection('orders')
                              .document(loggedUser.uid)
                              .collection('productsOrders')
                              .document(productsListOrder[i]['id'])
                              .setData({
                            'id':productsListOrder[i]['id'],
                            'name': productsListOrder[i]['name'],
                            'category':productsListOrder[i]['category'],
                            'brand':productsListOrder[i]['brand'],
                            'qte':productsListOrder[i]['qte'],
                            'images':productsListOrder[i]['images'],
                            'sizes':productsListOrder[i]['sizes'],
                            'price':productsListOrder[i]['price'],
                            'description': productsListOrder[i]['description'],
                            'selectedQte': productsListOrder[i]['selectedQte'],
                            'selectedSizes': productsListOrder[i]['selectedSizes'],
                            'userId':loggedUser.uid,
                          }).then((_){
                            setState(() {
                              isLoading=true;
                            });

                            _fireStore.collection('cart')
                                .document(loggedUser.uid)
                            .collection('productsCart').getDocuments().then((snapshot){
                                for(DocumentSnapshot ds in snapshot.documents) {
                                  ds.reference.delete();
                                }

                            });
                           print('Success');
                           Navigator.pushReplacementNamed(context, NewScreen.id);
                            setState(() {
                              isLoading=false;
                            });

                         });
                        }

                       Fluttertoast.showToast(msg: 'your Order send');

                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20
                            ),
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

      ),
    );
  }
}
