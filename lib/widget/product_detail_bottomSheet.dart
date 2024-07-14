import 'package:flutter/material.dart';
import 'package:product_app/model/model.dart';
import 'package:product_app/provider/provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'toast.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Product product;
  final Color bgColor;

  const ProductDetailBottomSheet({
    super.key,
    required this.product,
    required this.bgColor,
  });

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
      decoration: BoxDecoration(
        color: widget.bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: () {
              setState(() {
                if (isThereCard) {
                  Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
                } else {
                  if (providerRead.productSize.isNotEmpty) {
                    providerRead.addCard.add(widget.product);
                    providerRead.totalProductCards.value++;
                    providerRead.productSize = "";
                    CustomToast.showCustomToast(context, "Added Successfully");
                  } else {
                    CustomToast.showCustomToast(
                        context, 'Please select the size');
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
                  isThereCard ? 'Go to Bag' : 'Add to Bag',
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
