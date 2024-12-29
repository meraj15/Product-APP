import 'package:flutter/material.dart';
import 'package:product_app/model/product.dart';
import 'package:product_app/provider/product_provider.dart';
import 'package:product_app/routes/app_routes.dart';
import 'package:provider/provider.dart';

import 'toast.dart';

class ProductDetailBottomSheet extends StatefulWidget {
  final Product product;
  final Color bgColor;
  final Map<String, dynamic> pdata;

  const ProductDetailBottomSheet({
    super.key,
    required this.product,
    required this.bgColor,
    required this.pdata,
  });

  @override
  State<ProductDetailBottomSheet> createState() =>
      _ProductDetailBottomSheetState();
}

class _ProductDetailBottomSheetState extends State<ProductDetailBottomSheet> {
  @override
  Widget build(BuildContext context) {
    final providerRead = context.read<ProductData>();
    final isThereInCart = context.watch<ProductData>().addCard.contains(widget.product);

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
              if (isThereInCart) {
               
                Navigator.of(context).pushNamed(AppRoutes.addCardScreen);
              } else {
               
                if (providerRead.productSize.isNotEmpty) {
                  providerRead.postcartsData(widget.pdata);
                  providerRead.addCard.add(widget.product); 
                  providerRead.productSize = "";
                  providerRead.addCardLength = providerRead.addCard.length;
                  CustomToast.showCustomToast(context, "Added Successfully");
                  setState(() {});
                } else {
                  CustomToast.showCustomToast(context, 'Please select the size');
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  isThereInCart ? 'Go to Bag' : 'Add to Bag',
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
