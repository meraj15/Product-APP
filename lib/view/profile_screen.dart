import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/drawer.dart';
import 'package:provider/provider.dart';

import '../widget/profile_list_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getUserDetail(userID);
  }

  @override
  Widget build(BuildContext context) {
    final providerWatch = context.watch<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
     
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'My profile',
          style: GoogleFonts.pacifico(),
        ),
        centerTitle: true,
        leading:   IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
            },
          ),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu, color: Colors.black),
        //     onPressed: () {
        //       Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
        //     },
        //   ),
        // ],
      ),
      body: providerWatch.userDetails.isEmpty
          ? Center(
              child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            providerWatch.getInitials(
                                providerWatch.userDetails[0]["name"]),
                            style: const TextStyle(
                              fontSize: 30,
                              color: AppColor.whiteColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            providerWatch.userDetails[0]["name"],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            providerWatch.userDetails[0]["email"],
                            style: const TextStyle(
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
                      children: [
                        ProfileListItem(
                          icon: Icons.shopping_cart,
                          text: 'My orders',
                          subText:
                              'Already have ${context.watch<ProductData>().userAllOrders.length} orders',
                          index: 1,
                        ),
                        ProfileListItem(
                          icon: Icons.reviews,
                          text: 'My reviews',
                          subText:
                              'You gives ${context.watch<ProductData>().userAllReviews.length} reviews',
                          index: 2,
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
