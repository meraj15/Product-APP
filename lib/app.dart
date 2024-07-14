import 'package:flutter/material.dart';

import 'Navigation/navigation.dart';
import 'view/add_cart.dart';
import 'view/favorite_card.dart';
import 'view/home_screen.dart';
import 'view/profile_screen.dart';
import 'view/shop_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "HomeScreen",
      routes: {
        "/": (_) => const BottemNavigationBar(),
        "shop_screen": (_) => const ShopScreen(),
        "favorite_screen": (_) => const Favorites(),
        "add_card_screen": (_) => const AddCard(),
        "profile_screen": (_) => ProfileScreen(),
        "home_screen": (_) => const HomeScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        );
      },
    );
  }
}
//

 