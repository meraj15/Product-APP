import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/config/endpoint.dart';
import 'package:product_app/main.dart';
import 'package:product_app/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductData extends ChangeNotifier {
  bool isLoaded = true;
  String error = "";
  List<Product> products = [];
  List addCard = [];
  List<Product> favorite = [];
  List<Product> filterFavorites = [];
  List<String> jsonProducts = [];
  List<String> jsonCards = [];
  String selectedFilter = "";
  String productSize = '';
  String selectedSortFilter = "No Filter";
  TextEditingController userInput = TextEditingController();
  int addCardLength = 0;
  bool isAddressFetched = false;
  List<dynamic> userAllOrders = [];
  bool isOrderAllLoading = true;
  List<Product> orderedItems = [];
  List<dynamic> orderItemsQuantityList=[];
  String orderUsername = "";
  Map<String,dynamic> upadateQuantity = {};


  TextEditingController userName = TextEditingController();
  TextEditingController userStreet = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userState = TextEditingController();
  TextEditingController userZipCode = TextEditingController();
  TextEditingController userCountry = TextEditingController();

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

  void updateUI() {
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

  // double get totalPrice {
  //   double total = 0.0;
  //   for (var product in addCard) {
  //     total += product.price * product.productQuantity;
  //   }
  //   return total;
  // }

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
    // final List<Map> mapProducts = favorite.map((p) => productToMap(p)).toList();
    final List<Map> mapCards = addCard.map((c) => productToMap(c)).toList();
    // jsonProducts = mapProducts.map((mp) => jsonEncode(mp)).toList();
    jsonCards = mapCards.map((mc) => jsonEncode(mc)).toList();
    final SharedPreferences data = await SharedPreferences.getInstance();
    data.setStringList("Product", jsonProducts);
    data.setStringList("Card", jsonCards);
    data.setString("userName", userName.text);
    // data.setString("userAddress", userAddress.text);
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
      // final List<Product> dbProducts =
      mapDBData.map((m) => mapToProduct(m)).toList();
      // favorite = dbProducts;
    }

    if (jsonCards != null) {
      final List<Map> mapCardDBData =
          jsonCards.map((json) => jsonDecode(json)).toList().cast<Map>();
      final List<Product> dbCards =
          mapCardDBData.map((m) => mapToProduct(m)).toList();
      addCard = dbCards;
    }

    addCardLength = addCard.length;
    userName.text = data.getString("userName") ?? "Khan Meraj";
    // userAddress.text = data.getString("userAddress") ?? "Hairan Gali";
    userCity.text = data.getString("userCity") ?? "Mumbai";
    userState.text = data.getString("userState") ?? "Maharashtra";
    userZipCode.text = data.getString("userZipCode") ?? "400070";
    userCountry.text = data.getString("userCountry") ?? "India";

    notifyListeners();
  }


  void postcartsData(Map<String, dynamic> pdata) async {
  pdata['price'] = double.tryParse(pdata['price'].toString()) ?? 0.0;

  var url = Uri.parse("http://192.168.0.110:3000/api/carts");
  
  pdata['quantity'] = pdata['quantity'] ?? 1; 

  await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(pdata),
  );
  getData();
}

void updateCartQuantity(Map<String, dynamic> pdata) async {
  var url = Uri.parse("http://192.168.0.110:3000/api/update-card-quantity");
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pdata),
    );
}




  void getCartsData(String userid) async {
    final url = "http://192.168.0.110:3000/api/carts/$userid";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        addCard = decodeJson.map((json) => Product.fromJson(json)).toList();
        debugPrint(" addCard : $addCard");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching cart data: $e");
    }
  }

  void deleteCartData(int index) async {
    final idToDelete = addCard[index].id;

    try {
      final url = Uri.parse("http://192.168.0.110:3000/api/carts/$idToDelete");
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        addCard.removeAt(index);
        notifyListeners();
      } else {
        debugPrint(
            "Failed to delete data. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error deleting data: $e");
    }
  }

  void toggleFavorite(Product product, Map<String, dynamic> pdata) async {
    if (favorite.contains(product)) {
      final index = favorite.indexOf(product);
      deleteFavouriteData(index);
    } else {
      favorites(product);
      postfavouriteData(pdata);
    }
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

  void postfavouriteData(Map<String, dynamic> pdata) async {
    pdata['price'] = double.tryParse(pdata['price'].toString()) ?? 0.0;

    var url = Uri.parse("http://192.168.0.110:3000/api/favourites");
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pdata),
      );
      debugPrint("Data posted successfully in favourites: ${res.body}");
    } catch (e) {
      debugPrint("Error posting data: $e");
    }
  }

  void deleteFavouriteData(int index) async {
    final idToDelete = favorite[index].id;
    final url =
        Uri.parse("http://192.168.0.110:3000/api/favourites/$idToDelete");
    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        favorite.removeAt(index);
        notifyListeners();
        debugPrint("Data removed successfully from favorites.");
      } else {
        debugPrint("Failed to delete item: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error deleting item: $e");
    }
  }

  void getFavouriteData(String userId) async {
    final url = "http://192.168.0.110:3000/api/favourites/$userId";
    debugPrint("favorite jfjxjbhfkbk");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodeJson = jsonDecode(response.body) as List<dynamic>;

      favorite = decodeJson.map((json) => Product.fromJson(json)).toList();
      debugPrint("favorite  :$favorite");
      notifyListeners();
    } else {
      debugPrint("Failed to load favourites: ${response.statusCode}");
    }
  }

  void saveAddress(Map data) async {
    final url = Uri.parse("http://192.168.0.110:3000/api/address");
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  void updateData(String userId) async {
    final url = Uri.parse("http://192.168.0.110:3000/api/address/$userId");
    final response = await http.patch(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'name': userName.text,
        'street': userStreet.text,
        'city': userCity.text,
        'state': userState.text,
        'zipcode': userZipCode.text.toString(),
        'country': userCountry.text,
      }),
    );

    // if (response.statusCode == 200) {
    //   final resData = jsonDecode(response.body);
    //   // ScaffoldMessenger.of(context).showSnackBar(
    //   //   SnackBar(
    //   //       content:
    //   //           Text(resData['message'] ?? "Address updated successfully")),
    //   // );
    // }
  }

  void getAddressData() async {
    final url = Uri.parse("http://192.168.0.110:3000/api/address/${userID}");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == "success") {
        final address = data['address'];

        userName.text = address['name'];
        userStreet.text = address['street'];
        userCity.text = address['city'];
        userState.text = address['state'];
        userZipCode.text = address['zipcode'].toString();
        userCountry.text = address['country'];
        isAddressFetched = true;
        notifyListeners();
      } else {
        debugPrint("No address found for this user.");
      }
    } else {
      debugPrint(
          "Failed to fetch address. Status Code: ${response.statusCode}");
    }
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      debugPrint("Location Denied");
      await Geolocator.requestPermission();
    } else {
      Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      debugPrint("Latitude=${currentPosition.latitude.toString()}");
      debugPrint("Longitude=${currentPosition.longitude.toString()}");

      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition.latitude,
        currentPosition.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[2];

        userStreet.text = place.thoroughfare ?? '';
        userCity.text = place.locality ?? '';
        userState.text = place.administrativeArea ?? '';
        userZipCode.text = place.postalCode ?? '';
        userCountry.text = place.country ?? '';

        debugPrint(
            "Address: ${place.thoroughfare}, ${place.locality}, ${place.administrativeArea}, ${place.postalCode}, ${place.country}");
      }
    }
  }

  void fetchMyAllOrders(String userId) async {
    final url = "http://192.168.0.110:3000/api/myorders/$userId";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;

        userAllOrders = decodeJson;

        isOrderAllLoading = false;
        notifyListeners();
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (error) {
      debugPrint("Error fetching user orders: $error");

      isOrderAllLoading = false;
      notifyListeners();
    }
  }

  void getOrderItems(String orderId) async {
    final url = "http://192.168.0.110:3000/api/orderitems/$orderId";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body) as List<dynamic>;

        orderedItems =
            decodedJson.map((json) => Product.fromJson(json)).toList();
            orderItemsQuantityList = decodedJson;
        debugPrint("orderedItems : $orderedItems");
        notifyListeners();
      } else {
        debugPrint(
            "Failed to fetch order items. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching order items: $e");
    }
  }

  void fetchUserOrders(String userId) async {
    final url = "http://192.168.0.110:3000/api/myorders/$userId";
    final response = await http.get(Uri.parse(url));
    final decodeJson = jsonDecode(response.body) as List<dynamic>;
    debugPrint("decodeJson my order : $decodeJson");
    orderUsername = decodeJson[0]["name"];
  }
}
