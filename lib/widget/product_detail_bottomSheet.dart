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
    final isThereCard =
        context.watch<ProductData>().addCard.contains(widget.product);

    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      height: 70,
      decoration: BoxDecoration(
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
                        return AddCard();
                      },
                    ),
                  );
                } else {
                  if (context.read<ProductData>().productSize.isNotEmpty) {
                    context.read<ProductData>().addCard.add(widget.product);
                    context.read<ProductData>().totalProductCards.value++;
                    context.read<ProductData>().productSize = "";
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(microseconds: 500),
                        content: Text("Added Sucessfully"),
                      ),
                    );
                  } else {
                    showToastWidget(
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 60),
                          height: 40,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            color: AppColor.appMainColor,
                          ),
                          child: Row(
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
                        duration: Duration(seconds: 2),
                        position: StyledToastPosition.top,
                        animDuration: Duration(milliseconds: 600));
                  }
                }
              });
            },
            style: FilledButton.styleFrom(
              backgroundColor: Color(0xffdb3022),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shopping_bag_outlined, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  isThereCard ? 'go to bag' : 'Add to Bag',
                  style: TextStyle(
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
