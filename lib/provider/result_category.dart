import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pfeapp/Screens/product_screen.dart';
import 'package:pfeapp/constants.dart';
import 'package:pfeapp/model/product.dart';

class ResultCategory extends StatefulWidget {
  final category;

  ResultCategory(this.category);

  @override
  _ResultCategoryState createState() => _ResultCategoryState();
}

class _ResultCategoryState extends State<ResultCategory> {
  final _fireStore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.grey[600]
        ),
        elevation: 2,
        backgroundColor: Colors.white,
        title: Text(
          '${widget.category}',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey[600]
          ),
        ),
      ),
        body: StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection("products")
          .where('category', isEqualTo: widget.category)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data.documents;
        List<Product> productsList = [];
        for (var product in products) {
          Product prod = Product(
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
        return productsList.isEmpty
            ? Center(
                child: Text(
                  'No Items Found!',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600]
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                controller: ScrollController(
                  keepScrollOffset: false,
                ),
                itemCount: productsList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 2,
                  childAspectRatio: (itemWidth / itemHeight),
                ),
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print('pssssssssss====${productsList.length}');
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
                                      image: productsList[index].pictures[0] ==
                                              null
                                          ? AssetImage(
                                              "images/image_not_found.png")
                                          : NetworkImage(
                                              productsList[index].pictures[0]),
                                      fit: productsList[index].pictures[0] ==
                                              null
                                          ? BoxFit.contain
                                          : BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                color: Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15, 8, 0, 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      productsList[index].name,
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
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      child: Center(
                                        child: Text(
                                          "${productsList[index].qte} Items",
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
                                      '${productsList[index].price} DH',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
    ));
  }
}
