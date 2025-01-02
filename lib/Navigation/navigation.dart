import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/view/favorite_card.dart';
import 'package:product_app/view/home_screen.dart';
import 'package:provider/provider.dart';

import '../view/profile_screen.dart';
import '../view/shop_screen.dart';

class BottemNavigationBar extends StatefulWidget {
  const BottemNavigationBar({super.key});

  @override
  State<BottemNavigationBar> createState() => _BottemNavigationBarState();
}

class _BottemNavigationBarState extends State<BottemNavigationBar> {
  int selectedIndex = 0;
  @override
  void initState() {
    context.read<ProductData>().getCartsData(userID);
    context.read<ProductData>().getFavouriteData(userID);
    context.read<ProductData>().getData();
    context.read<ProductData>().getAddressData();
    context.read<ProductData>().fetchMyAllOrders(userID);


    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        backgroundColor: AppColor.scaffoldColor,
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations:  <NavigationDestination>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.home,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: Icon(Icons.home),
            label: "Home",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.shopping_cart,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: Icon(Icons.shopping_cart),
            label: "Shop",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.favorite,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: Icon(Icons.favorite),
            label: "Favorite",
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.person,
              color: Theme.of(context).colorScheme.primary,
            ),
            icon: Icon(Icons.person),
            label: "Person",
          ),
        ],
      ),
      body: switch(selectedIndex){
       0 => HomeScreen(),
       1 => ShopScreen(),
       2 => Favorites(),
       3 => ProfileScreen(),
       _ => Scaffold(body: Center(child: Text('Naha Le'),),)
      },
    );
  }
}
