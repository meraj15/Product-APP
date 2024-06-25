import 'package:flutter/material.dart';

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
              debugPrint("Home");
            },
            child: Icon(Icons.home,
                color: myIndex == 0 ? Color(0xffdb3022) : Colors.grey),
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
                  color: myIndex == 1 ? Color(0xffdb3022) : Colors.grey)),
          label: 'Shop',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
            onTap: () {
              myIndex = 2;
              setState(() {});
              debugPrint("shop");
            },
            child: Icon(
              Icons.favorite_border_outlined,
              color: myIndex == 2 ? Color(0xffdb3022) : Colors.grey,
            ),
          ),
          label: 'Favorites',
          backgroundColor: Colors.white,
        ),
        BottomNavigationBarItem(
          icon: GestureDetector(
              onTap: () {
                myIndex = 3;
                setState(() {});
                debugPrint("shop");
              },
              child: Icon(Icons.person,
                  color: myIndex == 3 ? Color(0xffdb3022) : Colors.grey)),
          label: 'Profile',
          backgroundColor: Colors.white,
        ),
      ],
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
    );
  }
}
