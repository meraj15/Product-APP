import 'package:flutter/material.dart';
import 'package:product_app/model/model.dart';
import 'package:product_app/provider/provider.dart';
import 'package:product_app/widget/product_detail_bottomSheet.dart';
import 'package:provider/provider.dart';

import 'size_option.dart';
import 'size_selector.dart';

class SizeShowModelBottomSheet extends StatefulWidget {
  final Product product;
  SizeShowModelBottomSheet({super.key, required this.product});

  @override
  State<SizeShowModelBottomSheet> createState() =>
      _SizeShowModelBottomSheetState();
}

class _SizeShowModelBottomSheetState extends State<SizeShowModelBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("⭐ ${widget.product.rating} (320 reviews)"),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Color(0xfff3f3f3),
                    border: Border.all(
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 5,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Color(0xff9B9B9B),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          "Select size",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Consumer<ProductData>(
                        builder: (context, watchProvider, child) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizeOption(
                                      context: context,
                                      provider: watchProvider,
                                      size: "XS"),
                                  SizeOption(
                                      context: context,
                                      provider: watchProvider,
                                      size: "S"),
                                  SizeOption(
                                      context: context,
                                      provider: watchProvider,
                                      size: "M"),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizeOption(
                                      context: context,
                                      provider: watchProvider,
                                      size: "L"),
                                  SizeOption(
                                      context: context,
                                      provider: watchProvider,
                                      size: "XL"),
                                  SizeOption(
                                      context: context,
                                      provider: watchProvider,
                                      size: "XLL"),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(
                        height: 19,
                      ),
                      ProductDetailBottomSheet(
                        product: widget.product,
                      )
                    ],
                  ),
                );
              },
            );
          },
          child: SizeSelector(),
        ),
      ],
    );
  }
}
