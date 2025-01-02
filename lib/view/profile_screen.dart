import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/drawer.dart';
import 'package:provider/provider.dart';

import '../widget/profile_list_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      drawer: const DrawerWidget(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My profile',
          style: GoogleFonts.pacifico(),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu, color: Colors.black),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
        //     },
        //   ),
        // ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage("assets/images/profile.png"),
                  backgroundColor: AppColor.scaffoldColor,
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Khan Meraj',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'khanmeraj1542005@gmail.com',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xff9B9B9B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children:  [
                  ProfileListItem(
                    icon: Icons.shopping_cart,
                    text: 'My orders',
                    subText: 'Already have ${context.watch<ProductData>().userAllOrders.length} orders',
                    index: 1,
                  ),
                 const ProfileListItem(
                    icon: Icons.location_on,
                    text: 'Shipping addresses',
                    subText: '3 addresses',
                    index: 2,
                  ),
                 const ProfileListItem(
                    icon: Icons.payment,
                    text: 'Payment methods',
                    subText: 'Visa **34',
                    index: 3,
                  ),
                 const ProfileListItem(
                    icon: Icons.reviews,
                    text: 'My reviews',
                    subText: 'Reviews for 4 items',
                    index: 4,
                  ),
                 const ProfileListItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    subText: 'Notifications, password',
                    index: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
