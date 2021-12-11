import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Product{
  /*void streamProduct() async{
    final firestore = Firestore.instance;
    await for(var snapshot in firestore.collection("products").snapshots()){
      for(var product in snapshot.documents){
        print(product.data);
      }

    }

  }*/

  //Constants names of firebase
  static const String BRAND= 'brand';
  static const String CATEGORY= 'category';
  static const String NAME= 'name';
  static const String ID= 'id';
  static const String PICTURES= 'pictures';
  static const String PRICE= 'price';
  static const String QTE= 'qte';
  static const String SIZE= 'size';

  /*//private variables
  String _brand;

  String _category;

  String _name;

  String _id;

  List<String> _pictures;

  List<String> _size;

  int _qte;
  
  double _price;

  //Getters
  String get brand => _brand;

  String get category => _category;

  double get price => _price;

  int get qte => _qte;

  List<String> get size => _size;

  List<String> get pictures => _pictures;

  String get id => _id;

  String get name => _name;*/
  String brand;

  String category;

  String name;

  String id;

  String description;

  var pictures;

  var sizes;

  int qte;

  String price;

  bool feature;

  Product({this.brand, this.category, this.name, this.id, this.pictures,
      this.sizes, this.qte, this.price,this.description,this.feature});




}