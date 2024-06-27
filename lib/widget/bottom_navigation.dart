import 'package:flutter/material.dart';
import 'package:product_app/view/favorite_card.dart';

import '../constant/contant.dart';
import '../view/home_screen.dart';

class BottemNavigation extends StatefulWidget {
  const BottemNavigation({super.key});

  @override
  State<BottemNavigation> createState() => _BottemNavigationState();
}

class _BottemNavigationState extends State<BottemNavigation> {
  int myIndex = 0;
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // onTap: (index) {
      //   myIndex = index;
      //   setState(() {});
      // },
      currentIndex: myIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              myIndex = 0;
              setState(() {});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return HomeScreen();
                  },
                ),
              );
              debugPrint("Home");
            },
            child: Icon(Icons.home,
                color: myIndex == 0 ? AppColor.appMainColor : Colors.grey),
          ),
          label: 'Home',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
              onTap: () {
                myIndex = 1;
                setState(() {});
                debugPrint("shop");
              },
              child: Icon(Icons.shopping_cart_outlined,
                  color: myIndex == 1 ? AppColor.appMainColor : Colors.grey)),
          label: 'Shop',
          backgroundColor: AppColor.whiteColor,
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              myIndex = 2;
              setState(() {});
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return Favorites();
                  },
                ),
              );
              debugPrint("shop");
            },
            child: Icon(
              Icons.favorite_border_outlined,
              color: myIndex == 2 ? AppColor.appMainColor : Colors.grey,
            ),
          ),
          label: 'Favorites',
          backgroundColor: AppColor.whiteColor,
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
              onTap: () {
                myIndex = 3;
                setState(() {});
                debugPrint("shop");
              },
              child: Icon(Icons.person,
                  color: myIndex == 3 ? AppColor.appMainColor : Colors.grey)),
          label: 'Profile',
          backgroundColor: AppColor.whiteColor,
        ),
      ],
      selectedItemColor: AppColor.appMainColor,
      unselectedItemColor: Colors.grey,
    );
  }
}
