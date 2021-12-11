import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pfeapp/constants.dart';



class ProductCart extends StatefulWidget {
  final FirebaseUser loggedUser;


  ProductCart(this.loggedUser);

  @override
  _ProductCartState createState() => _ProductCartState();
}

class _ProductCartState extends State<ProductCart> {
  final _fireStore=Firestore.instance;
  var productOnCart=[
    {
      "title":"Collection",
      "picture":'images/products/c1.jpg',
      "price":400.0,
      'oldPrice':500,
      'descriptionBig':"Un texte est une série orale ou écrite de mots "
          "perçus comme constituant un ensemble cohérent, porteur de sens"
          " et utilisant les structures propres à une langue",
      'quantite':1

    },
    {
      "title":"Nike S456",
      "picture":'images/products/s1.jpg',
      "price":400.0,
      'oldPrice':500,
      'descriptionBig':"Un texte est une série orale ou écrite de mots "
          "perçus comme constituant un ensemble cohérent, porteur de sens"
          " et utilisant les structures propres à une langue",
      'quantite':1
    },
    {
      "title":"Nike S456",
      "picture":'images/products/s1.jpg',
      "price":400.0,
      'oldPrice':500,
      'descriptionBig':"Un texte est une série orale ou écrite de mots "
          "perçus comme constituant un ensemble cohérent, porteur de sens"
          " et utilisant les structures propres à une langue",
      'quantite':1
    },
    {
      "title":"Nike S456",
      "picture":'images/products/s1.jpg',
      "price":400.0,
      'oldPrice':500,
      'descriptionBig':"Un texte est une série orale ou écrite de mots "
          "perçus comme constituant un ensemble cohérent, porteur de sens"
          " et utilisant les structures propres à une langue",
      'quantite':1
    },
    {
      "title":"Nike S456",
      "picture":'images/products/s1.jpg',
      "price":400.0,
      'oldPrice':500,
      'descriptionBig':"Un texte est une série orale ou écrite de mots "
          "perçus comme constituant un ensemble cohérent, porteur de sens"
          " et utilisant les structures propres à une langue",
      'quantite':1
    },

  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: productOnCart.length,
      itemBuilder: (context , index){
        return widget.loggedUser.uid==null
            ?Center(child: Text("UID = NULL"))
            :StreamBuilder(
          stream: _fireStore.collection('cart').snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData) {
              return Center(child: Text('Loading...'));
            }
            final prodsCart=snapshot.data.documents;
            var cartList=[];
            for(var id in prodsCart) {
              if(widget.loggedUser.uid==id.data['userId']){
                cartList.add(id.data['productsIds']);
                print(id.data);
              }else if(widget.loggedUser.uid==null){
                print("uid is NULL================");
              }

            }

            return Text("${cartList.toList()}");
          },
        );
      },
    );
  }
}

class SingleProductCart2 extends StatefulWidget {
  final String cartProdTitle;
  final String cartProdDescriptionSmall;
  final String cartProdDescriptionBig;
  final String cartProdUrl;
  final double cartProdPrice;
  final int cartProdQte;


  SingleProductCart2({this.cartProdTitle, this.cartProdDescriptionSmall,
      this.cartProdDescriptionBig, this.cartProdUrl, this.cartProdPrice,
      this.cartProdQte});

  @override
  _SingleProductCart2State createState() => _SingleProductCart2State();
}

class _SingleProductCart2State extends State<SingleProductCart2> {
  Color iconButtonColor=kColorBlack;
  bool isSelect=false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 100.0,
        margin: new EdgeInsets.all(10.0),
        decoration: new BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
          gradient: new LinearGradient(
            colors: [kColorOrange,Colors.orange[200]],
            begin: Alignment.topLeft,
            end: Alignment.centerRight,
            tileMode: TileMode.clamp,
          ),
          boxShadow:  [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                ),
                child: ClipRRect(
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                  child: Image(
                    image: AssetImage(widget.cartProdUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: ListTile(
                      title: Text(widget.cartProdTitle,
                        style: kProductTitleStyle.copyWith(color: Colors.white),
                      ),
                      subtitle:Text('ce Produit peut etre kda w kda ',
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text('${widget.cartProdPrice.toInt()} Dh'),
                          ),
                        ),Expanded(
                          child: ListTile(
                            title: Center(child: Text('Qté: ${widget.cartProdQte}')),
                          ),
                        ),
                      ],
                    ),
                  )

                ],
              ),
            ),
            IconButton(
                padding: EdgeInsets.all(8),
                iconSize: 40,
                color: iconButtonColor,
                focusColor: Colors.red[900],
                hoverColor: Colors.red[900],
                onPressed: (){
                  setState(() {
                    isSelect=!isSelect;
                    if(isSelect) {
                      iconButtonColor=Colors.red[900];
                    }else iconButtonColor=kColorBlack;
                  });
                },
                icon:Icon(Icons.delete)
            )
          ],
        )
    ) ;
  }
}




