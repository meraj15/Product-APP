import 'package:flutter/material.dart';

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

  static final Map<String, WidgetBuilder> routes = {
    initialRoute: (_) => const BottemNavigationBar(),
    shopScreen: (_) => const ShopScreen(),
    favoriteScreen: (_) => const Favorites(),
    addCardScreen: (_) => const AddCard(),
    profileScreen: (_) => ProfileScreen(),
    homeScreen: (_) => const HomeScreen(),
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const HomeScreen(),
    );
  }
}
