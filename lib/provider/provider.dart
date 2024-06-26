import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/model/model.dart';

class ProductData extends ChangeNotifier {
  String endPoint = "https://dummyjson.com/products";
  bool isLoaded = true;
  String error = "";
  List<Product> products = [];
  List<Product> addCard = [];
  List<Product> favorite = [];
  List<Product> filterFavorites = [];
  String selectedFilter = "";
  String productSize = '';
  ValueNotifier<int> totalProductCards = ValueNotifier(0);

  void setProductSize(String size) {
    productSize = size;
    notifyListeners();
  }

  void updateFilter(String filter) {
    selectedFilter = filter;
    notifyListeners();
  }

  Future<void> getData() async {
    try {
      final response = await http.get(Uri.parse(endPoint));
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body);
        final productsList = decodedJson["products"] as List<dynamic>;
        products = productsList.map((json) => Product.fromJson(json)).toList();
        isLoaded = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      error = e.toString();
    }
  }

  void deleteAddCard(int index) {
    addCard.removeAt(index);
    notifyListeners();
  }

  void deleteFavoriteCard(int index) {
    favorite.removeAt(index);
    notifyListeners();
  }

  void deleteFilteredCard(int index) {
    filterFavorites.removeWhere(
      (element) => element.id == index,
    );
    notifyListeners();
  }

  void favorites(Product product) {
    if (favorite.contains(product)) {
      favorite.remove(product);
    } else {
      favorite.add(product);
    }
    notifyListeners();
  }
}
