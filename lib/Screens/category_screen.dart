import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pfeapp/provider/result_category.dart';

class CategoryScreen extends StatefulWidget {
  static final String id = "category_screen";

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _fireStore= Firestore.instance;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xffededf3),
      body:ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          /*Stack(
            overflow: Overflow.visible,
            children: <Widget>[
                Container(
                  height: 100,
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

                Positioned(
                  top: 50,
                  left:(MediaQuery.of(context).size.width) /3+20,
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
                          offset:
                          Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Center(
                      child: Image(
                        height: 60,
                        width: 60,
                        fit: BoxFit.contain,
                        image: AssetImage("images/logo_inter.png"),
                      ),
                    ),
                  ),
                )
              ],
          ),*/
          Padding(
            padding: const EdgeInsets.fromLTRB(0,15,0,8),
            child: StreamBuilder<QuerySnapshot>(
              stream: _fireStore.collection("categories").snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if(!snapshot.hasData) {
                  return Center(child: Text("No category found!"));
                }
                final categories = snapshot.data.documents;
                var categoriesList = [];
                for(var category in categories){
                  categoriesList.add(category.data);
                }
                return /*SizedBox(
                  height: double.maxFinite,
                  child: ListView.builder(
                      itemCount: categoriesList.length,
                      itemBuilder: (BuildContext context,int index){
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.blue
                          ),
                          height: 100,
                          width: double.infinity,
                          child: Image(
                            image: NetworkImage(categoriesList[index]['picture']),
                            fit: BoxFit.fill,
                          ),

                        );
                      },
                  ),
                );*/
                GridView.builder(
                    shrinkWrap: true,
                    controller: ScrollController(
                      keepScrollOffset: false,
                    ),
                    itemCount: categoriesList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing:10,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                    ),
                    itemBuilder: (BuildContext context,int index){
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (BuildContext context) {
                            return ResultCategory(categoriesList[index]['category']);
                          }));
                        },
                        child: Stack(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20),
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
                                  child:ClipRRect(
                                    borderRadius:BorderRadius.all(
                                        Radius.circular(20)),
                                    child: Image(
                                      image: NetworkImage(categoriesList[index]['picture']),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                              ),
                            ),
                            Align(
                              alignment:Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(14,0,0,15),
                                child: Container(
                                  decoration:BoxDecoration(
                                    color: Colors.white70,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(8.0,0,8,0),
                                    child: Text(
                                      categoriesList[index]['category'],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color :Colors.black54,
                                          fontSize: 30,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                );
              },
            ),
          ),
        ],
      ),
    );
  }




}


