import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/Auth/auth_service.dart';
import 'package:product_app/config/endpoint.dart';
import 'package:product_app/main.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/routes/app_routes.dart';

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
  List<dynamic> productReviews = [];
  List<dynamic> orderItemsQuantityList = [];
  String orderUsername = "";
  Map<String, dynamic> upadateQuantity = {};
  List<Map<String, dynamic>> productFirstReviews = [];
  double averageRating = 0.0;
  List<dynamic> userAllReviews = [];
  double totalAmount = 0.0;
  TextEditingController userName = TextEditingController();
  TextEditingController userStreet = TextEditingController();
  TextEditingController userCity = TextEditingController();
  TextEditingController userState = TextEditingController();
  TextEditingController userZipCode = TextEditingController();
  TextEditingController userCountry = TextEditingController();
    GlobalKey<FormState> formKeySignUp = GlobalKey<FormState>();
   TextEditingController signUpUserName = TextEditingController();
   TextEditingController userEmail = TextEditingController();
   TextEditingController userPassword = TextEditingController();
   TextEditingController userConfirmPassword = TextEditingController();
   TextEditingController userMobile = TextEditingController();
  String signScreenErrorMsg = "";
   GlobalKey<FormState> formKeyLogin = GlobalKey<FormState>();
   bool isMyOrdersLoaded =true;
  
  bool? isCheckBox = false;
  bool isClickedPasword = true;
  String loginScreenErrorMsg = "";

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
      final response =
          await http.get(Uri.parse(APIEndPoint.productGetEndPoint));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        products = decodeJson.map((json) => Product.fromJson(json)).toList();
        isLoaded = false;
        notifyListeners();
      } else {
        debugPrint("Failed to load products: ${response.body}");
        throw Exception('Failed to load products');
      }
    } catch (e) {
      debugPrint("Error fetching products: $e");
      error = e.toString();
    }
  }

  void updateTotalAmount() {
    totalAmount = 0.0;
    for (var product in addCard) {
      totalAmount += product.productQuantity * product.price;
    }
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

  void postcartsData(Map<String, dynamic> pdata) async {
    pdata['price'] = double.tryParse(pdata['price'].toString()) ?? 0.0;
    var url = Uri.parse(APIEndPoint.postcartsDataEndPoint);
    pdata['quantity'] = pdata['quantity'] ?? 1;
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(pdata),
    );
    getData();
  }

  void updateCartQuantity(List<Map<String, dynamic>> updatedQuantities) async {
    var url = Uri.parse(APIEndPoint.updateCartQuantity);
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedQuantities),
    );
  }

  void getCartsData(String userid) async {
    final url = "${APIEndPoint.getCartsData}/$userid";
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        addCard = decodeJson.map((json) => Product.fromJson(json)).toList();
        // debugPrint(" addCard : $addCard");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching cart data: $e");
    }
  }

  void deleteCartData(int index) async {
    final idToDelete = addCard[index].id;

    try {
      final url = Uri.parse("${APIEndPoint.deleteCartData}/$idToDelete");
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

    var url = Uri.parse(APIEndPoint.postfavouriteData);
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pdata),
      );
      // debugPrint("Data posted successfully in favourites: ${res.body}");
    } catch (e) {
      debugPrint("Error posting data: $e");
    }
  }

  void deleteFavouriteData(int index) async {
    final idToDelete = favorite[index].id;
    final url = Uri.parse("${APIEndPoint.deleteFavouriteData}/$idToDelete");
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
    final url = "${APIEndPoint.getFavouriteData}/$userId";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final decodeJson = jsonDecode(response.body) as List<dynamic>;

      favorite = decodeJson.map((json) => Product.fromJson(json)).toList();
      // debugPrint("favorite  :$favorite");
      notifyListeners();
    } else {
      debugPrint("Failed to load favourites: ${response.statusCode}");
    }
  }

  void saveAddress(Map data) async {
    final url = Uri.parse(APIEndPoint.saveAddress);
    await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
  }

  void updateData(String userId) async {
    final url = Uri.parse("http://192.168.0.110:3000/api/address/$userId");
    await http.patch(
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
    final url = Uri.parse("${APIEndPoint.getAddressData}/$userID");
    debugPrint("address usrId : $userID");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['status'] == "success") {
        final address = data['address'];
        debugPrint("if chala userid : $userID");

        userName.text = address['name'];
        userStreet.text = address['street'];
        userCity.text = address['city'];
        userState.text = address['state'];
        userZipCode.text = address['zipcode'].toString();
        userCountry.text = address['country'];
        isAddressFetched = true;
        notifyListeners();
      } else {
        isAddressFetched = false;
        userName.clear();
        userStreet.clear();
        userCity.clear();
        userState.clear();
        userZipCode.clear();
        userCountry.clear();
        notifyListeners();
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
      }
    }
  }

  void fetchMyAllOrders(String userId) async {
    final url = "${APIEndPoint.fetchMyAllOrders}/$userId";
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

  Future<void> getOrderItems(String orderId) async {
    debugPrint("orderId  :$orderId");
    final url = "${APIEndPoint.getOrderItems}/$orderId";
    try {
      final response = await http.get(Uri.parse(url));
        debugPrint("response.body : ${response.body}");

      if (response.statusCode == 200) {
        final decodedJson = jsonDecode(response.body) as List<dynamic>;
        debugPrint("decodedJson item : ${response.body}");

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
    final url = "${APIEndPoint.fetchUserOrders}/$userId";
    final response = await http.get(Uri.parse(url));
    final decodeJson = jsonDecode(response.body) as List<dynamic>;
    orderUsername = decodeJson[0]["name"];
    debugPrint("orderUsername : $orderUsername");
  }

  Future<void> postReviews(BuildContext context, Map reviewData, int productId) async {
    try {
      final response = await http.post(
        Uri.parse('${APIEndPoint.postReviews}/products/$productId/reviews'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reviewData),
      );

      if (response.statusCode == 201) {
        Navigator.pop(context); 
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Review submitted successfully!"),
          ),
        );
      } else {
        debugPrint("Failed to submit review. Error: ${response.body}");
      }
    } catch (e) {
      debugPrint("An error occurred: $e");
    }
  }

  void getReviews(int productId) async {
    final url = '${APIEndPoint.getReviews}/products/$productId/reviews';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        productFirstReviews = List<Map<String, dynamic>>.from(decodeJson);
        productReviews = decodeJson;
        notifyListeners();
      } else {
        throw Exception("Failed to load reviews");
      }
    } catch (error) {
      debugPrint("Error fetching reviews: $error");
    }
  }

  void fetchMyAllReviews(String userId) async {
    final url = "${APIEndPoint.fetchMyAllReviews}/$userId";
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;

        userAllReviews = decodeJson;

        notifyListeners();
      } else {
        throw Exception("Failed to load orders");
      }
    } catch (error) {
      debugPrint("Error fetching user orders: $error");
    }
  }

  Future<void> postSignUpData(Map<String, dynamic> pdata) async {
    var url = Uri.parse(APIEndPoint.postSignUpData);
    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pdata),
      );
      final jsonData = jsonDecode(res.body);
      if (jsonData['status'] == 'success') {
        userID = jsonData['userId'] ?? "No User ID";
        debugPrint("User ID sign-up backend: $userID");
        await AuthService.setLoginStatus(true);
        await AuthService.saveUserId(userID);
      } else {
        signScreenErrorMsg = jsonData['message'] ?? "Sign-Up failed";
        notifyListeners();
      }
    } catch (e) {
      signScreenErrorMsg = "An error occurred. Please try again.";
      notifyListeners();
      debugPrint("Error: $e");
    }
  }

  void userLogin(String email, String password, BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse(APIEndPoint.userLogin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          userID = data['userId'] ?? "No User ID";
          await AuthService.setLoginStatus(true);
          await AuthService.saveUserId(userID);
          debugPrint("userID : $userID");
          Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
        } else if (data['status'] == "error") {
          loginScreenErrorMsg = data['message'] ?? "Invalid email or password.";

          formKeyLogin.currentState!.validate();
          notifyListeners();
        }
      } else {
        loginScreenErrorMsg = "Server error: ${response.statusCode}";

        formKeyLogin.currentState!.validate();
        notifyListeners();
      }
    } catch (e) {
      loginScreenErrorMsg = "An error occurred. Please try again.";

      formKeyLogin.currentState!.validate();
      notifyListeners();
      debugPrint("Login Error: $e");
    }
  }
}
