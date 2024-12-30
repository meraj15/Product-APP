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
        title: const Text("My Orders",style: TextStyle(color: Colors.white),),
      ),
      body: providerRead.isOrderAllLoading
          ? const Center(child: CircularProgressIndicator())
          : providerRead.userAllOrders.isEmpty
              ? const Center(child: Text("No orders found."))
              : ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: providerRead.userAllOrders.length,
                  itemBuilder: (context, index) {
                    final order = providerRead.userAllOrders[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Name: ${order['name']}",
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              "Status : ${order['order_status']}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: order['order_status'] == 'Delivered'
                                    ? Colors.green
                                    : Colors.red,
                                    fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text("Price: ₹${order['price']}",
                                style: const TextStyle(fontSize: 14,color: Colors.black54)),
                            const SizedBox(height: 3),

                            Text("Address: ${order['address']}",
                                style: const TextStyle(fontSize: 14,color: Colors.black54)),
                            const SizedBox(height: 3),

                            Text("Mobile: ${order['mobile']}",
                                style: const TextStyle(fontSize: 14,color: Colors.black54)),
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