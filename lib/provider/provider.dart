import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:product_app/model/model.dart';

class ProductData extends ChangeNotifier {
  String endPoint = "https://dummyjson.com/products";
  bool isLoaded = true;
  String error = "";
  List<Product> product = [];
  List<Product> addCard = [];
  int productQuantity =1;
  void getData() async {
    try {
      Response response = await http.get(Uri.parse(endPoint));
      final decodeJson = jsonDecode(response.body);
      final getMap = decodeJson["products"];
      for (int i = 0; i < getMap.length; i++) {
        product.add(Product.fromJson(getMap[i]));
      }
      isLoaded = false;
      notifyListeners();
    } catch (e) {
      error = e.toString();
    }
  }

void increaseQuantity(){
  productQuantity++;
  notifyListeners();
}
  
  void decreaseQuantity(){
    if(productQuantity > 1){
  productQuantity--;

    }
  notifyListeners();
}
}
