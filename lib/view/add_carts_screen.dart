import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:product_app/widget/checkout_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AddCard extends StatefulWidget {
  const AddCard({super.key});

  @override
  State<AddCard> createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whiteColor,
      appBar: AppBar(
        title: Text(
          "My Bag",
          style: GoogleFonts.pacifico(
            color: AppColor.scaffoldColor,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(color: AppColor.whiteColor),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.bottemNavigationBar);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<ProductData>(
              builder: (context, productData, child) {
                final cartItems = productData.addCard;
                if (cartItems.isEmpty) {
                  return Center(
                    child: Lottie.asset(
                        "assets/lottie_animation/product_not_selected.json"),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartItems[index];

                      return Slidable(
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {
                                productData.deleteCartData(index);
                              },
                              backgroundColor: AppColor.whiteColor,
                              foregroundColor:
                                  Theme.of(context).colorScheme.primary,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 130,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Image.network(
                                      product.thumbnail,
                                      width: 115,
                                      height: 130,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            product.title,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                              color: Color(0xff222222),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Brand: ${product.brand}',
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xffEEEEEE),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            if (product
                                                                    .productQuantity >
                                                                1) {
                                                              product
                                                                  .productQuantity--;
                                                              productData
                                                                  .updatedCartQuantities
                                                                  .add({
                                                                'id':
                                                                    product.id,
                                                                'quantity': product
                                                                    .productQuantity,
                                                              });
                                                              productData
                                                                  .updateTotalAmount();
                                                            }
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 28,
                                                          height: 28,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: AppColor
                                                                .whiteColor,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                            Icons.remove,
                                                            color:
                                                                Colors.black54,
                                                            size: 18.0,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Text(
                                                          product
                                                              .productQuantity
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        ),
                                                      ),
                                                      GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            product
                                                                .productQuantity++;
                                                            productData
                                                                .updatedCartQuantities
                                                                .add({
                                                              'id': product.id,
                                                              'quantity': product
                                                                  .productQuantity,
                                                            });
                                                            productData
                                                                .updateTotalAmount();
                                                          });
                                                        },
                                                        child: Container(
                                                          width: 28,
                                                          height: 28,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color: AppColor
                                                                .whiteColor,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: const Icon(
                                                            Icons.add,
                                                            color: Colors.grey,
                                                            size: 18.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  const Text("\$"),
                                                  Text(
                                                    "${(product.price * product.productQuantity).toStringAsFixed(2)}",
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                              color: Color(0xffEEEEEE),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          if (context.watch<ProductData>().addCard.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 5,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your promo code',
                        suffixIcon: Icon(Icons.arrow_forward),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Consumer<ProductData>(
                      builder: (context, productData, child) {
                        productData.updateTotalAmount();

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total amount : ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                "\$${productData.totalAmount.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 17,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  CheckoutButton(
                    pdata: context.read<ProductData>().updatedCartQuantities,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
