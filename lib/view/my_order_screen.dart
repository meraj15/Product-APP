import 'package:flutter/material.dart';
import 'package:product_app/constant/contant.dart';
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
  Widget build(BuildContext context) {
    final providerRead = context.watch<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: providerRead.isOrderAllLoading
            ? const Center(child:  CircularProgressIndicator())
            : providerRead.userAllOrders.isEmpty
                ? const Center(child: Text("No orders available."))
                : ListView.builder(
                    itemCount: providerRead.userAllOrders.length,
                    itemBuilder: (context, index) {
                      final order = providerRead.userAllOrders[index];
                      return Container(
                        width: 334,
                        height: 164,
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 3,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Order ID: ${order['order_id']}",
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xff222222),
                                  ),
                                ),
                                Text(
                                  order['order_date'],
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Name: ${order['name']}",
                              style: const TextStyle(
                                  fontSize: 14, color: Color(0xff9B9B9B)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Total: \$${double.parse(order['price'].toString()).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                            //  Text(
                            //      "No. of Products: ${order['products']?.length ?? 0}",
                            //       style: const TextStyle(
                            //           fontSize: 14, color: Color(0xff9B9B9B)),
                            //     ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    await context
                                        .read<ProductData>()
                                        .getOrderItems(order['order_id']);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => OrderItems(
                                          orderId: order['order_id'],
                                          orderstatus: order['order_status'],
                                          userAddress: order['address'],
                                          orderDate: order['order_date'],
                                        ),
                                      ),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide.none,
                                    backgroundColor: AppColor.appMainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24),
                                    ),
                                  ),
                                  child: const Text(
                                    "Details",
                                    style:
                                        TextStyle(color: AppColor.whiteColor),
                                  ),
                                ),
                                Text(
                                  order['order_status'],
                                  style: TextStyle(
                                    color: order['order_status'] == "Delivered"
                                        ? const Color(0xff2AA952)
                                        : Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
