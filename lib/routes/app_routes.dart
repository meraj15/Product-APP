import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:product_app/main.dart';
import 'package:product_app/view/add_new_card_payment.dart';
import 'package:product_app/view/address_form_screen.dart';
import 'package:product_app/view/all_user_reviews.dart';
import 'package:product_app/view/login_screen.dart';
import 'package:product_app/view/order_items_screen.dart';
import 'package:product_app/view/payment_method_screen.dart';
import 'package:product_app/view/reviews_screen.dart';
import 'package:product_app/view/sign_up_screen.dart';

import '../Navigation/navigation.dart';
import '../view/add_carts_screen.dart';
import '../view/favorite_card.dart';
import '../view/home_screen.dart';
import '../view/my_order_screen.dart';
import '../view/order_screen.dart';
import '../view/profile_screen.dart';
import '../view/shop_screen.dart';

class AppRoutes {
  // static  String initialRoute = isLogged ? "bottem_navigationBar" : "/";
  static  String initialRoute = isLogged ? "bottem_navigationBar" : "/";
  static const String shopScreen = "shop_screen";
  static const String favoriteScreen = "favorite_screen";
  static const String addCardScreen = "add_card_screen";
  static const String profileScreen = "profile_screen";
  static const String homeScreen = "home_screen";
  static const String bottemNavigationBar = "bottem_navigationBar";
  static const String addressForm = "address_form";
  static const String signupScreen = "sign_up_screen";
   static const String orderScreen = "order_screen";
   static const String myorderScreen = "my_order_screen";
   static const String myallreviews = "my_all_reviews";
   static const String paymentmethodscreen = "payment_method_screen";
   static const String addCardpaymentscreen = "addCard_payment_screen";
  

  static final Map<String, WidgetBuilder> routes = {
    "/": (_) => const LoginScreen(),
    shopScreen: (_) => const ShopScreen(),
    favoriteScreen: (_) => const Favorites(),
    addCardScreen: (_) =>  AddCard(),
    profileScreen: (_) => const ProfileScreen(),
    homeScreen: (_) => const HomeScreen(),
    bottemNavigationBar: (_) => const BottemNavigationBar(),
    addressForm: (_) =>  AddressForm(),
    signupScreen:(_) => SignUpScreen(),
    orderScreen : (_) => OrdersScreen(),
    myorderScreen:(_) => MyOrderScreen(),
    myallreviews:(_)=>AllMyReviews(),
 paymentmethodscreen:(_)=>PaymentMethodScreen(),
 addCardpaymentscreen:(_)=>const AddCardPaymentScreen(),
  };
}
