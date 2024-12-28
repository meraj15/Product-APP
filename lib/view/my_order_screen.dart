import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/view/order_items_screen.dart';
import 'package:provider/provider.dart';

class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  

  @override
  void initState() {
    super.initState();
   context.read<ProductData>().fetchMyAllOrders(userID);
  }

  

  @override
  Widget build(BuildContext context) {
    final providerRead = context.watch<ProductData>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),
      body: providerRead.isOrderAllLoading
          ? const Center(child: CircularProgressIndicator())
          : providerRead.userAllOrders.isEmpty
              ? const Center(child: Text("No orders found."))
              : ListView.builder(
                  itemCount: providerRead.userAllOrders.length,
                  itemBuilder: (context, index) {
                    final order = providerRead.userAllOrders[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Name: ${order['name']}"),
                            Text("Status: ${order['order_status']}"),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Price: ₹${order['price']}"),
                            Text("Address: ${order['address']}"),
                            Text("Mobile: ${order['mobile']}"),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderItems(
                                orderId: order['order_id'],
                                orderstatus: order['order_status'],
                                userAddress: order['address'],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
