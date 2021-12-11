import 'package:pfeapp/model/product.dart';

class Cart {
  static List<Product> cartList=[];
  static void addToCart(Product prod){
    cartList.add(prod);
  }
}