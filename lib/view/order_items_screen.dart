import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:printing/printing.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/widget/invoice_pdf.dart';
import 'package:product_app/widget/review_bottemSheet.dart';
import 'package:provider/provider.dart';

class OrderItems extends StatefulWidget {
  final String orderId;
  final String orderstatus;
  final String userAddress;
  final String orderDate;

  const OrderItems({
    super.key,
    required this.orderId,
    required this.orderstatus,
    required this.userAddress,
    required this.orderDate,
  });

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductData>().getOrderItems(widget.orderId);
      context.read<ProductData>().fetchUserOrders(context);
    });
  }

  void _showReviewBottomSheet(BuildContext context, int productId,
      String productTitle, String productThumbnail) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColor.scaffoldColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return ReviewBottomSheet(
              productId: productId,
              productTitle: productTitle,
              productThumbnail: productThumbnail,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final orderedItems = context.watch<ProductData>().orderedItems;

    if (orderedItems.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.primary,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        title: const Text(
          "Order Details",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: providerRead.orderedItems.isEmpty
          ? Center(
              child: Lottie.asset(
                  "assets/lottie_animation/product_not_selected.json"),
            )
          : Consumer<ProductData>(
              builder: (context, productData, child) {
                final cartItems = providerRead.orderedItems;

                if (cartItems.isEmpty) {
                  return const Center(
                    child: Text(
                      "No items found for this order.",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];
                      final orderQuantity = providerRead.orderItemsQuantityList;
                      return Container(
                        height: 110,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(blurRadius: 5.0, color: Colors.black12),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.thumbnail,
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, size: 20);
                              },
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  Text(
                                    product.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Text(
                                      "Brand: ${product.brand}",
                                      style: const TextStyle(
                                          fontSize: 13, color: Colors.black54),
                                    ),
                                  ),
                                  Text(
                                    "Quantity: ${orderQuantity[index]['quantity']}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black54),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 6.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        widget.orderstatus == "Delivered"
                                            ? TextButton.icon(
                                                onPressed: () {
                                                  _showReviewBottomSheet(
                                                      context,
                                                      product.id,
                                                      product.title,
                                                      product.thumbnail);
                                                },
                                                icon: const Icon(Icons.edit,
                                                    size: 16,
                                                    color: Colors.blue),
                                                label: const Text(
                                                  'Write a review',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.blue),
                                                ),
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                              )
                                            : const SizedBox(),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Text(
                                            "\$${product.price.toString()}",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      bottomSheet: widget.orderstatus == "Delivered"
          ? GestureDetector(
              onTap: () async {
                final pdf = await InvoicePdfWidget.generateInvoicePdf(
                  widget.orderId,
                  widget.orderDate,
                  widget.userAddress,
                  providerRead.orderedItems,
                  providerRead.orderUsername,
                );
                await Printing.sharePdf(
                    bytes: await pdf.save(), filename: 'invoice.pdf');
              },
              child: Container(
                width: double.infinity,
                height: 50,
                decoration:
                    BoxDecoration(color: Theme.of(context).colorScheme.primary),
                child: const Center(
                  child: Text(
                    "Download Invoice PDF",
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
