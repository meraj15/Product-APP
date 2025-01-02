import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';

import '../routes/app_routes.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    postData();
    super.initState();
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: [
          // Centered content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset("assets/images/bags.svg"),
                const SizedBox(height: 20),
                const Text(
                  "Success!",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff000000),
                  ),
                ),
                const SizedBox(height: 8),
                const Text("Your order will be delivered soon."),
                const Text("Thank you for choosing our app!"),
              ],
            ),
          ),
          // Button at the bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(AppRoutes.bottemNavigationBar);
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text(
                    "CONTINUE SHOPPING",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),  
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  void postData() async {
    final response = await http.post(
      Uri.parse('http://192.168.0.110:3000/api/userOrders'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "id": 101,
        "userid": userID,
      }),
    );
    final data = jsonDecode(response.body);

    if (data['message'] == "Order placed successfully") {
      deleteAllCarts();
    }
  }

  void deleteAllCarts() async {
    try {
      final url = Uri.parse('http://192.168.0.110:3000/api/carts');
      final response = await http.delete(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        debugPrint("All cards deleted: ${responseData['message']}");
      } else if (response.statusCode == 404) {
        debugPrint("No cards found to delete: ${response.body}");
      } else {
        debugPrint("Failed to delete all cards: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
  }
}
