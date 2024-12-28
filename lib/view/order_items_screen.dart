import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:provider/provider.dart';

class OrderItems extends StatefulWidget {
  final String orderId;
  final String orderstatus;
  final String userAddress;

  const OrderItems(
      {super.key,
      required this.orderId,
      required this.orderstatus,
      required this.userAddress});

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
 
  @override
  void initState() {
    super.initState();
    context.read<ProductData>().getOrderItems(widget.orderId);
    context.read<ProductData>().fetchUserOrders(userID);
  }

  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Details"),
      ),
      body: providerRead.orderedItems.isEmpty
          ? const Center(child: Text("No items found for this order."))
          : Consumer<ProductData>(
        builder: (context, productData, child) {
          final cartItems = providerRead.orderedItems;
          if (cartItems.isEmpty) {
            return Center(
              child: Lottie.asset(
                  "assets/lottie_animation/product_not_selected.json"),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 17),
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                final isFavorite = productData.favorite.contains(product);

                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10.0,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  child: Row(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          // product.images.first,
                          product.thumbnail,
                          width: 115,
                          height: 130,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              product.title,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Color(0xff222222),
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                              'Brand: ${product.brand}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                               Text(
                              'Quantity: ${product.brand}',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                                Text(
                                  "\$${product.price.toString()}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColor.appMainColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.returnPolicy,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            )
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
    
     
      bottomSheet: GestureDetector(
        onTap: () async {
          if (widget.orderstatus == "Delivered") {
            final pdf = await _generateInvoicePdf();
            await Printing.sharePdf(
                bytes: await pdf.save(), filename: 'invoice.pdf');
          }
        },
        child: Container(
          width: double.infinity,
          height: 50,
          decoration: const BoxDecoration(color: Colors.orange),
          child: const Center(
            child: Text(
              "Generate Invoice PDF",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  

  Future<pw.Document> _generateInvoicePdf() async {
    final providerRead = context.read<ProductData>();

    final pdf = pw.Document();

    final finalAddress = widget.userAddress.split(',');
    final addressLine1 = finalAddress.length >= 2
        ? "${finalAddress[0].trim()}, ${finalAddress[1].trim()}"
        : widget.userAddress;
    final addressLine2 = finalAddress.length >= 4
        ? "${finalAddress[2].trim()}, ${finalAddress[3].trim()}"
        : "";

    final List<List<String>> tableData = providerRead.orderedItems.map((item) {
      return [
        item.title,
        "1",
        "\$${item.price.toString()}",
        "\$${item.price.toString()}"
      ];
    }).toList();

    final double subtotal =
        providerRead.orderedItems.fold(0.0, (sum, item) => sum + item.price);
    final double tax = subtotal * 0.1;
    final double total = subtotal + tax;
    pdf.addPage(
      pw.MultiPage(
        pageTheme: const pw.PageTheme(margin: pw.EdgeInsets.all(32)),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
          ),
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('E-commerce App',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 4),
                  pw.Text('123, AM Company'),
                  pw.SizedBox(height: 4),
                  pw.Text('Mumbai, India'),
                  pw.SizedBox(height: 4),
                  pw.Text('Email: am@gmail.com'),
                ],
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Order ID: ${widget.orderId}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Order Date: 2024-12-22'),
                  pw.SizedBox(height: 4),
                  pw.Text('Invoice Date: 2024-12-22'),
                  pw.SizedBox(height: 4),
                  pw.Text('Due Date: 2025-01-05'),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text('Bill To:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
              )),
          pw.SizedBox(height: 4),
          pw.Text(providerRead.orderUsername),
          pw.Text(addressLine1),
          pw.Text(addressLine2),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            border: pw.TableBorder.all(color: PdfColors.grey),
            headers: ['Item', 'Quantity', 'Unit Price', 'Total'],
            data: tableData,
            cellAlignment: pw.Alignment.centerLeft,
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: pw.TextStyle(fontSize: 10),
            headerDecoration: pw.BoxDecoration(
              color: PdfColors.grey300,
            ),
            cellPadding: const pw.EdgeInsets.all(8),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Subtotal: \$${subtotal.toStringAsFixed(2)}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Tax (10%): \$${tax.toStringAsFixed(2)}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Total: \$${total.toStringAsFixed(2)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Text(
            'Thank you for your business!',
            style: pw.TextStyle(
              fontStyle: pw.FontStyle.italic,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );

    return pdf;
  }


}
