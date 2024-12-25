import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/config/endpoint.dart';
import 'package:product_app/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductData extends ChangeNotifier {
  
  bool isLoaded = true;
  String error = "";
  List<Product> products = [];
  List<Product> addCard = [];
  List<Product> favorite = [];
  List<Product> filterFavorites = [];
  List<String> jsonProducts = [];
  List<String> jsonCards = [];
  String selectedFilter = "";
  String productSize = '';
  String selectedSortFilter = "No Filter";
  TextEditingController userInput = TextEditingController();
  int addCardLength = 0;

  TextEditingController userName = TextEditingController();
  TextEditingController userAddress = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userState = TextEditingController();
  TextEditingController userZipCode = TextEditingController();
  TextEditingController userCountry = TextEditingController();

  ValueNotifier<int> totalProductCards = ValueNotifier(0);

  void updateBadgeCount() {
    totalProductCards.value = addCardLength;
  }

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
      final response = await http.get(Uri.parse(APIEndPoint.productEndPoint));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        products = decodeJson.map((json) => Product.fromJson(json)).toList();
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
    addCardLength = addCard.length;
    updateBadgeCount();
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

  double get totalPrice {
    double total = 0.0;
    for (var product in addCard) {
      total += product.price * product.productQuantity;
    }
    return total;
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

  void saveData() async {
    final List<Map> mapProducts = favorite.map((p) => productToMap(p)).toList();
    final List<Map> mapCards = addCard.map((c) => productToMap(c)).toList();
    jsonProducts = mapProducts.map((mp) => jsonEncode(mp)).toList();
    jsonCards = mapCards.map((mc) => jsonEncode(mc)).toList();
    final SharedPreferences data = await SharedPreferences.getInstance();
    data.setStringList("Product", jsonProducts);
    data.setStringList("Card", jsonCards);
    data.setString("userName", userName.text);
    data.setString("userAddress", userAddress.text);
    data.setString("userCity", userCity.text);
    data.setString("userState", userState.text);
    data.setString("userZipCode", userZipCode.text);
    data.setString("userCountry", userCountry.text);
  }

  void loadData() async {
    final SharedPreferences data = await SharedPreferences.getInstance();

    final List<String>? jsonProducts = data.getStringList("Product");
    final List<String>? jsonCards = data.getStringList("Card");
    if (jsonProducts != null) {
      final List<Map> mapDBData =
          jsonProducts.map((json) => jsonDecode(json)).toList().cast<Map>();
      final List<Product> dbProducts =
          mapDBData.map((m) => mapToProduct(m)).toList();
      favorite = dbProducts;
    }

    if (jsonCards != null) {
      final List<Map> mapCardDBData =
          jsonCards.map((json) => jsonDecode(json)).toList().cast<Map>();
      final List<Product> dbCards =
          mapCardDBData.map((m) => mapToProduct(m)).toList();
      addCard = dbCards;
    }

    addCardLength = addCard.length;
    updateBadgeCount();
    userName.text = data.getString("userName") ?? "Khan Meraj";
    userAddress.text = data.getString("userAddress") ?? "Hairan Gali";
    userCity.text = data.getString("userCity") ?? "Mumbai";
    userState.text = data.getString("userState") ?? "Maharashtra";
    userZipCode.text = data.getString("userZipCode") ?? "400070";
    userCountry.text = data.getString("userCountry") ?? "India";

    notifyListeners();
  }
}
