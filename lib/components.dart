import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfeapp/Screens/product_screen.dart';
import 'package:pfeapp/constants.dart';
import 'package:pfeapp/model/product.dart';
//================Drawer======================================
class DrawerElement extends StatelessWidget {
  final String titre;
  final Icon icon ;
  final onPress;


  DrawerElement({@required this.titre,@required this.icon,@required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: ListTile(
        dense: true,
        trailing: Icon(Icons.arrow_forward_ios),
        leading:icon,
        title: Text(
          titre,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
//================Search part=================================
class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(icon: Icon(Icons.clear),onPressed: (){},)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return
      IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: (){},)
    ;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return null;
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return null;
  }

}
//===================Category list=============================
class HorizantalListCat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child:ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          CategoryWidget(
            categoryIcon:'images/cats/sneaker_icon.png',
            categoryName: 'Sneakers',
          ),CategoryWidget(
            categoryIcon:'images/cats/shirt_icon.png',
            categoryName: 'T-Shirt',
          ),
          CategoryWidget(
            categoryIcon:'images/logo_inter.png',
            categoryName: 'Sneakers',
          )
        ],
      ) ,
    );
  }
}
class CategoryWidget extends StatelessWidget {
  final String categoryIcon;
  final String categoryName;
  BoxDecoration myBoxDecoration(){
    return BoxDecoration(
      border: Border.all(
        width: 1.5,
        color:Colors.grey,
      ),
      borderRadius: BorderRadius.all(Radius.circular(8))
    );
  }
  CategoryWidget({this.categoryIcon, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlineButton(
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
        onPressed: (){

        },
        highlightedBorderColor: kColorOrange,
        borderSide: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
        child: Container(
          width: 120,
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
//            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Image(
                image: AssetImage(categoryIcon),
                height: 25,
                width: 45,
              ),
              SizedBox(width: 5,),
              Text(categoryName)
            ],
          ),
        ),
      ),
    );
  }
}

//=================Product View===============================

class Products extends StatefulWidget {
  final String brandSelected;


  Products(this.brandSelected);

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final _firestore = Firestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return StreamBuilder<QuerySnapshot>(
      stream:_firestore.collection("products").where('brand',isEqualTo: widget.brandSelected).snapshots(),
      builder: (context,snapshot){
        if(!snapshot.hasData){
          return Center(child: Text("Loading..."));
        }
        final products = snapshot.data.documents;
             List<Product> productsList=[];
        for(var product in products){
          Product prod =Product(
            name:product.data["name"] ,
            pictures: product.data["images"],
            category: product.data["category"],
            price: product.data["price"],
            brand: product.data["brand"],
            id: product.data["id"],
            description: product.data["description"],
            qte: product.data["qte"],
            feature: product.data["feature"],
            sizes: product.data['sizes'],
          );
          productsList.add(prod);
        }
        return GridView.builder (
            shrinkWrap: true,
            controller: ScrollController(
              keepScrollOffset: false,
            ),
            itemCount:productsList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing:8,
              crossAxisSpacing: 2,
              childAspectRatio: (itemWidth / itemHeight),
            ),
            itemBuilder: (BuildContext context,int index){

              return GestureDetector(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                    return ProductScreen(
                      name: productsList[index].name,
                      description: productsList[index].description,
                      category: productsList[index].category,
                      brand: productsList[index].brand,
                      pictures: productsList[index].pictures,
                      price: productsList[index].price,
                      sizes: productsList[index].sizes,
                      qte: productsList[index].qte,
                      prodId: productsList[index].id,
                    );
                  }));
                },
                child: Card(
                  shape:RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0),
                  ),
                  elevation:4 ,
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
                                borderRadius: BorderRadius.all(Radius.circular(30)),

                              ),
                              width: itemWidth-20,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  height: 400,
                                  image: productsList[index].pictures[0] == null?
                                  AssetImage("images/image_not_found.png") :
                                  NetworkImage(productsList[index].pictures[0]),
                                  fit:productsList[index].pictures[0] == null?BoxFit.contain :BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),

                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,8,0,8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(productsList[index].name,
                                    style: TextStyle(
                                      color: kColorBlack,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 17,
                                    ),
                                ),
                                SizedBox(height:5 ,),
                                Container(
                                  height: 25,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.all(Radius.circular(8))
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${productsList[index].qte} Items",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontSize: 13
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height:5 ,),
                                Text('${productsList[index].price} DH',
                                  style: TextStyle(
                                    fontWeight:FontWeight.bold
                                  ),
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
            }
        );
      },
    );


  }
}


