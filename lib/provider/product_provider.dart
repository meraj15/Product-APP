import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:product_app/Auth/auth_service.dart';
import 'package:product_app/config/endpoint.dart';
import 'package:product_app/main.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/view/otp_screen.dart';
import 'package:product_app/view/sign_up_screen.dart';
import 'package:product_app/widget/toast.dart';

class ProductData extends ChangeNotifier {
  bool isLoaded = true;
  String error = "";
  List<Product> products = [];
  List<Product> addCard = [];
  List<Product> favorite = [];
  List<Product> filterFavorites = [];
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
  TextEditingController userSignPassword = TextEditingController();
  TextEditingController userSignConfirmPassword = TextEditingController();
  TextEditingController userSignMobile = TextEditingController();
  String signScreenErrorMsg = "";
  bool isMyOrdersLoaded = true;
  List<dynamic> userDetails = [];
  bool? isCheckBox = false;
  bool isPasswordObscured = true;
  List<Map<String, dynamic>> updatedCartQuantities = [];
  bool isReviewPosting = false;
  bool isLoginLoading = false;
  bool isSignLoading = false;
  String passwordErrorMsg = "";
  String emailErrorMsg = "";
  bool isFetchingCart = false;
  String? cartError;
  bool isFetchingAddress = false;
  String? addressError;
  bool isFetchingOrders = false;
  String? ordersError;
  bool isFetchingReviews = false;
  String? reviewsError;
  bool isFetchingUserDetails = false;
  String? userDetailsError;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;

  GoogleSignInAccount? get user => _user;

  Future logout() async {
    await googleSignIn.disconnect();
    await AuthService.logout();
    userID = "";
    _user = null;
    notifyListeners();
  }

  Future<void> googleLogin(BuildContext context) async {
    try {
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        _user = null;
        userID = "";
        debugPrint('Sign-in canceled by user');
        notifyListeners();
        return;
      }

      _user = googleUser;
      debugPrint('User signed in: ${user?.displayName}');
      debugPrint('Email: ${user?.email}');

      Map<String, dynamic> userCheckResult =
          await _checkUserInDatabase(googleUser.email);

      if (userCheckResult['exists']) {
        // Simulate login by calling /api/login with email (backend should handle Google Sign-In)
        final response = await http.post(
          Uri.parse(APIEndPoint.userLogin),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"email": googleUser.email, "password": ""}),
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data['status'] == "success") {
            userID = data['userId']?.toString() ?? "";
            final token = data['token'] ?? '';
            await AuthService.setLoginStatus(true);
            await AuthService.saveUserId(userID);
            await AuthService.saveToken(token);
            debugPrint("Existing user ID: $userID, token: $token");
            if (context.mounted) {
              Navigator.of(context)
                  .pushReplacementNamed(AppRoutes.bottemNavigationBar);
            }
          } else {
            debugPrint("Google login error: ${data['message']}");
            _user = null;
            userID = "";
            notifyListeners();
          }
        } else {
          debugPrint("Google login server error: ${response.statusCode}");
          _user = null;
          userID = "";
          notifyListeners();
        }
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SignUpScreen(
              email: TextEditingController(text: googleUser.email),
              name: TextEditingController(text: googleUser.displayName ?? ''),
              isGoogleSignIn: true,
            ),
          ),
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Google Sign-In error: $e');
      _user = null;
      userID = "";
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _checkUserInDatabase(String email) async {
    try {
      final response = await http.get(
        Uri.parse('${APIEndPoint.checkUserInDatabase}$email'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'exists': data['exists'] == true,
          'userId': data['userId'] ?? "",
        };
      } else {
        throw Exception('Failed to check user: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error checking user in database: $e');
      return {'exists': false, 'userId': ""};
    }
  }

  Future<bool> postSignUpData(Map<String, dynamic> pdata, BuildContext context,
      {bool isGoogleSignIn = false}) async {
    var url = Uri.parse(APIEndPoint.postSignUpData);
    try {
      isSignLoading = true;
      notifyListeners();

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(pdata),
      );
      final jsonData = jsonDecode(res.body);
      debugPrint("jsonData: $jsonData");

      if (jsonData['status'] == 'error') {
        signScreenErrorMsg = jsonData['message'] ?? "An error occurred";
        if (jsonData['message'] == 'Email already used') {
          signScreenErrorMsg =
              "Email already used. Please use a different email.";
        }
        notifyListeners();
        return false;
      }

      if (jsonData['status'] == 'success') {
        userID = jsonData['userId'] ?? "No User ID";
        // For Google Sign-In, assume backend returns a token
        final token = jsonData['token'] ?? '';
        await AuthService.setLoginStatus(true);
        await AuthService.saveUserId(userID);
        await AuthService.saveToken(token);
        debugPrint("User ID sign-up backend: $userID, token: $token");
        signScreenErrorMsg = "";
        if (isGoogleSignIn) {
          Navigator.of(context)
              .pushReplacementNamed(AppRoutes.bottemNavigationBar);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OTPScreen(
                email: pdata['email'],
                fromScreen: 'signUp',
              ),
            ),
          );
        }
        notifyListeners();
        return true;
      }

      signScreenErrorMsg = "Sign-Up failed. Please try again.";
      notifyListeners();
      return false;
    } catch (e) {
      signScreenErrorMsg = "An error occurred. Please try again.";
      notifyListeners();
      debugPrint("Error: $e");
      return false;
    } finally {
      isSignLoading = false;
      notifyListeners();
    }
  }

  void togglePasswordVisibility() {
    isPasswordObscured = !isPasswordObscured;
    notifyListeners();
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

  Future<void> getCartsData(BuildContext context) async {
    try {
      isFetchingCart = true;
      cartError = null;
      notifyListeners();

      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = APIEndPoint.getCartsData;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        addCard = decodeJson.map((json) => Product.fromJson(json)).toList();
        debugPrint("Cart loaded: ${addCard.length} items");
        updateTotalAmount();
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        cartError = "Failed to load cart. Please try again.";
        debugPrint("Failed to load cart: ${response.statusCode}");
        notifyListeners();
      }
    } catch (e) {
      cartError = "Error fetching cart data. Please try again.";
      debugPrint("Error fetching cart data: $e");
      notifyListeners();
    } finally {
      isFetchingCart = false;
      notifyListeners();
    }
  }

  Future<void> postcartsData(Map<String, dynamic> pdata, BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      pdata['price'] = double.tryParse(pdata['price'].toString()) ?? 0.0;
      pdata['quantity'] = pdata['quantity'] ?? 1;
      var url = Uri.parse(APIEndPoint.postcartsDataEndPoint);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(pdata),
      );

      if (response.statusCode == 201) {
        debugPrint("Item added to cart successfully");
        await getCartsData(context); // Refresh cart
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to add to cart: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error posting cart data: $e");
    }
  }

  Future<void> updateCartQuantity(List<Map<String, dynamic>> updatedQuantities, BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      var url = Uri.parse(APIEndPoint.updateCartQuantity);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(updatedQuantities),
      );

      if (response.statusCode == 200) {
        debugPrint("Cart quantities updated successfully");
        await getCartsData(context); // Refresh cart
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to update cart quantities: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error updating cart quantities: $e");
    }
  }

  Future<void> deleteCartData(int index, BuildContext context) async {
    final idToDelete = addCard[index].id;

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = Uri.parse("${APIEndPoint.deleteCartData}/$idToDelete");
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        addCard.removeAt(index);
        updateTotalAmount();
        debugPrint("Cart item deleted successfully");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to delete cart item: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error deleting cart item: $e");
    }
  }

  Future<void> deleteAllCarts(BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = Uri.parse(APIEndPoint.deleteAllCarts);
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        addCard.clear();
        updateTotalAmount();
        debugPrint("All cart items deleted successfully");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else if (response.statusCode == 404) {
        debugPrint("No cart items found to delete");
      } else {
        debugPrint("Failed to delete all carts: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error deleting all carts: $e");
    }
  }

  Future<void> getFavouriteData(BuildContext context) async {
    try {
      isFetchingCart = true;
      cartError = null;
      notifyListeners();

      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = APIEndPoint.getFavouriteData;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        favorite = decodeJson.map((json) => Product.fromJson(json)).toList();
        debugPrint("Favorites loaded: ${favorite.length} items");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to load favourites: ${response.statusCode}");
        cartError = "Failed to load favorites. Please try again.";
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
      cartError = "Error fetching favorites. Please try again.";
      notifyListeners();
    } finally {
      isFetchingCart = false;
      notifyListeners();
    }
  }

  Future<void> postfavouriteData(Map<String, dynamic> pdata, BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      pdata['price'] = double.tryParse(pdata['price'].toString()) ?? 0.0;
      var url = Uri.parse(APIEndPoint.postfavouriteData);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(pdata),
      );

      if (response.statusCode == 201) {
        debugPrint("Favorite added successfully");
        await getFavouriteData(context); // Refresh favorites
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to add favorite: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error posting favorite data: $e");
    }
  }

  Future<void> deleteFavouriteData(int index, BuildContext context) async {
    final idToDelete = favorite[index].id;

    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = Uri.parse("${APIEndPoint.deleteFavouriteData}/$idToDelete");
      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        favorite.removeAt(index);
        debugPrint("Favorite removed successfully");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to delete favorite: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error deleting favorite: $e");
    }
  }

  Future<void> getAddressData(BuildContext context) async {
    try {
      isFetchingAddress = true;
      addressError = null;
      notifyListeners();

      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = APIEndPoint.getAddressData;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          final address = data['address'];
          userName.text = address['name'] ?? '';
          userStreet.text = address['street'] ?? '';
          userCity.text = address['city'] ?? '';
          userState.text = address['state'] ?? '';
          userZipCode.text = address['zipcode']?.toString() ?? '';
          userCountry.text = address['country'] ?? '';
          isAddressFetched = true;
          debugPrint("Address loaded successfully");
          notifyListeners();
        } else {
          isAddressFetched = false;
          userName.clear();
          userStreet.clear();
          userCity.clear();
          userState.clear();
          userZipCode.clear();
          userCountry.clear();
          debugPrint("No address found for this user");
          notifyListeners();
        }
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        addressError = "Failed to load address. Please try again.";
        debugPrint("Failed to load address: ${response.statusCode}");
        notifyListeners();
      }
    } catch (e) {
      addressError = "Error fetching address. Please try again.";
      debugPrint("Error fetching address: $e");
      notifyListeners();
    } finally {
      isFetchingAddress = false;
      notifyListeners();
    }
  }

  Future<void> saveAddress(Map<String, dynamic> data, BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = Uri.parse(APIEndPoint.saveAddress);
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        debugPrint("Address saved successfully");
        await getAddressData(context); // Refresh address
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to save address: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error saving address: $e");
    }
  }

  Future<void> updateAddressData(BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = Uri.parse(APIEndPoint.updateAddressData);
      final response = await http.patch(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'name': userName.text,
          'street': userStreet.text,
          'city': userCity.text,
          'state': userState.text,
          'zipcode': userZipCode.text,
          'country': userCountry.text,
        }),
      );

      if (response.statusCode == 200) {
        debugPrint("Address updated successfully");
        await getAddressData(context); // Refresh address
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to update address: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error updating address: $e");
    }
  }

  Future<void> fetchMyAllOrders(BuildContext context) async {
    try {
      isFetchingOrders = true;
      ordersError = null;
      notifyListeners();

      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = APIEndPoint.fetchMyAllOrders;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        userAllOrders = decodeJson;
        isOrderAllLoading = false;
        debugPrint("Orders loaded: ${userAllOrders.length} items");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        ordersError = "Failed to load orders. Please try again.";
        debugPrint("Failed to load orders: ${response.statusCode}");
        notifyListeners();
      }
    } catch (e) {
      ordersError = "Error fetching orders. Please try again.";
      debugPrint("Error fetching orders: $e");
      notifyListeners();
    } finally {
      isFetchingOrders = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserOrders(BuildContext context) async {
    try {
      isFetchingOrders = true;
      ordersError = null;
      notifyListeners();

      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = APIEndPoint.fetchUserOrders;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        orderUsername = decodeJson.isNotEmpty ? decodeJson[0]["name"] ?? "" : "";
        debugPrint("orderUsername: $orderUsername");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to load user orders: ${response.statusCode}");
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error fetching user orders: $e");
      notifyListeners();
    } finally {
      isFetchingOrders = false;
      notifyListeners();
    }
  }

  Future<void> postOrder(BuildContext context) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final DateTime orderTime = DateTime.now();
      final response = await http.post(
        Uri.parse(APIEndPoint.postOrder),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          'price': totalAmount,
          'order_time': formatOrderTime(orderTime),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['message'] == "Order placed successfully") {
          await deleteAllCarts(context);
          debugPrint("Order placed successfully");
          notifyListeners();
        }
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to place order: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error posting order: $e");
    }
  }

  Future<void> postReviews(BuildContext context, Map<String, dynamic> reviewData, int productId) async {
    try {
      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final response = await http.post(
        Uri.parse('${APIEndPoint.postReviews}/products/$productId/reviews'),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(reviewData),
      );

      if (response.statusCode == 201) {
        if (context.mounted) {
          Navigator.pop(context);
          CustomToast.showCustomToast(context, 'Review submitted successfully!');
        }
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        debugPrint("Failed to submit review: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error posting review: $e");
    }
  }

  Future<void> fetchMyAllReviews(BuildContext context) async {
    try {
      isFetchingReviews = true;
      reviewsError = null;
      notifyListeners();

      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = APIEndPoint.fetchMyAllReviews;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body) as List<dynamic>;
        userAllReviews = decodeJson;
        debugPrint("Reviews loaded: ${userAllReviews.length} items");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        reviewsError = "Failed to load reviews. Please try again.";
        debugPrint("Failed to load reviews: ${response.statusCode}");
        notifyListeners();
      }
    } catch (e) {
      reviewsError = "Error fetching reviews. Please try again.";
      debugPrint("Error fetching reviews: $e");
      notifyListeners();
    } finally {
      isFetchingReviews = false;
      notifyListeners();
    }
  }

  Future<void> getUserDetail(BuildContext context) async {
    try {
      isFetchingUserDetails = true;
      userDetailsError = null;
      notifyListeners();

      final token = await AuthService.getToken();
      if (token == null) {
        debugPrint("No token found, user not authenticated");
        await _handleUnauthorized(context);
        return;
      }

      final url = APIEndPoint.getUserDetail;
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodeJson = jsonDecode(response.body);
        userDetails = [decodeJson]; // Backend returns single object
        debugPrint("User details loaded: $userDetails");
        notifyListeners();
      } else if (response.statusCode == 401) {
        debugPrint("Unauthorized: Invalid or expired token");
        await _handleUnauthorized(context);
      } else {
        userDetailsError = "Failed to load user details. Please try again.";
        debugPrint("Failed to load user details: ${response.statusCode}");
        notifyListeners();
      }
    } catch (e) {
      userDetailsError = "Error fetching user details. Please try again.";
      debugPrint("Error fetching user details: $e");
      notifyListeners();
    } finally {
      isFetchingUserDetails = false;
      notifyListeners();
    }
  }

  Future<void> _handleUnauthorized(BuildContext context) async {
    await AuthService.logout();
    userID = "";
    _user = null;
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.initialRoute,
        (route) => false,
      );
    }
  }

  String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return "A";
    List<String> parts = name.trim().split(' ');
    return parts.length > 1 ? '${parts[0][0]}${parts[1][0]}' : parts[0][0];
  }

  Future<void> toggleFavorite(
      Product product, Map<String, dynamic> pdata, BuildContext context) async {
    try {
      notifyListeners();
      if (favorite.contains(product)) {
        final index = favorite.indexOf(product);
        await deleteFavouriteData(index, context);
      } else {
        favorites(product);
        await postfavouriteData(pdata, context);
      }
    } catch (e) {
      debugPrint("Error toggling favorite: $e");
    } finally {
      notifyListeners();
    }
  }

  void favorites(Product product) {
    if (favorite.contains(product)) {
      favorite.remove(product);
    } else {
      favorite.add(product);
    }
    notifyListeners();
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
    notifyListeners();
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

  Future<void> userLogin(
      String email, String password, BuildContext context) async {
    try {
      emailErrorMsg = '';
      passwordErrorMsg = '';
      isLoginLoading = true;
      notifyListeners();

      final response = await http.post(
        Uri.parse(APIEndPoint.userLogin),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"email": email.trim().toLowerCase(), "password": password}),
      );

      debugPrint("Login response: ${response.statusCode} - ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == "success") {
          userID = data['userId']?.toString() ?? "No User ID";
          final token = data['token'] ?? '';
          await AuthService.setLoginStatus(true);
          await AuthService.saveUserId(userID);
          await AuthService.saveToken(token);
          debugPrint("Login success, userID: $userID, token: $token");
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.bottemNavigationBar,
              (route) => false,
            );
          }
        } else {
          if (data['message'] == "Email not found. Please sign up.") {
            emailErrorMsg = data['message'];
          } else if (data['message'] ==
              "Incorrect password. Please try again.") {
            passwordErrorMsg = data['message'];
          } else {
            emailErrorMsg = data['message'] ?? "Invalid email or password.";
          }
          debugPrint("Login error: ${data['message']}");
          notifyListeners();
        }
      } else {
        emailErrorMsg = "Server error: ${response.statusCode}";
        debugPrint("Server error: $emailErrorMsg");
        notifyListeners();
      }
    } catch (e, stackTrace) {
      emailErrorMsg = "An error occurred. Please try again.";
      debugPrint("Login exception: $e\n$stackTrace");
      notifyListeners();
    } finally {
      isLoginLoading = false;
      notifyListeners();
    }
  }

  String formatOrderTime(DateTime orderTime) {
    return DateFormat('hh:mm a').format(orderTime);
  }

  void updateOrderStatus(String orderId, String newStatus) async {
    final url = "${APIEndPoint.updateOrderStatus}/$orderId";
    final headers = {"Content-Type": "application/json"};
    final body = jsonEncode({"order_status": newStatus});

    try {
      final response = await http.put(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint("Order status successfully updated to $newStatus");
        notifyListeners();
      } else {
        debugPrint(
            "Failed to update order status. Status code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error updating order status: $e");
    }
  }
}