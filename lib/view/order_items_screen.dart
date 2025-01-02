import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/main.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/widget/review_bottemSheet.dart';
import 'package:provider/provider.dart';
// import 'package:image_picker/image_picker.dart';

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
    context.read<ProductData>().getOrderItems(widget.orderId);
    context.read<ProductData>().fetchUserOrders(userID);
  }

 int selectedStars = 0;
  final TextEditingController _reviewController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;

  void _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _selectedImage = photo;
      });
    }
  }

  void _showReviewBottomSheet(BuildContext context) {
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
          initialChildSize: 0.76,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, controller) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 100),
                    child: Container(
                      width: 70,
                      height: 6,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3),
                        color: Color(0xff9b9b9b),
                      ),
                    ),
                  ),
                  const Text(
                    "What is you rate?",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff222222)),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedStars
                              ? Icons.star
                              : Icons.star_border_outlined,
                          color: index < selectedStars
                              ? Colors.yellow
                              : Colors.grey,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedStars = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Please share your opinion \nabout the product",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff222222)),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _reviewController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        fillColor: AppColor.whiteColor,
                        hintText: "Your review",
                        hintStyle: TextStyle(
                          color: Color(0xff9b9b9b),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: _openCamera,
                        child: Container(
                          height: 122,
                          width: 133,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade300,
                                blurRadius: 1,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.camera_alt,
                                  color: Colors.red, size: 50),
                              const SizedBox(height: 8),
                              Text(
                                _selectedImage == null
                                    ? "Add your photos"
                                    : "Photo Added",
                                style: const TextStyle(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final reviewText = _reviewController.text.trim();
                          if (reviewText.isEmpty || selectedStars == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Please provide a rating and a review."),
                              ),
                            );
                            return;
                          }
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Review submitted successfully!"),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        child: const Text(
                          "SEND REVIEW",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColor.whiteColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppColor.whiteColor,
        ),
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
                            BoxShadow(
                              blurRadius: 5.0,
                              color: Colors.black12,
                            ),
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
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment:
                                //     MainAxisAlignment.center,
                                children: [
                                  Text(
                                    product.title,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "Brand: ${product.brand}",
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "Quantity: ${orderQuantity[index]['quantity']}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 4.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () {
                                           _showReviewBottomSheet(context);
                                          },
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 16, 
                                              color: Colors.blue

                                          ),
                                          label: const Text(
                                            'Write a review',
                                            style: TextStyle(
                                              fontSize: 12, 
                                              color: Colors.blue
                                            ),
                                          ),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.only(
                                               top: 0), 
                                            minimumSize: const Size(
                                                0, 0), 
                                          ),
                                        ),
                                        Text(
                                          "\$${product.price.toString()}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        ),
                                      ],
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
      bottomSheet: widget.orderstatus == "Delivered"
          ? GestureDetector(
              onTap: () async {
                final pdf = await _generateInvoicePdf();
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
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )
          : null,
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
                  pw.Text('Order ID: ${widget.orderId}',
                      style: pw.TextStyle(fontSize: 13)),
                  pw.SizedBox(height: 4),
                  pw.Text('Order Date: ${widget.orderDate}'),
                  pw.SizedBox(height: 4),
                  pw.Text('Invoice Date: 2025-03-22'),
                  pw.SizedBox(height: 4),
                  pw.Text('Due Date: 2025-10-05'),
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
