import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/main.dart';

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
      appBar: AppBar(
        title: Text("Order Screen"),
      ),
      body: Column(
        children: [Center(child: Text("Order Screen"))],
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
