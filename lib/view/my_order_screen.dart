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
  void initState() {
    super.initState();
    context.read<ProductData>().fetchMyAllOrders(context);
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProductData>();
    return Scaffold(
      backgroundColor: AppColor.scaffoldColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "My Orders",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: provider.isOrderAllLoading
            ? const Center(child: CircularProgressIndicator())
            : provider.userAllOrders.isEmpty
                ? const Center(child: Text("No orders available."))
                : ListView.builder(
                    itemCount: provider.userAllOrders.length,
                    itemBuilder: (context, index) {
                      final order = provider.userAllOrders[index];
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(8),
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
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      order['order_date'],
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                    if (order['order_status'] != "Delivered" &&
                                        order['order_status'] != "Cancelled")
                                      GestureDetector(
                                        onTapDown: (details) async {
                                          final value = await showMenu<String>(
                                            context: context,
                                            position: RelativeRect.fromLTRB(
                                              details.globalPosition.dx - 100,
                                              details.globalPosition.dy,
                                              details.globalPosition.dx,
                                              details.globalPosition.dy + 40,
                                            ),
                                            items:  [
                                              PopupMenuItem<String>(
                                                value: 'Cancel Order',
                                                child: Text('Cancel Order',style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                                              ),
                                            ],
                                          );
                                          if (value == 'Cancel Order') {
                                            order['order_status'] = 'Cancelled';
                                            setState(() {});
                                            provider.updateOrderStatus(
                                              order['order_id'],
                                              'Cancelled',
                                            );
                                          }
                                        },
                                        child: const Icon(Icons.more_vert),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Name: ${order['name']}",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Total: \$${double.parse(order['price'].toString()).toStringAsFixed(2)}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    await provider
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
                                      borderRadius: BorderRadius.circular(20),
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