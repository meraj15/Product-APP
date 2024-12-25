import 'package:flutter/material.dart';
import 'package:product_app/main.dart';
import 'package:product_app/view/address_form_screen.dart';
import 'package:product_app/view/login_screen.dart';
import 'package:product_app/view/sign_up_screen.dart';

import '../Navigation/navigation.dart';
import '../view/add_cart.dart';
import '../view/favorite_card.dart';
import '../view/home_screen.dart';
import '../view/profile_screen.dart';
import '../view/shop_screen.dart';

class AppRoutes {
  static  String initialRoute = isLogged ? "bottem_navigationBar" : "/";
  static const String shopScreen = "shop_screen";

  static const String favoriteScreen = "favorite_screen";
  static const String addCardScreen = "add_card_screen";
  static const String profileScreen = "profile_screen";
  static const String homeScreen = "home_screen";
  static const String bottemNavigationBar = "bottem_navigationBar";
  static const String addressForm = "address_form";
  static const String signupScreen = "sign_up_screen";


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
  };
}
