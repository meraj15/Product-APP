import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:product_app/constant/contant.dart';
import 'package:product_app/model/model.dart';
import 'package:product_app/provider/provider.dart';
import 'package:provider/provider.dart';

import '../view/add_cart.dart';

// ignore: must_be_immutable
class ProductDetailBottomSheet extends StatefulWidget {
  Product product;
  ProductDetailBottomSheet({super.key, required this.product});

  @override
  State<ProductDetailBottomSheet> createState() =>
      _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final isThereCard =
        context.watch<ProductData>().addCard.contains(widget.product);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xfff3f3f3),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              setState(() {
                if (isThereCard) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return const AddCard();
                      },
                    ),
                  );
                } else {
                  if (providerRead.productSize.isNotEmpty) {
                    providerRead.addCard.add(widget.product);
                    providerRead.totalProductCards.value++;
                    providerRead.productSize = "";
                    // ScaffoldMessenger.of(context).showSnackBar(
                    //  const SnackBar(
                    //     duration: Duration(microseconds: 500),
                    //     content: Text("Added Sucessfully"),
                    //   ),
                    // );
                  } else {
                    showToastWidget(
                        Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 60),
                          height: 40,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: AppColor.appMainColor,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Please select the size',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        context: context,
                        isIgnoring: false,
                        duration: const Duration(seconds: 2),
                        position: StyledToastPosition.top,
                        animDuration: const Duration(milliseconds: 600));
                  }
                }
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xffdb3022),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  isThereCard ? 'go to bag' : 'Add to Bag',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
