import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';

class PromoCard extends StatelessWidget {
  const PromoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration: BoxDecoration(
        color: AppColor.appMainColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Get the special promo now",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "50 % OFF",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            bottom: 0,
            child: Image.network(
              'https://cdn.dummyjson.com/products/images/womens-watches/Rolex%20Cellini%20Moonphase/thumbnail.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
