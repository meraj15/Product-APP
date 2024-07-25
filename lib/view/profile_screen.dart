import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/drawer.dart';

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
        title: const Text(
          'My profile',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
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
                  radius: 40,
                  backgroundImage: AssetImage("assets/profile.png"),
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
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: const [
                  ProfileListItem(
                    icon: Icons.shopping_cart,
                    text: 'My orders',
                    subText: 'Already have 4 orders',
                  ),
                  ProfileListItem(
                    icon: Icons.location_on,
                    text: 'Shipping addresses',
                    subText: '3 addresses',
                  ),
                  ProfileListItem(
                    icon: Icons.payment,
                    text: 'Payment methods',
                    subText: 'Visa **34',
                  ),
                  ProfileListItem(
                    icon: Icons.reviews,
                    text: 'My reviews',
                    subText: 'Reviews for 4 items',
                  ),
                  ProfileListItem(
                    icon: Icons.settings,
                    text: 'Settings',
                    subText: 'Notifications, password',
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
