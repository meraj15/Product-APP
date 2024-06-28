import 'package:flutter/material.dart';

import '../constant/contant.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
           _buildCategoryButton("Fragrance"),
              _buildCategoryButton("Skincare"),
              _buildCategoryButton("Makeup"),
        ],
      ),
    );
  }

    Widget _buildCategoryButton(String category) {
    return Container(
      width: 100,
      height: 35,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          category,
          style:const TextStyle(
            color: AppColor.whiteColor,
          ),
        ),
      ),
    );
  }
}