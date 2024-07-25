import 'package:flutter/material.dart';
import 'package:product_app/view/login_screen.dart';

import '../Navigation/navigation.dart';
import '../view/add_cart.dart';
import '../view/favorite_card.dart';
import '../view/home_screen.dart';
import '../view/profile_screen.dart';
import '../view/shop_screen.dart';

class AppRoutes {
  static const String initialRoute = "/";
  static const String shopScreen = "shop_screen";

  static const String favoriteScreen = "favorite_screen";
  static const String addCardScreen = "add_card_screen";
  static const String profileScreen = "profile_screen";
  static const String homeScreen = "home_screen";
  static const String bottemNavigationBar = "bottem_navigationBar";

  static final Map<String, WidgetBuilder> routes = {
    "/": (_) => const LoginScreen(),
    shopScreen: (_) => const ShopScreen(),
    favoriteScreen: (_) => const Favorites(),
    addCardScreen: (_) => const AddCard(),
    profileScreen: (_) => const ProfileScreen(),
    homeScreen: (_) => const HomeScreen(),
    bottemNavigationBar: (_) => const BottemNavigationBar(),
  };
}
