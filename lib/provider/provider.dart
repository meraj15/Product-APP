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
  String selectedSortFilter = "No Filter";

  ValueNotifier<int> totalProductCards = ValueNotifier(0);

  void setProductSize(String size) {
    productSize = size;
    notifyListeners();
  }

  void setSort(String sort) {
    selectedSortFilter = sort;
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

  void deleteProductCard(Product product) {
    favorite.removeWhere(
      (element) => element.id == product.id,
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

  void productPriceHightoLow() {
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < products.length - i - 1; j++) {
        if (products[j].price < products[j + 1].price) {
          final temp = products[j];
          products[j] = products[j + 1];
          products[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }

  void productPriceLowtoHigh() {
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < products.length - i - 1; j++) {
        if (products[j].price > products[j + 1].price) {
          final temp = products[j];
          products[j] = products[j + 1];
          products[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }

  void productRatingHightoLow() {
    for (int i = 0; i < products.length; i++) {
      for (int j = 0; j < products.length - i - 1; j++) {
        if (products[j].rating < products[j + 1].rating) {
          final temp = products[j];
          products[j] = products[j + 1];
          products[j + 1] = temp;
        }
      }
    }
    notifyListeners();
  }
}
